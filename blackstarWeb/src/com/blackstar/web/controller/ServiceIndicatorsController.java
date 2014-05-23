package com.blackstar.web.controller;

import java.util.Date;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.UserSession;
import com.blackstar.services.interfaces.ServiceIndicatorsService;
import com.blackstar.web.AbstractController;


@Controller
@RequestMapping("/indServicios")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class ServiceIndicatorsController extends AbstractController {
	
  private ServiceIndicatorsService service;
	
  public void setService(ServiceIndicatorsService service) {
	this.service = service;
  }
  
  @RequestMapping(value= "/show.do", method = RequestMethod.GET)
  public String  show(ModelMap model,  @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	  try{
		  if(userSession.getUser().getBelongsToGroup().get("Cliente") != null && userSession.getUser().getBelongsToGroup().get("Cliente") == true){
			  model.addAttribute("projects", service.getLimitedProjectList(userSession.getUser().getUserEmail()));
		  }
		  else{
			  model.addAttribute("projects", service.getProjectList());
		  }
	  }catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
  
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
  public String  getPolicies( @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  ModelMap model){
	try {
	     model.addAttribute("policies", service.getPolicies(project, startDate, endDate));
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "_indServPolicies";
  }
  
  @RequestMapping(value= "/getConcurrentFailures.do", method = RequestMethod.GET)
  public String  getConcurrenFailures( @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  ModelMap model){
	try {
	     model.addAttribute("concurrenFailures", service.getConcurrentFailures(project, startDate, endDate));
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "_indServConcurrentFailures";
  }
  
  
  @RequestMapping(value= "/getMaxReportsByUser.do", method = RequestMethod.GET)
  public String  getMaxReportsByUser( @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  ModelMap model){
	try {
	     model.addAttribute("maxReportsByUser", service.getMaxPeportsByUser(project, startDate, endDate));
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
  
  @RequestMapping(value= "/getCharts.do", method = RequestMethod.GET)
  public String  getCharts(
		  @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  ModelMap model,  
		  @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	try {
		 if(userSession.getUser().getBelongsToGroup().get("Cliente") != null && userSession.getUser().getBelongsToGroup().get("Cliente") == true){
			 model.addAttribute("charts", service.getCharts(project, startDate, endDate, userSession.getUser().getUserEmail()));
			 model.addAttribute("availabilityKpi", service.getAvailability(project, startDate, endDate, userSession.getUser().getUserEmail()));
		 }
		 else{
			 model.addAttribute("charts", service.getCharts(project, startDate, endDate, ""));
			 model.addAttribute("availabilityKpi", service.getAvailability(project, startDate, endDate, ""));
		 }
	} catch (Exception e) {
		for(StackTraceElement t : e.getStackTrace()){
			System.out.println(t.toString());
		}
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "_indServGraphics";
  }
  
  @RequestMapping(value= "/getAverage.do", method = RequestMethod.GET)
  public String  getAverage(ModelMap model){
	try {
		 model.addAttribute("generalAverage", service.getGeneralAverage());
		 model.addAttribute("userAverage", service.getUserAverage());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "_indServAverage";
  }
  
  @RequestMapping(value= "/getStatics.do", method = RequestMethod.GET)
  public String  getStatics(
		  @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  ModelMap model){
	try {
	     model.addAttribute("statics", service.getStatisticsKPI(project, startDate, endDate));
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		for(StackTraceElement t : e.getStackTrace()){
			System.out.println(t.toString());
		}
		return "error";
	}
	return "_indServStatics";
  }
  

}
