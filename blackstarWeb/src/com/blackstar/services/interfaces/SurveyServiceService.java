package com.blackstar.services.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Serviceorder;
import com.blackstar.model.SurveyService;

public interface SurveyServiceService {
	
	List<Serviceorder> getServiceOrder();
	void saveSurvey(SurveyService surveyService, String[] serviceOrderList);
	SurveyService getSurveyServiceById(Integer surveyServiceId);
	List<JSONObject> getPersonalSurveyServiceList(String user);
	List<JSONObject> getAllSurveyServiceList();
	List<String> getSurveyLinkedServices(Integer surveyServiceId);
}
