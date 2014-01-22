package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Ticket;

public interface IndicadoresServicioDAO {
	
	public List<JSONObject> getAllTickets();
	
}
