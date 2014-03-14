package com.blackstar.db.dao.impl;

import java.util.ArrayList;
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
	public List<JSONObject> getPersonalServiceOrders(String user) {
		String sqlQuery = "CALL GetPersonalServiceOrders(?);";
		return getJdbcTemplate().query(sqlQuery, new Object[]{user}, new JSONRowMapper()); 
	}

	@Override
	public List<String> getOfficesList() {
		String sqlQuery = "CALL GetOfficesList();";
		return getJdbcTemplate().queryForList(sqlQuery, String.class);
	}

	@Override
	public List<JSONObject> getOpenLimitedTickets(String user){
		String sqlQuery = "CALL GetOpenLimitedTickets(?);";
		return getJdbcTemplate().query(sqlQuery, new Object[]{user}, new JSONRowMapper()); 
	}

	@Override
	public List<JSONObject> getLimitedServiceOrders(String user, String status){
		String sqlQuery = "CALL GetLimitedServiceOrders(?);";
		return getJdbcTemplate().query(sqlQuery, new Object[]{user, status}, new JSONRowMapper()); 
	}
}
