package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

public interface DashboardDAO {
	
	public List<JSONObject> getServiceOrders (String type);
	public List<JSONObject> getUnassignedTickets();

}
