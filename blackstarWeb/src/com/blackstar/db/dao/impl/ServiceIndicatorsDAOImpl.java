package com.blackstar.db.dao.impl;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.ServiceIndicatorsDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.db.dao.mapper.PlainTextMapper;
import com.blackstar.model.Servicecenter;
import com.blackstar.model.dto.AvailabilityKpiDTO;
import com.blackstar.model.sp.GetConcurrentFailuresKPI;
import com.blackstar.model.sp.GetReportOSTableKPI;
import com.blackstar.model.sp.GetStatisticsKPI;

@SuppressWarnings("unchecked")
public class ServiceIndicatorsDAOImpl extends AbstractDAO 
                                        implements ServiceIndicatorsDAO {
	
  public List<JSONObject> getTickets(String project, Date startDate, Date endDate, String user){
	String sqlQuery = "CALL GetTicketsKPI(?,?,?,?)";
	return getJdbcTemplate().query(sqlQuery, new Object[]{project, startDate, endDate, user}, new JSONRowMapper()); 
  }
	
  public List<JSONObject> getPolicies(String search, String project, Date startDate, Date endDate, String user, Integer includeRenewed){
	String sqlQuery = "CALL GetPoliciesKPI(?,?,?,?,?,?)";
	return getJdbcTemplate().query(sqlQuery, new Object[]{search, project, startDate, endDate, user, includeRenewed}, new JSONRowMapper()); 
  }
  
  
  public List<GetConcurrentFailuresKPI> getConcurrentFailures(String project, Date startDate, Date endDate, String user){
	String sqlQuery = "CALL GetConcurrentFailuresKPI(?,?,?,?)";
	return (List<GetConcurrentFailuresKPI> )getJdbcTemplate().query(sqlQuery, new Object[]{project, startDate, endDate, user}
			,  getMapperFor(GetConcurrentFailuresKPI.class)); 
  }
  
  public List<JSONObject> getMaxPeportsByUser(String project, Date startDate, Date endDate){
	String sqlQuery = "CALL GetMaxReportsByUserKPI(?,?,?)";
	return getJdbcTemplate().query(sqlQuery,  new Object[]{project, startDate, endDate}, new JSONRowMapper()); 
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
  
  public List<JSONObject> getUserAverage(String project, Date startDate, Date endDate){
	String sqlQuery = "CALL GetUserAverageKPI(?,?,?)";
	return getJdbcTemplate().query(sqlQuery,  new Object[]{project, startDate, endDate}, new JSONRowMapper()); 
  }
  
  public List<JSONObject> getGeneralAverage(String project, Date startDate, Date endDate){
	String sqlQuery = "CALL GetGeneralAverageKPI(?,?,?)";
	return getJdbcTemplate().query(sqlQuery, new Object[]{project, startDate, endDate}, new JSONRowMapper()); 
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

	@Override
	public AvailabilityKpiDTO getAvailability(String project, Date startDate,
			Date endDate, String customer) {
		String sqlQuery = "CALL GetAvailabilityKPI(?,?,?,?)";
		return (AvailabilityKpiDTO)getJdbcTemplate().queryForObject(sqlQuery, new Object[]{project, startDate, endDate, customer}
				                , getMapperFor(AvailabilityKpiDTO.class)); 
	}

	@Override
	public List<String> getPoliciesExport(String search, String project,
			Date startDate, Date endDate) {
		String sqlQuery = "CALL GetPoliciesKPI(?,?,?,?,?)";
		return getJdbcTemplate().query(sqlQuery, new Object[]{search, project, startDate, endDate, ""}, new PlainTextMapper()); 
	}

	@Override
	public List<String> getTicketsExport(String search, String project,
			Date startDate, Date endDate) {
		String sqlQuery = "CALL GetTicketsKPI(?,?,?,?)";
		return getJdbcTemplate().query(sqlQuery, new Object[]{project, startDate, endDate, ""}, new PlainTextMapper()); 
	}

	@Override
	public List<String> getSOExport(String search, String project, Date startDate,
			Date endDate) {
		String sqlQuery = "CALL GetAllServiceOrders()";
		return getJdbcTemplate().query(sqlQuery, new PlainTextMapper()); 
	}

	@Override
	public List<JSONObject> getProjects(String project, Date startDate, Date endDate) {
		String sqlQuery = "CALL GetProjectsKPI(?,?,?)";
		return getJdbcTemplate().query(sqlQuery, new Object[]{project, startDate, endDate}, new JSONRowMapper()); 
	}

	@Override
	public void setEngHourCost(Double engHourCost) {
		String sqlQuery = "CALL SetEngHourCost(?)";
		getJdbcTemplate().update(sqlQuery, new Object[]{engHourCost});
	}
	
	@Override
	public Double getEngHourCost() {
		String sqlQuery = "CALL GetEngHourCost()";
		Double cost = (Double)getJdbcTemplate().queryForObject(sqlQuery, Double.class);
		return cost;
	}
}
