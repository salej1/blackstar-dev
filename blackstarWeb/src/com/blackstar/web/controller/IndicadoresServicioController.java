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
	     model.addAttribute("tickets", service.getTickets());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "_indServTickets";
  }
  
  @RequestMapping(value= "/getPolicies.do", method = RequestMethod.GET)
  public String  getPolicies(ModelMap model){
	try {
	     model.addAttribute("policies", service.getPolicies());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "_indServPolicies";
  }
  
  @RequestMapping(value= "/getConcurrentFailures.do", method = RequestMethod.GET)
  public String  getConcurrenFailures(ModelMap model){
	try {
	     model.addAttribute("concurrenFailures", service.getConcurrentFailures());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "_indServConcurrentFailures";
  }
  
  
  @RequestMapping(value= "/getMaxReportsByUser.do", method = RequestMethod.GET)
  public String  getMaxReportsByUser(ModelMap model){
	try {
	     model.addAttribute("maxReportsByUser", service.getMaxPeportsByUser());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "_indServMaxReportsByUser";
  }
 
  @RequestMapping(value= "/getReportOS.do", method = RequestMethod.GET)
  public String  getReportOS(ModelMap model){
	try {
		 model.addAttribute("reportOSResume", service.getReportOSResumeKPI());
		 model.addAttribute("reportOSTable", service.getReportOSTable());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "_indServReportOS";
  }
  
  @RequestMapping(value= "/getOSResume.do", method = RequestMethod.GET)
  public String  getOSResume(ModelMap model){
	try {
		 model.addAttribute("OSResume", service.getOSResume());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "_indServOSResume";
  }
  

}
