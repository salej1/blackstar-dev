package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.IndServConcurrentFailures;

public interface IndicadoresServicioDAO {
	
  public List<JSONObject> getTickets();
  public List<JSONObject> getPolicies();
  public List<IndServConcurrentFailures> getConcurrentFailures();
	
}
