package com.blackstar.services.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.DashboardDAO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.DashboardService;

public class DashboardServiceImpl extends AbstractService implements
		DashboardService {

	private DashboardDAO dao;

	public void setDao(DashboardDAO dao) {
		this.dao = dao;
	}

	@Override
	public String getServiceOrders(String type) {
		List<JSONObject> serviceOrders = dao.getServiceOrders(type);
		return serviceOrders != null ? serviceOrders.toString() : "";
	}

	@Override
	public String getUnassignedTickets() {
		List<JSONObject> unassignedTickets = dao.getUnassignedTickets();
		return unassignedTickets != null ? unassignedTickets.toString() : "";
	}

	@Override
	public String getScheduledServices(String user) {
		List<JSONObject> scheduledServices = dao.getScheuldedServices(user);
		return scheduledServices != null? scheduledServices.toString() : "";
	}
	
	@Override
	public String getAssignedTickets(String user){
		List<JSONObject> assignedTickets = dao.getAssignedTickets(user);
		return assignedTickets != null? assignedTickets.toString() : "";
	}
}
