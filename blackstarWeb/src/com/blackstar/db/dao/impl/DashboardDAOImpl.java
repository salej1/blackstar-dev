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
	public List<JSONObject> getScheuldedServices() {
		// TODO Auto-generated method stub
		return null;
	}

}
