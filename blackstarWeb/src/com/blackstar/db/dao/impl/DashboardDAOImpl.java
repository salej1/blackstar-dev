package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.DashboardDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;

public class DashboardDAOImpl extends AbstractDAO implements DashboardDAO {

	public List<JSONObject> getServiceOrders (String type){
		String sqlQuery = "CALL GetServiceOrders(?)";
		return getJdbcTemplate().query(sqlQuery, new Object[]{type}
		, new JSONRowMapper());
	}

	public List<JSONObject> getUnassignedTickets(){
		String sqlQuery = "CALL GetUnassignedTickets();";
		return getJdbcTemplate().query(sqlQuery, new JSONRowMapper());  
	}

	@Override
	public List<JSONObject> getScheuldedServices(String user) {
		String sqlQuery = "CALL GetScheduledServices(?);";
		return getJdbcTemplate().query(sqlQuery, new Object[]{user}, new JSONRowMapper()); 
	}

	@Override
	public List<JSONObject> getAssignedTickets(String user){
		String sqlQuery = "CALL GetAssignedTickets(?);";
		return getJdbcTemplate().query(sqlQuery, new Object[]{user}, new JSONRowMapper()); 
	}

	@Override
	public List<JSONObject> getPersonalServiceOrders(String user, String status) {
		String sqlQuery = "CALL GetPersonalServiceOrders(?, ?);";
		return getJdbcTemplate().query(sqlQuery, new Object[]{user, status}, new JSONRowMapper()); 
	}

	@Override
	public List<String> getOfficesList() {
		String sqlQuery = "CALL GetOfficesList();";
		return getJdbcTemplate().queryForList(sqlQuery, String.class);
	}
	
	@Override
	public List<JSONObject> getAssignedServiceOrders(String userName){
		String sqlQuery = "CALL GetAssignedServiceOrders(?);";
		return getJdbcTemplate().query(sqlQuery, new Object[]{userName}
		                                        , new JSONRowMapper()); 
	}
	
	@Override
	public List<JSONObject> getTeamServiceOrders(String userName){
	  String sqlQuery = "CALL GetTeamServiceOrders(?);";
	  return getJdbcTemplate().query(sqlQuery, new Object[]{userName}
		                                      , new JSONRowMapper()); 
	}
	
	@Override
	public List<JSONObject> getTeamTickets(String userName){
	  String sqlQuery = "CALL GetTeamTickets(?);";
	  return getJdbcTemplate().query(sqlQuery, new Object[]{userName}
		                                      , new JSONRowMapper()); 
	}
	
	@Override
	public List<JSONObject> getActiveTickets(){
	  String sqlQuery = "CALL GetActiveTickets();";
	  return getJdbcTemplate().query(sqlQuery, new JSONRowMapper()); 
	}
	
	@Override
	public List<JSONObject> getActiveServiceOrders(){
	  String sqlQuery = "CALL GetActiveServiceOrder();";
	  return getJdbcTemplate().query(sqlQuery, new JSONRowMapper()); 
	}
}
