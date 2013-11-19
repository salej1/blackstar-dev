package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.services.interfaces.DashboardService;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {

  private DashboardService service;
	
  public void setService(DashboardService service) {
	this.service = service;
  }

  @RequestMapping(value= "/show.do", method = RequestMethod.GET)
  public String show(ModelMap model) {
	try {
		 model.addAttribute("ticketsToAssignDashboard", service.getUnassignedTickets());
		 model.addAttribute("serviceOrdersToReviewDashboard", service.getServiceOrders("NUEVO"));
		 model.addAttribute("serviceOrdersPendingDashboard", service.getServiceOrders("PENDIENTE"));
	} catch (Exception ex) {	
		Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		ex.printStackTrace();
		return "error";
	}	 
	return "dashboard";
  }
  
}
