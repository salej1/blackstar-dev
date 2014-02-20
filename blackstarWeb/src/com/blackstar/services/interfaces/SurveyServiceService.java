package com.blackstar.services.interfaces;

import java.util.List;

import com.blackstar.model.Serviceorder;
import com.blackstar.model.SurveyService;

public interface SurveyServiceService {
	
	List<Serviceorder> getServiceOrder();
	void saveSurvey(SurveyService surveyService);
	SurveyService getSurveyServiceById(Integer surveyServiceId);
}
