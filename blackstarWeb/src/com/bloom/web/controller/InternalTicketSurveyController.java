package com.bloom.web.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.TimeZone;

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
import com.blackstar.web.AbstractController;
import com.bloom.services.InternalTicketsService;
import com.bloom.services.InternalTicketsSurveyService;


@Controller
@RequestMapping("/bloom/survey")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class InternalTicketSurveyController extends AbstractController {
	
	
  private InternalTicketsSurveyService service;
  private InternalTicketsService internalTicketsService;
	
  public void setInternalTicketsService(
	InternalTicketsService internalTicketsService) {
	this.internalTicketsService = internalTicketsService;
  }

  public void setService(InternalTicketsSurveyService service) {
	this.service = service;
  }
	
  @RequestMapping(value = "/show.do", method = RequestMethod.GET)
  public String show(@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession
		                                                            , ModelMap model) {
	Integer userId = userSession.getUser().getBlackstarUserId();
	try {
		 model.addAttribute("surveyTable", service.getSurveyTable(userId));
		 model.addAttribute("pendingSurveyTable", service.getPendingSurveyTable(userId));
	} catch (Exception e) {
		 Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		 e.printStackTrace();
		 model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		 return "error";
	}
	return "bloom/bloomSurvey";
  }
  
  @RequestMapping(value = "/create.do", method = RequestMethod.GET)
  public String create(@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession
		  ,@RequestParam(required = true) String ticketNumber, ModelMap model) {
	TimeZone tz =TimeZone.getTimeZone("America/Mexico_City");
	Calendar calendar = Calendar.getInstance(tz);
	SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");	  
	try {
		 df.setTimeZone(tz);
		 model.addAttribute("ticketNumber", ticketNumber);
		 model.addAttribute("marcaTemporal", df.format(calendar.getTime()));
	} catch (Exception e) {
		 Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		 e.printStackTrace();
		 model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		 return "error";
	}
	return "bloom/bloomNewSurvey";
  }
  
  @RequestMapping(value = "/save.do", method = RequestMethod.GET)
  public String save( @RequestParam(required = true) String ticketNumber
		              , @RequestParam(required = true) String marcaTemporal
		              , @RequestParam(required = true) Integer evaluation
		              , @RequestParam(required = true) String observations
		              , @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession
		              , ModelMap model) {
	 Integer ticketId = null;
	try {
		 ticketId = internalTicketsService.getTicketId(ticketNumber);
		 if(ticketId != null && ticketId > 0){
			 service.insertSurvey(ticketId, evaluation, observations
					                               , marcaTemporal);
		 }
	} catch (Exception e) {
		 Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		 e.printStackTrace();
		 model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		 return "error";
	}
	return show(userSession, model);
  }





}
