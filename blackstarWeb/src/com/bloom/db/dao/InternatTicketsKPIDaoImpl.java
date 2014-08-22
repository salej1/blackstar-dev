package com.bloom.db.dao;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;

public class InternatTicketsKPIDaoImpl extends AbstractDAO 
                                       implements InternatTicketsKPIDao {

	
  public List<JSONObject> getTicketsByUser(){
	String sql = "CALL GetBloomTicketByUserKPI()";
	return getJdbcTemplate().query(sql, new JSONRowMapper());
  }
  
  public List<JSONObject> getTicketByOfficeKPI(){
	String sql = "CALL GetBloomTicketByOfficeKPI()";
	return getJdbcTemplate().query(sql, new JSONRowMapper());
  }
  
  public List<JSONObject> getTicketByAreaKPI(){
	String sql = "CALL GetBloomTicketByAreaKPI()";
	return getJdbcTemplate().query(sql, new JSONRowMapper());
  }
  
  public List<JSONObject> getTicketByDayKPI(){
	String sql = "CALL GetBloomTicketByDayKPI()";
	return getJdbcTemplate().query(sql, new JSONRowMapper());
  }
  
  public List<JSONObject> getTicketByProjectKPI(){
	String sql = "CALL GetBloomTicketByProjectKPI()";
	return getJdbcTemplate().query(sql, new JSONRowMapper());
  }
  
  public List<JSONObject> getTicketByServiceAreaKPI(){
	String sql = "CALL GetBloomTicketByServiceAreaKPI()";
	return getJdbcTemplate().query(sql, new JSONRowMapper());
  }
	
}
