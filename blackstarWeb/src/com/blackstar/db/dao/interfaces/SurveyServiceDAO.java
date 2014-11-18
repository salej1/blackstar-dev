package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Serviceorder;
import com.blackstar.model.SurveyService;

public interface SurveyServiceDAO {
	
	List<Serviceorder> getServiceOrder();
	Integer saveSurvey(SurveyService surveyService);
	SurveyService getSurveyServiceById(Integer surveyServiceId);
	List<JSONObject> getPersonalSurveyServiceList(String user);
	List<JSONObject> getAllSurveyServiceList();
	List<JSONObject> getLimitedSurveyServiceList(String user);
	void LinkSurveyServiceOrder(String order, Integer surveyServiceId, String modifiedBy, String user);
	List<Serviceorder> getLinkedServiceOrderList(Integer surveyServiceId);
	void flagSurveyService(Integer surveyServiceId, Integer flag);
}
