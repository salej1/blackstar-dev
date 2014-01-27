package com.blackstar.services.impl;


import java.util.List;

import com.blackstar.db.dao.interfaces.SurveyServiceDAO;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.SurveyService;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.SurveyServiceService;

public class SurveyServiceServiceImpl extends AbstractService  implements SurveyServiceService {

	private SurveyServiceDAO surveyServiceDAO;
	
	public void setSurveyServiceDAO(SurveyServiceDAO surveyServiceDAO) {
		this.surveyServiceDAO = surveyServiceDAO;
	}

	
	@Override
	public void saveSurvey(SurveyService surveyService) {
		surveyServiceDAO.saveSurvey(surveyService);
		
	}


	@Override
	public List<Serviceorder> getServiceOrder() {
		return surveyServiceDAO.getServiceOrder();
	}

}
