package com.codex.service.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.services.AbstractService;
import com.codex.db.impl.DashboardDAOImpl;
import com.codex.service.DashboardService;

public class DashboardServiceImpl extends AbstractService 
                                  implements DashboardService {
	
  private DashboardDAOImpl dao;
  
  public void setDao(DashboardDAOImpl dao) {
	this.dao = dao;
  }
  
  @Override
  public String getProjectsByStatusJson(Integer statusId){
	List<JSONObject> projects = dao.getProjectsByStatusJson(statusId);
	return projects != null ? encode(projects.toString()): "";
  }
  
  @Override
  public String getProjectsByStatusAndUserJson(Integer statusId, Integer cstId){
	List<JSONObject> projects = dao.getProjectsByStatusAndUserJson(statusId
			                                                     , cstId);
	return projects != null ? encode(projects.toString()): "";
  }



}
