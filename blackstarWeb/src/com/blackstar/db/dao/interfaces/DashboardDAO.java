package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

public interface DashboardDAO {
	
	public List<JSONObject> getServiceOrders (String type);
	public List<JSONObject> getPersonalServiceOrders (String user, String status);
	public List<JSONObject> getUnassignedTickets();
	public List<JSONObject> getScheuldedServices(String user);
	public List<JSONObject> getAssignedTickets(String user);
	public List<String> getOfficesList();
}
