package com.blackstar.web.controller;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.model.SurveyService;
import com.blackstar.model.UserSession;
import com.blackstar.services.interfaces.SurveyServiceService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/surveyService")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class SurveyServiceController extends AbstractController {
	
	private SurveyServiceService SurveyServiceService;

	public void setSurveyServiceService(SurveyServiceService surveyServiceService) {
		SurveyServiceService = surveyServiceService;
	}

	@RequestMapping(value= "/show.do", method = RequestMethod.GET)
	  public String  surveyServiceInitial(ModelMap model)
	  {
		  SurveyService surveyService = new SurveyService();
		  model.addAttribute("surveyService", surveyService);
	  
		  return "surveyService";
	  }
	
	@ModelAttribute("surveyServiceList")
	public String populateServiceOrderList(ModelMap modelLoad) {
		modelLoad.addAttribute("surveyServiceList",SurveyServiceService.getServiceOrder());
		return "surveyService";
	}
	
	@RequestMapping(value = "/save.do", method = RequestMethod.POST)
	   public String save(
	   		@ModelAttribute("surveyService") SurveyService surveyService,
	   		@ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession,
	             ModelMap model, HttpServletRequest req, HttpServletResponse resp){
		 
		// model.addAttribute("surveyService", surveyService);
		SurveyServiceService.saveSurvey(surveyService);
		return "dashboard";
		 
	 }

}
