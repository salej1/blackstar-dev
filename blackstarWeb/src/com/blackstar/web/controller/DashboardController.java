package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.services.interfaces.DashboardService;

@Controller
public class DashboardController {

  private DashboardService service;
	
  public void setService(DashboardService service) {
	this.service = service;
  }

  @RequestMapping("/dashboard/callCenter.do")
  public String  setupCallCenter(ModelMap model) {
	try {
		 model.addAttribute("ticketsToAssignDashboard", service.getUnassignedTickets());
		 model.addAttribute("serviceOrdersToReviewDashboard", service.getServiceOrders("NUEVO"));
		 model.addAttribute("serviceOrdersPendingDashboard", service.getServiceOrders("PENDIENTE"));
	} catch (Exception ex) {	
		Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		ex.printStackTrace();
		return "error";
	}	  
	return "/dashboard";
  }
  
  @RequestMapping("/dashboard/service.do")
  public String  setupService(ModelMap model) {
	try {
		model.addAttribute("ticketsToAssignDashboard", service.getUnassignedTickets());
		 model.addAttribute("serviceOrdersToReviewDashboard", service.getServiceOrders("NUEVO"));
		 model.addAttribute("serviceOrdersPendingDashboard", service.getServiceOrders("PENDIENTE"));
	} catch (Exception ex) {	
		Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		ex.printStackTrace();
		return "error";
	}	  
	return "jsp/dashboard/service";
  }
  
}
