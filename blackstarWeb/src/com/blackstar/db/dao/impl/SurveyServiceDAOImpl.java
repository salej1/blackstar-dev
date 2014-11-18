package com.blackstar.db.dao.impl;


import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.RowMapper;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.SurveyServiceDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.SurveyService;

public class SurveyServiceDAOImpl extends AbstractDAO implements SurveyServiceDAO{

	
	public Integer saveSurvey(SurveyService surveyService) {
		StringBuilder sqlBuilder = new StringBuilder();
		DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		sqlBuilder.append("CALL AddSurveyService(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);");

		
		Object[] args = new Object []{
										surveyService.getCompany(),
										""+surveyService.getName()+"",
										""+surveyService.getEmail()+"",
										""+surveyService.getPhone()+"",
										""+df.format(surveyService.getDate())+"",
										""+surveyService.getQuestionTreatment()+"",
										""+surveyService.getReasonTreatment()+"",
										""+surveyService.getQuestionIdentificationPersonal()+"",
										""+surveyService.getQuestionIdealEquipment()+"",
										""+surveyService.getReasonIdealEquipment()+"",
										""+surveyService.getQuestionTime()+"",
										""+surveyService.getReasonTime()+"",
										""+surveyService.getQuestionUniform()+"",
										""+surveyService.getReasonUniform()+"",
										""+surveyService.getScore()+"",
										""+surveyService.getSign()+"",
										""+surveyService.getSuggestion()+"",
										""+df.format(surveyService.getCreated())+"",
										""+surveyService.getCreatedBy()+"",
										""+surveyService.getCreatedByUsr()+""
										};
		
		Integer id = getJdbcTemplate().queryForInt(sqlBuilder.toString() ,args);
		
		return id;
	}


	@SuppressWarnings("unchecked")
	@Override
	public List<Serviceorder> getServiceOrder() {
		List<Serviceorder> result = null;
		try{
			result= (List<Serviceorder>) getJdbcTemplate().query("CALL GetSe", new Object[] {}, new RowMapper(){
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


	@SuppressWarnings("unchecked")
	@Override
	public SurveyService getSurveyServiceById(Integer surveyServiceId) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetSurveyServiceById(?)");
		
		SurveyService survey = (SurveyService) getJdbcTemplate().queryForObject(sqlBuilder.toString(), new Object []{surveyServiceId}, getMapperFor(SurveyService.class));
		
		return survey;
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Serviceorder> getLinkedServiceOrderList(Integer surveyServiceId) {
		String sql = "CALL GetSurveyServiceLinkedServices(?)";
				
		List<Serviceorder> retVal = (List<Serviceorder>) getJdbcTemplate().query(sql, new Object[]{surveyServiceId}, getMapperFor(Serviceorder.class));
		return retVal;
	}
	
	@Override
	public List<JSONObject> getPersonalSurveyServiceList(String user) {
		String sql = "CALL GetPersonalSurveyServiceList(?)";
		
		List<JSONObject> retVal = getJdbcTemplate().query(sql, new Object[]{user}, new JSONRowMapper());
		return retVal;
	}


	@Override
	public List<JSONObject> getAllSurveyServiceList() {
		String sql = "CALL GetAllSurveyServiceList()";
		
		List<JSONObject> retVal = getJdbcTemplate().query(sql, new JSONRowMapper());
		return retVal;
	}


	@Override
	public void LinkSurveyServiceOrder(String order, Integer surveyServiceId, String modifiedBy, String user) {
		
		String sql = "CALL AddSurveyToServiceOrder(?,?,?,?)";
		
		getJdbcTemplate().update(sql, new Object[]{order.trim(), surveyServiceId.toString(), modifiedBy, user});
		
	}


	@Override
	public List<JSONObject> getLimitedSurveyServiceList(String user) {
		String sql = "CALL GetLimitedSurveyServiceList(?)";
		
		List<JSONObject> retVal = getJdbcTemplate().query(sql, new Object[]{user}, new JSONRowMapper());
		return retVal;
	}


	@Override
	public void flagSurveyService(Integer surveyServiceId, Integer flag) {
		String sql = "CALL FlagSurveySuggestion(?,?)";
		
		getJdbcTemplate().update(sql, new Object[]{surveyServiceId, flag});
		
	}

}
