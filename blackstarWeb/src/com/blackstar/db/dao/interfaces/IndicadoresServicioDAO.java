package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.sp.GetConcurrentFailuresKPI;

public interface IndicadoresServicioDAO {
	
  public List<JSONObject> getTickets();
  public List<JSONObject> getPolicies();
  public List<GetConcurrentFailuresKPI> getConcurrentFailures();
	
}
