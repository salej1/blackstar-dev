package com.codex.db.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.codex.db.DashboardDAO;

public class DashboardDAOImpl extends AbstractDAO 
                              implements DashboardDAO {
	
  @Override
  public List<JSONObject> getProjectsByStatusJson(Integer statusId) {
	String sqlQuery = "CALL CodexGetProjectsByStatus(?)";
	return getJdbcTemplate().query(sqlQuery , new Object[]{statusId}
		                                     , new JSONRowMapper());
  }
  
  @Override
  public List<JSONObject> getProjectsByStatusAndUserJson(Integer statusId
		                                              , Integer cstId) {
	String sqlQuery = "CALL CodexGetProjectsByStatusAndUser(?, ?)";
	return getJdbcTemplate().query(sqlQuery , new Object[]{statusId, cstId}
		                                             , new JSONRowMapper());
  }

}
