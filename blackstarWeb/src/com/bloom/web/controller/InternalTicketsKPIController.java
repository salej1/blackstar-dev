package com.bloom.web.controller;

import java.util.Date;
import java.util.List;

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
import com.blackstar.web.AbstractController;
import com.bloom.common.bean.ReportTicketBean;
import com.bloom.common.bean.RespuestaJsonBean;
import com.bloom.common.exception.ServiceException;
import com.bloom.services.InternatTicketsKPIService;
import com.bloom.services.ReportsTicketsService;

@Controller
@RequestMapping("/bloom")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class InternalTicketsKPIController extends AbstractController {

  private InternatTicketsKPIService service;
  private ReportsTicketsService reportsTicketsService;

  public void setReportsTicketsService(ReportsTicketsService reportsTicketsService) {
	this.reportsTicketsService = reportsTicketsService;
  }

  public void setService(InternatTicketsKPIService service) {
	this.service = service;
  }
  
  @RequestMapping(value = "/bloomKpi/show.do", method = RequestMethod.GET)
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
  
  @RequestMapping(value = "/bloomKpi/getTicketByUser.do", method = RequestMethod.GET)
  public String getTicketByUser(ModelMap model, @RequestParam(required = true) Date startDate,
			@RequestParam(required = true) Date endDate) {
	try {
		 model.addAttribute("ticketsByUser", service.getTicketsByUser(startDate, endDate));

	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_indServTicketsByUser";
  }
  
  @RequestMapping(value = "/bloomKpi/getTicketByOffice.do", method = RequestMethod.GET)
  public String getTicketByOffice(ModelMap model, @RequestParam(required = true) Date startDate,
			@RequestParam(required = true) Date endDate) {
	try {
		 model.addAttribute("ticketByOffice", service.getTicketByOfficeKPI(startDate, endDate));
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_indServTicketsByOffice";
  }
  
  @RequestMapping(value = "/bloomKpi/getTicketByArea.do", method = RequestMethod.GET)
  public String getTicketByArea(ModelMap model, @RequestParam(required = true) Date startDate,
			@RequestParam(required = true) Date endDate) {
	try {
		 model.addAttribute("ticketByArea", service.getTicketByAreaKPI(startDate, endDate));
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_indServTicketsByArea";
  }
  
  @RequestMapping(value = "/bloomKpi/getTicketByDay.do", method = RequestMethod.GET)
  public String getTicketByDay(ModelMap model, @RequestParam(required = true) Date startDate,
			@RequestParam(required = true) Date endDate) {
	try {
		 model.addAttribute("ticketByDay", service.getTicketByDayKPI(startDate, endDate));
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_indServTicketsByDay";
  }
  
  @RequestMapping(value = "/bloomKpi/getTicketByProject.do", method = RequestMethod.GET)
  public String getTicketByProject(ModelMap model, @RequestParam(required = true) Date startDate,
			@RequestParam(required = true) Date endDate) {
	try {
		 model.addAttribute("ticketByProject", service.getTicketByProjectKPI(startDate, endDate));
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_indServTicketsByProject";
  }
  
  @RequestMapping(value = "/bloomKpi/getTicketByServiceAreaKPI.do", method = RequestMethod.GET)
  public String getTicketByServiceAreaKPI(ModelMap model, @RequestParam(required = true) Date startDate,
			@RequestParam(required = true) Date endDate) {
	try {
		 model.addAttribute("ticketByServiceAreaKPI", service.getTicketByServiceAreaKPI(startDate, endDate));
	} catch (Exception e) {
		System.out.println("Error => " + e);
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_indServTicketsByServiceAreaKPI";
  }
  
  @RequestMapping(value = "/bloomKpi/getTicketStatsByServiceAreaKPI.do", method = RequestMethod.GET)
	public String getTicketStatsByServiceAreaKPI(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		return "bloom/reportStatisticsByAreaSupport";
	}	
  
  @RequestMapping(value = "/bloomKpi/getStatisticsByAreaSupport.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody String getStatisticsByAreaSupport(
			@RequestParam(required = true) Date startDate,
			@RequestParam(required = true) Date endDate) {

		String retVal = "";

		try {

			retVal = reportsTicketsService.getStatisticsByAreaSupport(startDate, endDate);
					
		} catch (Exception e) {

			Logger.Log(LogLevel.ERROR, e.getMessage(), e);
			e.printStackTrace();
		}

		return retVal;
	}
    

	@RequestMapping(value = "/bloomKpi/getNonSatisfactoryTicketsByUsr.do", method = RequestMethod.GET)
	public String reportUnsatisfactoryTicketsByUserEngineeringService(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		return "bloom/reportUnsatisfactoryTicketsByUserEngineeringService";
	}

	@RequestMapping(value = "/bloomKpi/getNonSatisfactoryTicketsByUsr.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody String getUnsatisfactoryTicketsByUserEngineeringService(
			@RequestParam(required = true) Date startDate,
			@RequestParam(required = true) Date endDate) {

		String retVal = "";

		try {

			retVal = reportsTicketsService.getUnsatisfactoryTicketsByUserEngineeringService(startDate, endDate);
					
		} catch (Exception e) {

			Logger.Log(LogLevel.ERROR, e.getMessage(), e);
			e.printStackTrace();
		}

		return retVal;
	}
}