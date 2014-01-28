package com.blackstar.db.dao.impl;


import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.RowMapper;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.SurveyServiceDAO;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.SurveyService;

public class SurveyServiceDAOImpl extends AbstractDAO implements SurveyServiceDAO{

	private static final String GET_SERVICE_ORDER_BY_USER = "CALL GetServiceOrderByUser";
	
	
	public void saveSurvey(SurveyService surveyService) {
		StringBuilder sqlBuilder = new StringBuilder();
		DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		sqlBuilder.append("CALL AddSurveyService(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

		
		Object[] args = new Object []{
										surveyService.getCompany(),
										""+surveyService.getName()+"",
										""+surveyService.getEmail()+"",
										""+surveyService.getTelephone()+"",
										""+df.format(surveyService.getDate())+"",
										""+surveyService.getQuestionTreatment()+"",
										""+surveyService.getReasontreatment()+"",
										""+surveyService.getQuestionIdentificationPersonal()+"",
										""+surveyService.getQuestionIdealEquipment()+"",
										""+surveyService.getReasonIdealEquipment()+"",
										""+surveyService.getQuestionTime()+"",
										""+surveyService.getReasonTime()+"",
										""+surveyService.getQuestionUniform()+"",
										""+surveyService.getReasonUniform()+"",
										""+surveyService.getQualification()+"",
										""+surveyService.getServiceOrderId()+"", //ordenes de servicio asociadas a una encuesta de servicio ordenadas por usuario
										//"1000",
										""+surveyService.getSign()+""
										};
		
		getJdbcTemplate().update(sqlBuilder.toString() ,args);
		
		
	}


	@SuppressWarnings("unchecked")
	@Override
	public List<Serviceorder> getServiceOrder() {
		List<Serviceorder> result = null;
		try{
			result= (List<Serviceorder>) getJdbcTemplate().query(GET_SERVICE_ORDER_BY_USER, new Object[] {}, new RowMapper(){
				@Override
				public Object mapRow(java.sql.ResultSet arg0, int arg1)
						throws SQLException {
					Serviceorder serviceOrder = new Serviceorder();
					serviceOrder.setServiceOrderId(arg0.getInt("serviceOrderId"));
					serviceOrder.setServiceOrderNumber(arg0.getString("serviceOrderNumber"));
	                return serviceOrder;
				}
                }); 			
			//result = (List<Serviceorder>) getJdbcTemplate().query(query, new Object []{}, getMapperFor(Serviceorder.class));			
		}catch(DataAccessException e){
			e.printStackTrace();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		return result;
	}

}
