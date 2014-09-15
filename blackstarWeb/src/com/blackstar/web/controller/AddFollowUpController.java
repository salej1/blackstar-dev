package com.blackstar.web.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.db.DAOFactory;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Office;
import com.blackstar.model.Policy;
import com.blackstar.model.Servicecenter;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.Ticket;
import com.blackstar.model.User;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.IssueDTO;
import com.blackstar.services.EmailServiceFactory;
import com.blackstar.services.interfaces.IssueService;
import com.blackstar.web.AbstractController;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.db.dao.InternalTicketsDao;
import com.bloom.model.dto.TicketDetailDTO;

@Controller
@RequestMapping("/addFollowUp")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class AddFollowUpController extends AbstractController{
	
	private static IssueService iServ;
	private static InternalTicketsDao internalTicketsDao;
	
	public void setiServ(IssueService iServ) {
		AddFollowUpController.iServ = iServ;
	}

	public void setInternalTicketsDao(InternalTicketsDao internalTicketsDao) {
		AddFollowUpController.internalTicketsDao = internalTicketsDao;
	}

	@RequestMapping(value = "/add.do", method = RequestMethod.POST)
	public String save(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession,
			@RequestParam(required = true) String id,
			@RequestParam(required = true) String type,
			@RequestParam(required = true) String sender,  // Se usa solo en caso de que falle recuperacion del usuario en sesion
			@RequestParam(required = true) String timeStamp,
			@RequestParam(required = true) String asignee,
			@RequestParam(required = true) String message,
			@RequestParam(required = true) String redirect
			) {
		
		try {
			
			BlackstarDataAccess da = new BlackstarDataAccess();
			String sql = null;
			
			User thisUser = userSession.getUser();
			
			if(thisUser != null){
				sender = thisUser.getUserEmail();
			}
			else{
				Logger.Log(LogLevel.WARNING, Thread.currentThread().getStackTrace()[1].toString(), "No se pudo recuperar el usuario de sesion", "");
			}
			if(type.equals("ticket")){
				sql = "CALL AddFollowUpToTicket(%s, '%s', '%s', '%s', '%s')";
			}
			else if(type.equals("os")){
				sql = "CALL AddFollowUpToOS(%s, '%s', '%s', '%s', '%s')";
			}
			else if(type.equals("issue")){
				sql = "CALL AddFollowUpToIssue(%s, '%s', '%s', '%s', '%s')";
			}
			
			sql = String.format(sql, id, timeStamp, sender, asignee, message);
			
			Logger.Log(LogLevel.DEBUG, Thread.currentThread().getStackTrace()[1].toString(), "Invocando asignacion de ticket: " + sql, "");
			da.executeUpdate(sql);
			
			da.closeConnection();
			
			if(type.equals("ticket")){
				int ticketId;
				try {
					ticketId = Integer.parseInt(id);
					AssignTicket(ticketId, asignee, sender, message);
				} catch (Exception e) {
					Logger.Log(LogLevel.WARNING, e.getStackTrace()[0].toString(), "Error al agrear FollowUp a ticket " + id + ". No se puede convertir ID a entero", "");
				}
			}
			else if(type.equals("os")){
				try {
					int osId = Integer.parseInt(id);
					AssignServiceOrder(osId, asignee, sender, message);
				} catch (Exception e) {
					Logger.Log(LogLevel.WARNING, e.getStackTrace()[0].toString(), "Error al agrear FollowUp a OS " + id + ". No se puede convertir ID a entero", "");
				}
			}
			else if(type.equals("issue")){
				try {
					int issueId = Integer.parseInt(id);
					AssignIssue(issueId, asignee, sender);
				} catch (Exception e) {
					Logger.Log(LogLevel.WARNING, e.getStackTrace()[0].toString(), "Error al agrear FollowUp a OS " + id + ". No se puede convertir ID a entero", "");
				}
			}
			
			return "redirect:" + redirect;
		} catch (Exception ex) {
			Logger.Log(LogLevel.ERROR,
					Thread.currentThread().getStackTrace()[1].toString(), ex);
			model.addAttribute("errorDetails", ex.getMessage());
			return "error";
		}
}


public static void AssignServiceOrder(int osId, String asignee, String who, String message){
	BlackstarDataAccess da = new BlackstarDataAccess();
		
	try {

		da.executeUpdate(String.format("CALL AssignServiceOrder('%s', '%s', '%s', '%s')", osId, asignee, who, "Dashboard"));
		
		SendSOAssignationEmail(osId, asignee, who, message);
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
	}
	finally{
		da.closeConnection();
	}
}

private static void SendSOAssignationEmail(int osId, String asignee, String who, String message){
	DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
	String timestamp;
	SimpleDateFormat sdf = new SimpleDateFormat(Globals.DATE_FORMAT_PATTERN);
			
	Serviceorder so = daoFactory.getServiceOrderDAO().getServiceOrderById(osId);
	
	if(so != null)
	{
		sdf.setTimeZone(TimeZone.getTimeZone(Globals.DEFAULT_TIME_ZONE));
		timestamp = sdf.format(new Date());
		
		SendAssignationEmail(asignee, who, who, timestamp, message, "O", so.getServiceOrderId(), so.getServiceOrderNumber());
	}
}

public static void AssignTicket(int ticketId, String asignee, String who, String message){
	BlackstarDataAccess da = new BlackstarDataAccess();
	
	try {

		da.executeUpdate(String.format("CALL AssignTicket('%s', '%s', '%s', '%s')", ticketId, asignee, who, "Dashboard"));
		
		SendTicketAssignationEmail(ticketId, asignee, who, message);
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
	}
	finally{
		da.closeConnection();
	}
}

private static void SendTicketAssignationEmail(int ticketId, String asignee, String who, String message){
	String officeMail = "No disponible";
	String ssMail = "No disponible";
	String ticketNum;
	String timestamp;
	String comment = "";
	SimpleDateFormat sdf = new SimpleDateFormat(Globals.DATE_FORMAT_PATTERN);
	DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
	
	Ticket myTicket = daoFactory.getTicketDAO().getTicketById(ticketId);
	if(myTicket != null){
		
		ticketNum = myTicket.getTicketNumber();

		try {
			
			sdf.setTimeZone(TimeZone.getTimeZone(Globals.DEFAULT_TIME_ZONE));
			timestamp = sdf.format(new Date());
			
			// Enviar el email
			
			if(message != null && message.length() > 0){
				comment = message;
			}
			SendAssignationEmail(asignee, who, who, timestamp, comment, "T", myTicket.getTicketId(), ticketNum);
					
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
	}
}


public static void AssignIssue(Integer issueId, String asignee, String sender){
	BlackstarDataAccess da = new BlackstarDataAccess();
	
	try {

		da.executeUpdate(String.format("CALL AssignIssue('%s', '%s', '%s', '%s')", issueId, asignee, sender, " AddFollowUpController"));
		
		SendIssueAssignationEmail(issueId, asignee, sender);
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
	}
	finally{
		da.closeConnection();
	}
}

private static void SendAssignationEmail(String to, String sender, String createdBy, String timestamp, String comment, String issueTypeId, Integer referenceId, String referenceNumber){
	SendAssignationEmail(to, sender, createdBy, timestamp, comment, issueTypeId, referenceId, referenceNumber, AssignType.Assign);
}
private static void SendAssignationEmail(String to, String sender, String createdBy, String timestamp, String comment, String issueTypeId, Integer referenceId, String referenceNumber, AssignType type){
	String link = "Link no disponible";
	StringBuilder bodySb = new StringBuilder();
	String objectType = null;
	
	if(issueTypeId.equalsIgnoreCase("O")){
		link = String.format("<a href='" + Globals.GOOGLE_CONTEXT_URL + "/osDetail/show.do?serviceOrderId=%s'>%s</a>", referenceId, referenceNumber);
		objectType = "Orden de servicio";
	}
	else if(issueTypeId.equalsIgnoreCase("T")){
		link = String.format("<a href='" + Globals.GOOGLE_CONTEXT_URL + "/ticketDetail?ticketId=%s'>%s</a>", referenceId, referenceNumber);
		objectType = "Ticket";
	}
	else if(issueTypeId.equalsIgnoreCase("I")){
		link = String.format("<a href='" + Globals.GOOGLE_CONTEXT_URL + "/issues/show.do?issueId=%s'>%s</a>", referenceId, referenceNumber);
		objectType = "Tarea asignada";
	}
	else if(issueTypeId.equalsIgnoreCase("R")){
		link = String.format("<a href='" + Globals.GOOGLE_CONTEXT_URL + "/bloom/ticketDetail/show.do?ticketId=%s'>%s</a>", referenceId, referenceNumber);
		objectType = "Requisición";
	}
	
	String subject = "Acción requerida por " + createdBy;
	
	if(type == AssignType.Assign){
		bodySb.append("<img src='" + Globals.GPOSAC_LOGO_DEFAULT_URL + "'>");
		bodySb.append("<div style='font-family:sans-serif;margin-left:50px;'>");
		bodySb.append("<h3 >Acción requerida</h3>");
		bodySb.append("<p>Se ha registrado una acción requerida de su parte.</p>");
		bodySb.append("<br>Asignado por: " + createdBy);
		bodySb.append("<br>Fecha: " + timestamp);
		bodySb.append("<br>Comentario: " + comment);
		bodySb.append("<br>");
		bodySb.append("<p>Haga click en el siguiente link para revisar los detalles y dar el seguimiento correspondiente</p>");
		bodySb.append(link);
		bodySb.append("</div>");
		bodySb.append("<hr>");
		bodySb.append("<small>Favor de no responder a este email. En caso de duda póngase en contacto con la persona que le asignó la tarea</small>");
	}
	else if(type == AssignType.Notify){
		subject = "Notificación de " + objectType;
		bodySb.append("<img src='" + Globals.GPOSAC_LOGO_DEFAULT_URL + "'>");
		bodySb.append("<div style='font-family:sans-serif;margin-left:50px;'>");
		bodySb.append("<h3 >Notificación de " + objectType + "</h3>");
		bodySb.append("<p>Para su informacion:</p>");
		bodySb.append("<p>Se ha registrado la " + objectType + " " + referenceNumber + "</p>");
		bodySb.append("<br>Registrado por: " + createdBy);
		bodySb.append("<br>Fecha: " + timestamp);
		bodySb.append("<br>Comentario: " + comment);
		bodySb.append("<br>");
		bodySb.append("<p>En el siguiente Link podra revisar los detalles. Por el momento no se requiere ninguna acción de su parte</p>");
		bodySb.append(link);
		bodySb.append("</div>");
		bodySb.append("<hr>");
		bodySb.append("<small>Favor de no responder a este email. En caso de duda póngase en contacto con la persona que registró</small>");
	}
	// Enviar el email
	IEmailService mail = EmailServiceFactory.getEmailService();
	mail.sendEmail(sender, to, subject, bodySb.toString());
}

private static void SendIssueAssignationEmail(Integer issueId, String asignee, String sender){
	// Recuperar el issue
	IssueDTO issue = iServ.getIssueById("I", issueId);
	
	String createdBy = "No disponible";
	String timestamp = "No disponible";
	String comment = "No disponible";
	
	if(issue.getFollowUpList() != null && issue.getFollowUpList().size() > 0){
		createdBy = issue.getFollowUpList().get(issue.getFollowUpList().size() -1).getCreatedBy();
		timestamp = issue.getFollowUpList().get(issue.getFollowUpList().size() -1).getTimeStamp();
		comment = issue.getFollowUpList().get(issue.getFollowUpList().size() -1).getFollowUp();
	}

	SendAssignationEmail(asignee, sender, createdBy, timestamp, comment, "I", issue.getReferenceId(), issue.getReferenceNumber());
}

private static void SendBloomTicketAssignationEmail(Integer ticketId, String asignee, String sender, AssignType type){
	// Recuperar el ticket
	List<TicketDetailDTO> rawDetail = internalTicketsDao.getTicketDetail(ticketId);
	if(rawDetail != null && rawDetail.size() > 0){
		TicketDetailDTO ticket = rawDetail.get(0);
		SimpleDateFormat sdf = new SimpleDateFormat(Globals.DATE_FORMAT_PATTERN);
		String createdBy = ticket.getCreatedByUsrName();
		Date created = Globals.getLocalTime();
		
		SendAssignationEmail(asignee, sender, createdBy, sdf.format(created), ticket.getDescription(), "R", ticketId, ticket.getTicketNumber(), type);
	}
	else
	{
		Logger.Log(LogLevel.ERROR, "SendBloomTicketAssignationEmail", "No se encontro ticket " + ticketId.toString(), "SendBloomTicketAssignationEmail");
	}
}

public static void AssignBloomTicket(Integer ticketId, String asignee, String sender){
BlackstarDataAccess da = new BlackstarDataAccess();
	
	try {

		da.executeUpdate(String.format("CALL AssignBloomTicket('%s', '%s', '%s')", ticketId, asignee, sender));
		
		SendBloomTicketAssignationEmail(ticketId, asignee, sender, AssignType.Assign);
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
	}
	finally{
		da.closeConnection();
	}
}


public static void NotifyBloomTicket(Integer ticketId, String who, String sender){
BlackstarDataAccess da = new BlackstarDataAccess();
	
	try {

		SendBloomTicketAssignationEmail(ticketId, who, sender, AssignType.Notify);
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
	}
	finally{
		da.closeConnection();
	}
}

public static enum AssignType{
	Assign,
	Notify
}
}
