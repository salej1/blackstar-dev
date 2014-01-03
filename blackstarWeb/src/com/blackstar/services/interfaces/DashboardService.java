package com.blackstar.services.interfaces;

public interface DashboardService {
	
	public String getServiceOrders (String type);
	public String getPersonalServiceOrders (String user, String status);
	public String getUnassignedTickets();
	public String getScheduledServices(String user);
	public String getAssignedTickets(String user);
}
