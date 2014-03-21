package com.blackstar.db.dao.impl;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.ServiceIndicatorsDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.Servicecenter;
import com.blackstar.model.sp.GetConcurrentFailuresKPI;
import com.blackstar.model.sp.GetReportOSTableKPI;
import com.blackstar.model.sp.GetStatisticsKPI;

@SuppressWarnings("unchecked")
public class ServiceIndicatorsDAOImpl extends AbstractDAO 
                                        implements ServiceIndicatorsDAO {
	
  public List<JSONObject> getTickets(){
	String sqlQuery = "CALL GetTicketsKPI()";
	return getJdbcTemplate().query(sqlQuery,  new JSONRowMapper()); 
  }
	
  public List<JSONObject> getPolicies(){
	String sqlQuery = "CALL GetPoliciesKPI()";
	return getJdbcTemplate().query(sqlQuery,  new JSONRowMapper()); 
  }
  
  
  public List<GetConcurrentFailuresKPI> getConcurrentFailures(){
	String sqlQuery = "CALL GetConcurrentFailuresKPI()";
	return (List<GetConcurrentFailuresKPI> )getJdbcTemplate().query(sqlQuery
			,  getMapperFor(GetConcurrentFailuresKPI.class)); 
  }
  
  public List<JSONObject> getMaxPeportsByUser(){
	String sqlQuery = "CALL GetMaxReportsByUserKPI()";
	return getJdbcTemplate().query(sqlQuery,  new JSONRowMapper()); 
  }
  
  public List<GetReportOSTableKPI> getReportOSTable() {
	String sqlQuery = "CALL GetReportOSTableKPI()";
	return (List<GetReportOSTableKPI> )getJdbcTemplate().query(sqlQuery
			,  getMapperFor(GetReportOSTableKPI.class)); 
  }
  
  public List<JSONObject> getReportOSResume(){
	String sqlQuery = "CALL GetReportOSResumeKPI()";
	return getJdbcTemplate().query(sqlQuery,  new JSONRowMapper()); 
  }
  
  public List<JSONObject> getOSResume(){
	String sqlQuery = "CALL GetResumeOSKPI()";
	return getJdbcTemplate().query(sqlQuery,  new JSONRowMapper()); 
  }
  
  public List<JSONObject> getReportByEquipmentType(String project, Date startDate, Date endDate, String customer){
		String sqlQuery = "CALL GetReportsByEquipmentTypeKPI(?,?,?,?)";
		return getJdbcTemplate().query(sqlQuery, new Object[]{project, startDate, endDate, customer},  new JSONRowMapper()); 
  }
  
  public List<JSONObject> getTicketsByServiceCenter(String project, Date startDate, Date endDate, String customer){
	String sqlQuery = "CALL GetTicketsByServiceCenterKPI(?,?,?,?)";
	return getJdbcTemplate().query(sqlQuery, new Object[]{project, startDate, endDate, customer},  new JSONRowMapper()); 
  }
  
  public List<JSONObject> getStatus(String servicecenterId, String project, Date startDate, Date endDate, String customer){
	String sqlQuery = "CALL GetStatusKPI(?,?,?,?,?)";
	return getJdbcTemplate().query(sqlQuery, new Object[]{servicecenterId, project, startDate, endDate, customer}
	                                               , new JSONRowMapper()); 
  }
  
  public List<Servicecenter> getServiceCenterIdList(){
	String sqlQuery = "CALL GetServiceCenterIdList()";
	return (List<Servicecenter> )getJdbcTemplate().query(sqlQuery
			,  getMapperFor(Servicecenter.class)); 
  }
  
  public List<JSONObject> getUserAverage(){
	String sqlQuery = "CALL GetUserAverageKPI()";
	return getJdbcTemplate().query(sqlQuery,  new JSONRowMapper()); 
  }
  
  public List<JSONObject> getGeneralAverage(){
	String sqlQuery = "CALL GetGeneralAverageKPI()";
	return getJdbcTemplate().query(sqlQuery,  new JSONRowMapper()); 
  }
  
  public List<GetStatisticsKPI> getStatisticsKPI(String project, Date startDate, Date endDate) {
	String sqlQuery = "CALL GetStatisticsKPI(?,?,?)";
	return (List<GetStatisticsKPI> )getJdbcTemplate().query(sqlQuery, new Object[]{project, startDate, endDate}
			                , getMapperFor(GetStatisticsKPI.class)); 
  }

	@Override
	public List<String> getProjectList() {
		String sqlQuery = "CALL GetProjectList()";
		return (List<String>) getJdbcTemplate().queryForList(sqlQuery, String.class);
	}

	@Override
	public List<String> getLimitedProjectList(String user) {
		String sqlQuery = "CALL GetLimitedProjectList(?)";
		return (List<String>) getJdbcTemplate().queryForList(sqlQuery, new Object[]{user}, String.class);
	}
}
