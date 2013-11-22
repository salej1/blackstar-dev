package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.blackstar.interfaces.IUserService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.services.interfaces.DashboardService;

import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {

  private DashboardService service;
  private IUserService userService;
	
  public void setService(DashboardService service) {
	this.service = service;
  }
  
  public void setUserService(IUserService userService) {
		this.userService = userService;
  }
  
  @RequestMapping(value= "/show.do", method = RequestMethod.GET)
  public String show(ModelMap model) {
	try {
		 model.addAttribute("serviceOrdersToReviewDashboard", service.getServiceOrders("NUEVO"));
		 model.addAttribute("serviceOrdersPendingDashboard", service.getServiceOrders("PENDIENTE"));
	} catch (Exception ex) {	
		Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		ex.printStackTrace();
		return "error";
	}	 
	return "dashboard";
  }
  
  @RequestMapping(value="/unassignedTicketsJson", method=RequestMethod.GET)
  public String unnasignedTicketsJson(ModelMap model){
	  try {
			 model.addAttribute("ticketsToAssignDashboard", service.getUnassignedTickets());
			 model.addAttribute("employees", userService.getEmployeeList());
		} catch (Exception ex) {	
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
			ex.printStackTrace();
			return "error";
		}	 
		return "unassignedTicketsJson";
  }
}
