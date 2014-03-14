package com.blackstar.services.interfaces;

import java.util.List;

public interface DashboardService {
	
	public String getServiceOrders (String type);
	public String getPersonalServiceOrders (String user);
	public String getUnassignedTickets();
	public String getScheduledServices(String user);
	public String getAssignedTickets(String user);
	public List<String> getOfficesList();
	public String getOpenLimitedTicketsJson(String user);
	public String getLimitedServiceOrdersJson(String user, String status);
}
