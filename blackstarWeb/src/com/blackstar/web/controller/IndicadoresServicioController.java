package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
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
	model.addAttribute("tickets", service.getAllTickets());
	return "_indServTickets";
  }

}
