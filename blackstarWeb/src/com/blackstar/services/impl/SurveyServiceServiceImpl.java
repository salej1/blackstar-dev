package com.blackstar.services.impl;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.common.Globals;
import com.blackstar.db.dao.interfaces.SurveyServiceDAO;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.SurveyService;
import com.blackstar.model.dto.EmployeeDTO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.EmailServiceFactory;
import com.blackstar.services.interfaces.SurveyServiceService;
import com.blackstar.services.interfaces.UserDomainService;
import com.blackstar.web.controller.SurveyServiceDetialController;

public class SurveyServiceServiceImpl extends AbstractService  implements SurveyServiceService {

	private SurveyServiceDAO surveyServiceDAO;
	private UserDomainService udService;
	
	public void setSurveyServiceDAO(SurveyServiceDAO surveyServiceDAO) {
		this.surveyServiceDAO = surveyServiceDAO;
	}

	public void setUdService(UserDomainService udService) {
		this.udService = udService;
	}
	
	@Override
	public void saveSurvey(SurveyService surveyService, String[] ordersList) {
		Integer id = surveyServiceDAO.saveSurvey(surveyService);
		surveyService.setSurveyServiceId(id);
		for(String order : ordersList){
			surveyServiceDAO.LinkSurveyServiceOrder(order, id, surveyService.getCreatedBy(), surveyService.getCreatedByUsr());
		}
		
		// enviar correo si se encuentran comentarios
		notifyComments(surveyService);
	}


	@Override
	public List<Serviceorder> getServiceOrder() {
		return surveyServiceDAO.getServiceOrder();
	}


	@Override
	public SurveyService getSurveyServiceById(Integer surveyServiceId) {
		return surveyServiceDAO.getSurveyServiceById(surveyServiceId);
		
	}


	@Override
	public List<JSONObject> getPersonalSurveyServiceList(String user) {
		return surveyServiceDAO.getPersonalSurveyServiceList(user);
	}


	@Override
	public List<JSONObject> getAllSurveyServiceList() {
		return surveyServiceDAO.getAllSurveyServiceList();
	}


	@Override
	public List<String> getSurveyLinkedServices(Integer surveyServiceId) {
		List<Serviceorder> orders = surveyServiceDAO.getLinkedServiceOrderList(surveyServiceId);
		List<String> retVal = new ArrayList<String>();
		
		if(orders != null){
			for(Serviceorder s : orders){
				retVal.add(s.getServiceOrderNumber());
			}
		}
		
		return retVal;
	}


	@Override
	public List<JSONObject> getLimitedSurveyServiceList(String user) {
		return surveyServiceDAO.getLimitedSurveyServiceList(user);
	}

	private void notifyComments(SurveyService surveyService){
		SimpleDateFormat sdf = new SimpleDateFormat(Globals.DATE_FORMAT_PATTERN);
		StringBuilder sb = new StringBuilder();
		sb.append(surveyService.getReasonTreatment());
		if(sb.length() > 0) sb.append("<br>");
		sb.append(surveyService.getReasonIdealEquipment());
		if(sb.length() > 0) sb.append("<br>");
		sb.append(surveyService.getReasonTime());
		if(sb.length() > 0) sb.append("<br>");
		sb.append(surveyService.getReasonUniform());
		
		if(sb.toString().length() > 0){
			String to = Globals.GPOSAC_CALL_CENTER_GROUP + "," + Globals.GPOSAC_QA_GROUP;
			
			StringBuilder bodySb = new StringBuilder();
			bodySb.append("<img src='" + Globals.GPOSAC_LOGO_DEFAULT_URL + "'>");
			bodySb.append("<div style='font-family:sans-serif;margin-left:50px;'>");
			bodySb.append("<h3 >Comentarios en encuesta</h3>");
			bodySb.append("<p>Se ha registrado comentarios en una encuesta de satisfacci&oacute;n al cliente.</p>");
			bodySb.append("<br>Fecha: " + sdf.format(surveyService.getCreated()));
			bodySb.append("<br>Comentarios: " + sb.toString());
			bodySb.append("<br>");
			bodySb.append("<p>Haga click en el siguiente link para revisar los detalles y dar el seguimiento correspondiente</p>");
			bodySb.append("<a href='" + Globals.GOOGLE_CONTEXT_URL + "/surveyServiceDetail/show.do?operation=2&idObject=" + surveyService.getSurveyServiceId() + "'>Encuesta de servicio " + surveyService.getSurveyServiceId() + "</a>");
			bodySb.append("</div>");
			bodySb.append("<hr>");
			bodySb.append("<small>Favor de no responder a este email. En caso de duda p&oacute;ngase en contacto con el ingeniero de servicio correspondiente</small>");
			
			// Enviar el email
			IEmailService mail = EmailServiceFactory.getEmailService();
			String subject = "Comentarios en encuesta de servicio";
			mail.sendEmail(Globals.GPOSAC_DEFAULT_SENDER, to, subject, bodySb.toString());
		}
	}

	@Override
	public void flagSurveyService(Integer surveyServiceId, Integer flag) {
		surveyServiceDAO.flagSurveyService(surveyServiceId, flag);
		
	}


}
