package com.blackstar.services.impl;


import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.SurveyServiceDAO;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.SurveyService;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.SurveyServiceService;
import com.blackstar.web.controller.SurveyServiceDetialController;

public class SurveyServiceServiceImpl extends AbstractService  implements SurveyServiceService {

	private SurveyServiceDAO surveyServiceDAO;
	
	public void setSurveyServiceDAO(SurveyServiceDAO surveyServiceDAO) {
		this.surveyServiceDAO = surveyServiceDAO;
	}

	
	@Override
	public void saveSurvey(SurveyService surveyService, String[] ordersList) {
		Integer id = surveyServiceDAO.saveSurvey(surveyService);
		for(String order : ordersList){
			surveyServiceDAO.LinkSurveyServiceOrder(order, id, surveyService.getCreatedBy(), surveyService.getCreatedByUsr());
		}
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

}
