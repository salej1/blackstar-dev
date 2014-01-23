package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

public interface IndicadoresServicioDAO {
	
	public List<JSONObject> getTickets();
	public List<JSONObject> getPolicies();
	
}
