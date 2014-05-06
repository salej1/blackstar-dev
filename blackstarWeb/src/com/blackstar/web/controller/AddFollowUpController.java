package com.blackstar.web.controller;

import java.text.SimpleDateFormat;

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
import com.blackstar.model.Equipmenttype;
import com.blackstar.model.Office;
import com.blackstar.model.Policy;
import com.blackstar.model.Servicecenter;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.Servicetype;
import com.blackstar.model.Ticket;
import com.blackstar.model.User;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.IssueDTO;
import com.blackstar.services.EmailServiceFactory;
import com.blackstar.services.interfaces.IssueService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/addFollowUp")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class AddFollowUpController extends AbstractController{
	
	private static IssueService iServ;
	
	public void setiServ(IssueService iServ) {
		AddFollowUpController.iServ = iServ;
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
			
			return "redirect:/" + redirect;
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

private static void SendSOAssignationEmail(int osId, String employee, String who, String message){
	String officeMail = "";
	String ssMail = "";
	int ticketId;
	DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
	Ticket osTicket = null;
			
	Serviceorder so = daoFactory.getServiceOrderDAO().getServiceOrderById(osId);
	
	if(so != null)
	{
		int policiId = so.getPolicyId();
		if(policiId > 0){
			Policy po = daoFactory.getPolicyDAO().getPolicyById(policiId);
			
			ticketId = so.getTicketId();
			if(ticketId > 0){
				osTicket = daoFactory.getTicketDAO().getTicketById(ticketId);
			}
			
			if(po != null){
				char etId = po.getEquipmentTypeId();
				
				Equipmenttype et = daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(etId);
				if(et != null){
					
					Servicetype st = daoFactory.getServiceTypeDAO().getServiceTypeById(so.getServiceTypeId());
					if(st != null){
						
						// Enviar el email
						IEmailService mail = EmailServiceFactory.getEmailService();
						String to = employee + ", " + ssMail + ", " + officeMail;
						String subject = String.format("Orden de servicio %s asignada", so.getServiceOrderNumber());
						StringBuilder bodySb = new StringBuilder();
						
						bodySb.append(String.format("La orden de servicio %s le ha sido asignada para dar seguimiento. Por favor revise a continuación los detalles de la orden ", so.getServiceOrderNumber()));
						if(message != null){
							bodySb.append(" y la información adicional.");
						}
						bodySb.append(String.format("\r\n\r\n Folio: %s", so.getServiceOrderNumber()));
						bodySb.append(String.format("\r\n\r\n Cliente: %s", po.getCustomer()));
						if(osTicket != null){
							bodySb.append(String.format("\r\n\r\n No ticket: %s", osTicket.getTicketNumber()));
						}
						else{
							bodySb.append("\r\n\r\n Sin ticket asociado");
						}
						bodySb.append(String.format("\r\n\r\n Domicilio: %s", po.getEquipmentAddress()));
						bodySb.append(String.format("\r\n\r\n Solicitante: %s", po.getContactName()));
						bodySb.append(String.format("\r\n\r\n Telefono: %s", po.getContactPhone()));
						bodySb.append(String.format("\r\n\r\n Fecha y hora de llegada: %s", so.getCreated()));
						bodySb.append(String.format("\r\n\r\n Equipo: %s", et.getEquipmentType()));
						bodySb.append(String.format("\r\n\r\n Marca: %s", po.getBrand()));
						bodySb.append(String.format("\r\n\r\n Modelo: %s", po.getModel()));
						bodySb.append(String.format("\r\n\r\n No. Serie: %s", po.getSerialNumber()));
						if(osTicket != null){
							bodySb.append(String.format("\r\n\r\n Falla: %s", so.getServiceComments()));
						}
						bodySb.append(String.format("\r\n\r\n Tipo de servicio: %s", po.getSerialNumber()));
						bodySb.append(String.format("\r\n\r\n Contrato: %s", po.getCustomerContract()));
						if(message != null){
							bodySb.append(String.format("\r\n\r\n Información adicional: %s", message));
						}
						mail.sendEmail(who, to, subject, bodySb.toString());
					}
				}		
			}	
		}
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

private static void SendTicketAssignationEmail(int ticketId, String employee, String who, String message){
	String officeMail = "";
	String ssMail = "";
	String ticketNum;
	String equipmentType = "";
	DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
	
	Ticket myTicket = daoFactory.getTicketDAO().getTicketById(ticketId);
	if(myTicket != null){
		
		ticketNum = myTicket.getTicketNumber();
		
		int policyId = myTicket.getPolicyId();
		
		if(policyId > 0)
		{
			Policy tickPolicy;
			tickPolicy = daoFactory.getPolicyDAO().getPolicyById(policyId);
			
			if(tickPolicy != null){
				char officeId = tickPolicy.getOfficeId();
				
				
				try {
					Office off = null;
					// Office email
					if((int)officeId > 0){
						off = daoFactory.getOfficeDAO().getOfficeById(officeId);
						officeMail = off.getOfficeEmail();
					}
					
					char ssId = tickPolicy.getServiceCenterId();
					// Service center email
					Servicecenter ss = null;
					if(ssId > 0){
						ss = daoFactory.getServiceCenterDAO().getServiceCenterById(ssId);
						ssMail = ss.getServiceCenterEmail();
					}
					
					char eqId = tickPolicy.getEquipmentTypeId();
					// Service center email
					Equipmenttype et = null;
					if((int)eqId > 0){
						et = daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(eqId);
						equipmentType = et.getEquipmentType();
					}
					
					// Enviar el email
					IEmailService mail = EmailServiceFactory.getEmailService();
					String to = employee + ", " + ssMail + ", " + officeMail;
					String subject = String.format("Ticket %s asignado", ticketNum);
					StringBuilder bodySb = new StringBuilder();
					
					bodySb.append(String.format("El reporte de emergencia con número de ticket %s le ha sido asignado. Por favor revise a continuación los detalles del reporte ", ticketNum));
					if(message != null){
						bodySb.append(" y la invormación adicional.");
					}
					bodySb.append(String.format("\r\n\r\n Marca temporal: %s", myTicket.getCreated()));
					bodySb.append(String.format("\r\n\r\n Contacto: %s", tickPolicy.getContactName()));
					bodySb.append(String.format("\r\n\r\n Teléfono de Contacto: %s", tickPolicy.getContactPhone()));
					bodySb.append(String.format("\r\n\r\n Email de Contacto: %s", tickPolicy.getContactEmail()));
					bodySb.append(String.format("\r\n\r\n Número de serie: %s", tickPolicy.getSerialNumber()));
					bodySb.append(String.format("\r\n\r\n Observaciones: %s", myTicket.getObservations()));
					bodySb.append(String.format("\r\n\r\n Cliente: %s", tickPolicy.getCustomer()));
					bodySb.append(String.format("\r\n\r\n Equipo: %s", equipmentType));
					bodySb.append(String.format("\r\n\r\n Marca: %s", tickPolicy.getBrand()));
					bodySb.append(String.format("\r\n\r\n Modelo: %s", tickPolicy.getModel()));
					bodySb.append(String.format("\r\n\r\n Capacidad: %s", tickPolicy.getCapacity()));
					bodySb.append(String.format("\r\n\r\n Tiempo de respuesta compromiso: %s", tickPolicy.getResponseTimeHR()));
					bodySb.append(String.format("\r\n\r\n Dirección del equipo: %s", tickPolicy.getEquipmentAddress()));
					bodySb.append(String.format("\r\n\r\n Ubicación del equipo: %s", tickPolicy.getEquipmentLocation()));
					if(tickPolicy.getIncludesParts()){
						bodySb.append(String.format("\r\n\r\n Incluye partes: %s", "SI"));
					}
					else{
						bodySb.append(String.format("\r\n\r\n Incluye partes: %s", "NO"));
					}
					bodySb.append(String.format("\r\n\r\n Excepcion partes: %s", tickPolicy.getExceptionParts()));
					bodySb.append(String.format("\r\n\r\n Centro de servicio: %s", ss.getServiceCenter()));
					bodySb.append(String.format("\r\n\r\n Oficina: %s", off.getOfficeName()));
					bodySb.append(String.format("\r\n\r\n Proyecto: %s", tickPolicy.getProject()));
					bodySb.append(String.format("\r\n\r\n Informacón adicional: %s", message));
					mail.sendEmail(who, to, subject, bodySb.toString()
							);
				} catch (Exception e) {
					Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
				}
			}
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

private static void SendIssueAssignationEmail(Integer issueId, String asignee, String sender){
	// Recuperar el issue
	IssueDTO issue = iServ.getIssueById("I", issueId);
	
	// Enviar el email
	IEmailService mail = EmailServiceFactory.getEmailService();
	String to = issue.getReferenceAsignee() + ", " + issue.getCreatedBy();
	String subject = String.format("Accion requerida por ", issue.getCreatedBy());
	StringBuilder bodySb = new StringBuilder();
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
	
	bodySb.append("Se ha registrado una acción requerida de su parte. Por favor revise los detalles para dar el seguimiento correspondiente. ");

	bodySb.append(String.format("\r\n\r\n No. de referencia: %s", issue.getReferenceNumber()));
	bodySb.append(String.format("\r\n\r\n Asignado por: %s", issue.getCreatedByUsr()));
	bodySb.append(String.format("\r\n\r\n Fecha: %s", sdf.format(issue.getCreated())));
	bodySb.append(String.format("\r\n\r\n Accion requerida: %s", issue.getTitle()));
	bodySb.append(String.format("\r\n\r\n Detalles: %s", issue.getDetail() != null?issue.getDetail():"" ));
	bodySb.append(String.format("\r\n\r\n Proyecto: %s", issue.getProject()!= null?issue.getProject():""));
	bodySb.append(String.format("\r\n\r\n Cliente: %s", issue.getCustomer()!= null?issue.getCustomer():""));
	if(issue.getFollowUpList()!= null && issue.getFollowUpList().size() > 0){
		if(issue.getFollowUpList().get(0).getFollowUp() != null){
			bodySb.append(String.format("\r\n\r\n Comentario: %s", issue.getFollowUpList().get(0).getFollowUp()));
		}
	}
	
	
	mail.sendEmail(sender, to, subject, bodySb.toString());
}
}