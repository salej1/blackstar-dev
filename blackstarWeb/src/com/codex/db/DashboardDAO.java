package com.codex.db;

import java.util.List;

import org.json.JSONObject;

public interface DashboardDAO {
	
  public List<JSONObject> getProjectsByStatusJson(Integer statusId);
  public List<JSONObject> getProjectsByStatusAndUserJson(Integer statusId
		                                               , Integer cstId);

}
