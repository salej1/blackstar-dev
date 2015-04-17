package com.bloom.db.dao;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;

public class InternatTicketsKPIDaoImpl extends AbstractDAO 
                                       implements InternatTicketsKPIDao {

	
  public List<JSONObject> getTicketsByUser(Date startDate, Date endDate){
	String sql = "CALL GetBloomTicketByUserKPI(?, ?)";
	return getJdbcTemplate().query(sql, new Object[]{startDate, endDate}, new JSONRowMapper());
  }
  
  public List<JSONObject> getTicketByOfficeKPI(Date startDate, Date endDate){
	String sql = "CALL GetBloomTicketByOfficeKPI(?, ?)";
	return getJdbcTemplate().query(sql, new Object[]{startDate, endDate}, new JSONRowMapper());
  }
  
  public List<JSONObject> getTicketByAreaKPI(Date startDate, Date endDate){
	String sql = "CALL GetBloomTicketByAreaKPI(?, ?)";
	return getJdbcTemplate().query(sql, new Object[]{startDate, endDate}, new JSONRowMapper());
  }
  
  public List<JSONObject> getTicketByDayKPI(Date startDate, Date endDate){
	String sql = "CALL GetBloomTicketByDayKPI(?, ?)";
	return getJdbcTemplate().query(sql, new Object[]{startDate, endDate}, new JSONRowMapper());
  }
  
  public List<JSONObject> getTicketByProjectKPI(Date startDate, Date endDate){
	String sql = "CALL GetBloomTicketByProjectKPI(?, ?)";
	return getJdbcTemplate().query(sql, new Object[]{startDate, endDate}, new JSONRowMapper());
  }
  
  public List<JSONObject> getTicketByServiceAreaKPI(Date startDate, Date endDate){
	String sql = "CALL GetBloomTicketByServiceAreaKPI(?, ?)";
	return getJdbcTemplate().query(sql, new Object[]{startDate, endDate}, new JSONRowMapper());
  }
	
}
