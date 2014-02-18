package com.blackstar.services.interfaces;

import java.util.List;

import org.json.JSONObject;

public interface DashboardService {
	
	public String getServiceOrders (String type);
	public String getPersonalServiceOrders (String user, String status);
	public String getUnassignedTickets();
	public String getScheduledServices(String user);
	public String getAssignedTickets(String user);
	public List<String> getOfficesList();
	public String getAssignedServiceOrders(String userName);
	public String getTeamServiceOrders(String userName);
	public String getTeamTickets(String userName);
	public String getActiveTickets();
	public String getActiveServiceOrders();
	public List<JSONObject> getActiveTicketsObj();
	public List<JSONObject> getActiveServiceOrdersObj();
}
