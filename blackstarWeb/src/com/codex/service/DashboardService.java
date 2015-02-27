package com.codex.service;

public interface DashboardService {
	
  public String getProjectsByStatusJson(Integer statusId);
  public String getProjectsByStatusAndUserJson(Integer statusId, Integer cstId);

}
