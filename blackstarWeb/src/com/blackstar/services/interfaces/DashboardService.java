package com.blackstar.services.interfaces;

public interface DashboardService {
	
	public String getServiceOrders (String type);
	public String getUnassignedTickets();
	public String getScheduledServices(String user);
}
