package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Serviceorder;
import com.blackstar.model.SurveyService;

public interface SurveyServiceDAO {
	
	List<Serviceorder> getServiceOrder();
	void saveSurvey(SurveyService surveyService);

}
