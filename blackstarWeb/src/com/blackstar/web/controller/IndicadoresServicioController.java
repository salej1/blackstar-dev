package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.services.interfaces.IndicadoresServicioService;
import com.blackstar.web.AbstractController;


@Controller
@RequestMapping("/indServicios")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class IndicadoresServicioController extends AbstractController {
	
  private IndicadoresServicioService service;
	
  public void setService(IndicadoresServicioService service) {
	this.service = service;
  }
  
  @RequestMapping(value= "/show.do", method = RequestMethod.GET)
  public String  show(ModelMap model){
	return "indicadoresServicios";
  }
	
  @RequestMapping(value= "/getTickets.do", method = RequestMethod.GET)
  public String  getTickets(ModelMap model){
	try {
	     model.addAttribute("tickets", service.getAllTickets());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "_indServTickets";
  }

}
