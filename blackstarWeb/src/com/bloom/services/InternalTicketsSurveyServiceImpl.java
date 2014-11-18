package com.bloom.services;

import java.text.SimpleDateFormat;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.common.Globals;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.services.AbstractService;
import com.blackstar.services.EmailServiceFactory;
import com.bloom.db.dao.InternalTicketsDao;
import com.bloom.db.dao.InternalTicketsSurveyDao;
import com.bloom.model.dto.TicketTeamDTO;

public class InternalTicketsSurveyServiceImpl extends AbstractService 
                                              implements InternalTicketsSurveyService{

  private InternalTicketsSurveyDao dao;
  private InternalTicketsDao tickDao;

  public InternalTicketsSurveyDao getDao() {
	return dao;
  }

  public void setDao(InternalTicketsSurveyDao dao) {
	this.dao = dao;
  }
  
  public void setTickDao(InternalTicketsDao tickDao) {
	this.tickDao = tickDao;
}

public String getSurveyTable(Integer userId){
	List<JSONObject> jsonList = dao.getSurveyTable(userId);
	if (jsonList != null){
		return jsonList.toString();
	}
	return "";
  }
  
  public String getPendingSurveyTable(Integer userId){
	List<JSONObject> jsonList = dao.getPendingSurveyTable(userId);
	if (jsonList != null){
	  return jsonList.toString();
	}
	return "";
  }
  
  public void insertSurvey(Integer ticketId, String ticketNumber, Integer evaluation, String comments
                                            , String created, String createdByUsr) throws Exception {
	  SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");	  
	  dao.insertSurvey(ticketId, evaluation, comments, df.parse(created));

	  if(evaluation < 1){
		  List<TicketTeamDTO> team = tickDao.getTicketTeam(ticketId);
		  String to = "";
		  for(TicketTeamDTO t : team){
			  if(t.getWorkerRoleTypeId() == 1){
				  if(to.length() == 0){
					  to = t.getUserEmail();
				  }
				  else{
					  to = to + "," + t.getUserEmail();
				  }
			  }
		  }
		  
		  String link = String.format("<a href='" + Globals.GOOGLE_CONTEXT_URL + "/bloom/ticketDetail/show.do?ticketId=%s'>%s</a>", ticketId, ticketNumber);
		  String subject = "Requisición No Satisfactoria";
		  StringBuilder bodySb = new StringBuilder();
		  
		  bodySb.append("<img src='" + Globals.GPOSAC_LOGO_DEFAULT_URL + "'>");
		  bodySb.append("<div style='font-family:sans-serif;margin-left:50px;'>");
		  bodySb.append("<h3 >Requisición evaluada como no satisfactoria.</h3>");
		  bodySb.append("<p>Para su informacion:</p>");
		  bodySb.append("<p>La requisición " + ticketNumber + " ha sido evaluada como no satisfactoria por el área solicitante. </p>");
		  bodySb.append("<br>Registrado por: " + createdByUsr);
		  bodySb.append("<br>Fecha: " + created);
		  bodySb.append("<br>Comentario: " + comments);
		  bodySb.append("<br>");
		  bodySb.append("<p>En el siguiente Link podra revisar los detalles. Favor de dar el seguimiento correspondiente a esta evaluación</p>");
		  bodySb.append(link);
		  bodySb.append("</div>");
		  bodySb.append("<hr>");
		  bodySb.append("<small>Favor de no responder a este email. En caso de duda póngase en contacto con la persona que registró</small>");

		  // Enviar el email
		  IEmailService mail = EmailServiceFactory.getEmailService();
		  mail.sendEmail(Globals.GPOSAC_DEFAULT_SENDER, to, subject, bodySb.toString());
	 }
	 
  }
}
