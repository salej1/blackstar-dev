package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.IndicadoresServicioDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.Servicecenter;
import com.blackstar.model.sp.GetConcurrentFailuresKPI;
import com.blackstar.model.sp.GetReportOSTableKPI;

@SuppressWarnings("unchecked")
public class IndicadoresServicioDAOImpl extends AbstractDAO 
                                        implements IndicadoresServicioDAO {
	
  public List<JSONObject> getTickets(){
	String sqlQuery = "CALL GetTicketsKPI();";
	return getJdbcTemplate().query(sqlQuery, new Object[]{}, new JSONRowMapper()); 
  }
	
  public List<JSONObject> getPolicies(){
	String sqlQuery = "CALL GetPoliciesKPI();";
	return getJdbcTemplate().query(sqlQuery, new Object[]{}, new JSONRowMapper()); 
  }
  
  
  public List<GetConcurrentFailuresKPI> getConcurrentFailures(){
	String sqlQuery = "CALL GetConcurrentFailuresKPI();";
	return (List<GetConcurrentFailuresKPI> )getJdbcTemplate().query(sqlQuery
			, new Object[]{}, getMapperFor(GetConcurrentFailuresKPI.class)); 
  }
  
  public List<JSONObject> getMaxPeportsByUser(){
	String sqlQuery = "CALL GetMaxReportsByUserKPI();";
	return getJdbcTemplate().query(sqlQuery, new Object[]{}, new JSONRowMapper()); 
  }
  
  public List<GetReportOSTableKPI> getReportOSTable() {
	String sqlQuery = "CALL GetReportOSTableKPI();";
	return (List<GetReportOSTableKPI> )getJdbcTemplate().query(sqlQuery
			, new Object[]{}, getMapperFor(GetReportOSTableKPI.class)); 
  }
  
  public List<JSONObject> getReportOSResume(){
	String sqlQuery = "CALL GetReportOSResumeKPI();";
	return getJdbcTemplate().query(sqlQuery, new Object[]{}, new JSONRowMapper()); 
  }
  
  public List<JSONObject> getOSResume(){
	String sqlQuery = "CALL GetResumenOSKPI();";
	return getJdbcTemplate().query(sqlQuery, new Object[]{}, new JSONRowMapper()); 
  }
  
  public List<JSONObject> getReportByEquipmentType(){
	String sqlQuery = "CALL GetReportsByEquipmentTypeKPI();";
	return getJdbcTemplate().query(sqlQuery, new Object[]{}, new JSONRowMapper()); 
  }
  
  public List<JSONObject> getTicketsByServiceCenter(){
	String sqlQuery = "CALL GetTicketsByServiceCenterKPI();";
	return getJdbcTemplate().query(sqlQuery, new Object[]{}, new JSONRowMapper()); 
  }
  
  public List<JSONObject> getStatus(String servicecenterId){
	String sqlQuery = "CALL GetStatusKPI(?);";
	return getJdbcTemplate().query(sqlQuery, new Object[]{servicecenterId}
	                                               , new JSONRowMapper()); 
  }
  
  public List<Servicecenter> getServiceCenterIdList(){
	String sqlQuery = "CALL GetServiceCenterIdList();";
	return (List<Servicecenter> )getJdbcTemplate().query(sqlQuery
			, new Object[]{}, getMapperFor(Servicecenter.class)); 
  }
}
