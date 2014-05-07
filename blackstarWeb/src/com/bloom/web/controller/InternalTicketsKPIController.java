package com.bloom.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.web.AbstractController;
import com.bloom.services.InternatTicketsKPIService;

@Controller
@RequestMapping("/bloom")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class InternalTicketsKPIController extends AbstractController {

  private InternatTicketsKPIService service;

  public void setService(InternatTicketsKPIService service) {
	this.service = service;
  }
  
  @RequestMapping(value = "/indServicios/show.do", method = RequestMethod.GET)
  public String show(ModelMap model) {
	try {
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/indicadores";
  }
  
  @RequestMapping(value = "/indServicios/getTicketByUser.do", method = RequestMethod.GET)
  public String getTicketByUser(ModelMap model) {
	try {
		 model.addAttribute("ticketsByUser", service.getTicketsByUser());

	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_indServTicketsByUser";
  }
  
  @RequestMapping(value = "/indServicios/getTicketByOffice.do", method = RequestMethod.GET)
  public String getTicketByOffice(ModelMap model) {
	try {
		 model.addAttribute("graphics", service.getTicketByOfficeKPI());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_indServTicketsByOffice";
  }
  
  @RequestMapping(value = "/indServicios/getTicketByArea.do", method = RequestMethod.GET)
  public String getTicketByArea(ModelMap model) {
	try {
		 model.addAttribute("graphics", service.getTicketByAreaKPI());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_indServTicketsByArea";
  }
  
  @RequestMapping(value = "/indServicios/getTicketByDay.do", method = RequestMethod.GET)
  public String getTicketByDay(ModelMap model) {
	try {
		 model.addAttribute("graphics", service.getTicketByDayKPI());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_indServTicketsByDay";
  }
  
  @RequestMapping(value = "/indServicios/getTicketByProject.do", method = RequestMethod.GET)
  public String getTicketByProject(ModelMap model) {
	try {
		 model.addAttribute("graphics", service.getTicketByProjectKPI());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_indServTicketsByProject";
  }
  
  @RequestMapping(value = "/indServicios/getTicketByServiceAreaKPI.do", method = RequestMethod.GET)
  public String getTicketByServiceAreaKPI(ModelMap model) {
	try {
		 model.addAttribute("graphics", service.getTicketByServiceAreaKPI());
	} catch (Exception e) {
		System.out.println("Error => " + e);
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_indServTicketsByServiceAreaKPI";
  }
  
  
}