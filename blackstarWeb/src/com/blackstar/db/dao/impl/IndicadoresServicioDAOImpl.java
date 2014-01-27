package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.IndicadoresServicioDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.sp.GetConcurrentFailuresKPI;

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
}
