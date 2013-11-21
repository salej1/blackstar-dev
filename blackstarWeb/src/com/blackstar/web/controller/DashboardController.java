package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.TicketController;
import com.blackstar.model.User;
import com.blackstar.services.interfaces.DashboardService;
import com.blackstar.web.AbstractController;

import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/dashboard")
@SessionAttributes({"user"})
public class DashboardController extends AbstractController {

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
		 model.addAttribute("employees", udService.getStaff());
	} catch (Exception ex) {	
		Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		ex.printStackTrace();
		return "error";
	}	 
	return "dashboard";
  }
  
  @RequestMapping(value= "/asignTicket.do", method = RequestMethod.POST)
  public String asignTicket(@RequestParam(required = true) Integer ticketId
		                  , @RequestParam(required = true) String employee 
		                  , @ModelAttribute("user")  User user
		                  , ModelMap model) {
    String who = user == null ? "portal-servicios@gposac.com.mx" 
    		                  : user.getUserEmail();
	try {
		 TicketController.AssignTicket(ticketId, employee, who, null);
	} catch (Exception ex) {	
		Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		ex.printStackTrace();
		return "error";
	}	 
	return show(model);
  }
  
}
