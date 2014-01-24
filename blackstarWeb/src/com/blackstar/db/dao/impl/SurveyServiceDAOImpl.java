package com.blackstar.db.dao.impl;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.SurveyServiceDAO;
import com.blackstar.model.SurveyService;

public class SurveyServiceDAOImpl extends AbstractDAO implements SurveyServiceDAO{

	@Override
	public void saveSurvey(SurveyService surveyService) {
		StringBuilder sqlBuilder = new StringBuilder();
		DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		sqlBuilder.append("CALL AddSurveyService(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

		
		Object[] args = new Object []{
										surveyService.getCompany(),
										""+surveyService.getName()+"",
										""+surveyService.getEmail()+"",
										""+surveyService.getTelephone()+"",
										""+surveyService.getDate()+"",
										""+surveyService.getlQuestionTreatment()+"",
										""+surveyService.getReasontreatment()+"",
										""+surveyService.getlQuestionIdentificationPersonal()+"",
										""+surveyService.getlQuestionIdealEquipment()+"",
										""+surveyService.getReasonIdealEquipment()+"",
										""+surveyService.getlQuestionTime()+"",
										""+surveyService.getReasonTime()+"",
										""+surveyService.getlQuestionUniform()+"",
										""+surveyService.getReasonUniform()+"",
										""+surveyService.getQualification()+""
										//aqui deberia de ir el valor de las ordenes de servicio
																	};
		
		getJdbcTemplate().update(sqlBuilder.toString() ,args);
		
		
	}

}
