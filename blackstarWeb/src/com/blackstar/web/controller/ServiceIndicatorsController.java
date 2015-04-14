package com.blackstar.web.controller;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.UserSession;
import com.blackstar.services.interfaces.ServiceIndicatorsService;
import com.blackstar.web.AbstractController;
import com.codex.service.ClientService;
import com.codex.service.CstService;


@Controller
@RequestMapping("/indServicios")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class ServiceIndicatorsController extends AbstractController {
	
  private ServiceIndicatorsService service;
  private CstService cstService;
  private ClientService clService;
  
  public void setService(ServiceIndicatorsService service) {
	this.service = service;
  }
  
  public void setCstService(CstService cstService) {
		this.cstService = cstService;
  }
  
  public void setClService(ClientService clService) {
		this.clService = clService;
  }
  
  @RequestMapping(value= "/show.do", method = RequestMethod.GET)
  public String  show(ModelMap model,  @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	  try{
		  if(userSession.getUser().getBelongsToGroup().get("Cliente") != null && userSession.getUser().getBelongsToGroup().get("Cliente") == true){
			  model.addAttribute("projects", service.getLimitedProjectList(userSession.getUser().getUserEmail()));
		  }
		  else{
			  model.addAttribute("projects", service.getProjectList());
			  model.addAttribute("cstList", cstService.getAllCst());
			  model.addAttribute("originList", clService.getAllOriginTypes());
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
  public String  getTickets( @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	try {
		if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CUSTOMER) != null && userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CUSTOMER) == true){
			 model.addAttribute("tickets", service.getTickets(project, startDate, endDate, userSession.getUser().getUserEmail()));
		}
		else{
			model.addAttribute("tickets", service.getTickets(project, startDate, endDate, ""));
		}	    
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
		  @RequestParam(required = true) String param,
		  ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	  Integer includeRenewed = (param != null && param.equals("1")?1:0);
	  
	try {
		if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CUSTOMER) != null && userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CUSTOMER) == true){
	    	model.addAttribute("policies", service.getPolicies("", project, startDate, endDate, userSession.getUser().getUserEmail(), includeRenewed));
		}
	     else{
	    	model.addAttribute("policies", service.getPolicies("", project, startDate, endDate, "", includeRenewed));
	    }
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
		  ModelMap model,  @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	try {
		if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CUSTOMER) != null && userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CUSTOMER) == true){
			model.addAttribute("concurrenFailures", service.getConcurrentFailures(project, startDate, endDate, userSession.getUser().getUserEmail()));
		}
		else{
			model.addAttribute("concurrenFailures", service.getConcurrentFailures(project, startDate, endDate, ""));
		}
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
  
  @RequestMapping(value= "/getDisplayCharts.do", method = RequestMethod.GET)
  public String  getDisplayCharts(
		  @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  ModelMap model,  
		  @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	try {
		 if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CALL_CENTER) != null && userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CALL_CENTER) == true){
			 model.addAttribute("charts", service.getDisplayCharts(project, startDate, endDate, ""));
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
	return "_indServGraphicsDisplay";
  }
  
  @RequestMapping(value= "/getAverage.do", method = RequestMethod.GET)
  public String  getAverage(
		  @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  ModelMap model){
	try {
		 model.addAttribute("generalAverage", service.getGeneralAverage(project, startDate, endDate));
		 model.addAttribute("userAverage", service.getUserAverage(project, startDate, endDate));
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
  

  @RequestMapping(value= "/getProjects.do", method = RequestMethod.GET)
  public String  getProjects(
		  @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  ModelMap model){
	try {
	     model.addAttribute("projectsKpi", service.getProjects(project, startDate, endDate));
	     SimpleDateFormat sdf = new SimpleDateFormat(Globals.DATE_FORMAT_PATTERN);
	     model.addAttribute("startDate", sdf.format(startDate));
	     model.addAttribute("endDate", sdf.format(endDate));
	     model.addAttribute("engHourCost", service.getEngHourCost());
	     model.addAttribute("project", project);
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		for(StackTraceElement t : e.getStackTrace()){
			System.out.println(t.toString());
		}
		return "error";
	}
	return "_indProjects";
  }
  
  @RequestMapping(value= "/getPolicyExport.do", method = RequestMethod.GET)
   public String  getPolicyExport(
		  @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  ModelMap model, HttpServletResponse resp){
	try {
		String body = service.getPoliciesExport("", project, startDate, endDate);
		resp.setContentType("text/html; charset=UTF-8");
		 resp.setHeader("Content-Disposition","attachment;filename=polizas.txt");
		 resp.getWriter().print(body);
		 resp.flushBuffer();
	    
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		for(StackTraceElement t : e.getStackTrace()){
			System.out.println(t.toString());
		}
		return "error";
	}
	return "exportEnd";
  }
  

  @RequestMapping(value= "/getTicketsExport.do", method = RequestMethod.GET)
   public String  getTicketsExport(
		  @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  ModelMap model, HttpServletResponse resp){
	try {
		String body = service.getTicketsExport("", project, startDate, endDate);
		resp.setContentType("text/html; charset=UTF-8");
		 resp.setHeader("Content-Disposition","attachment;filename=tickets.txt");
		 resp.getWriter().print(body);
		 resp.flushBuffer();
	    
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		for(StackTraceElement t : e.getStackTrace()){
			System.out.println(t.toString());
		}
		return "error";
	}
	return "exportEnd";
  }
  
  @RequestMapping(value= "/getSOExport.do", method = RequestMethod.GET)
   public String  getSOExport(
		  @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  ModelMap model, HttpServletResponse resp){
	try {
		String body = service.getSOExport("", project, startDate, endDate);
		resp.setContentType("text/html; charset=UTF-8");
		 resp.setHeader("Content-Disposition","attachment;filename=ordenesServicio.txt");
		 resp.getWriter().print(body);
		 resp.flushBuffer();
	    
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		for(StackTraceElement t : e.getStackTrace()){
			System.out.println(t.toString());
		}
		return "error";
	}
	return "exportEnd";
  }
  
  @RequestMapping(value="/setEhCost.do", method = RequestMethod.POST)
  public String setEhCost(
		  @RequestParam(required = true) Date startDate,
		  @RequestParam(required = true) Date endDate,
		  @RequestParam(required = true) String project,
		  @RequestParam(required = true) Double ehCost,
		  ModelMap model){
	try {
		service.setEngHourCost(ehCost);
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		for(StackTraceElement t : e.getStackTrace()){
			System.out.println(t.toString());
		}
		return "error";
	}
	return "_indProjects";
  }
}
