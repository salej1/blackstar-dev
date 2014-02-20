package com.blackstar.web.controller;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
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
	
	private SurveyServiceService surveyServiceService;

	public void setSurveyServiceService(SurveyServiceService surveyServiceService) {
		this.surveyServiceService = surveyServiceService;
	}

	@RequestMapping(value= "/show.do", method = RequestMethod.GET)
	  public String  surveyServiceInitial(ModelMap model)
	  {
		  SurveyService surveyService = new SurveyService();
		  model.addAttribute("surveyService", surveyService);
		  model.addAttribute("readOnlyOrInsert","false");
	  
		  return "surveyService";
	  }
	
	@RequestMapping(value= "/readOnly.do", method = RequestMethod.GET)
	  public String  surveyReadOnly(@RequestParam(required = true) Integer surveyServiceId,ModelMap model)
	  {
		  SurveyService surveyService = new SurveyService();
		  model.addAttribute("surveyService", surveyService);
		  
		  model.addAttribute("readOnlyOrInsert","true");
		  model.addAttribute("surveyServiceData",surveyServiceService.getSurveyServiceById(surveyServiceId));
	  
		  return "surveyService";
	  }
	
	@ModelAttribute("surveyServiceList")
	public String populateServiceOrderList(ModelMap modelLoad) {
		try{
			modelLoad.addAttribute("surveyServiceList",surveyServiceService.getServiceOrder());
		}catch(NullPointerException e){
			e.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
		}
			return "surveyService";
	}
	
	@RequestMapping(value = "/save.do", method = RequestMethod.POST)
	   public String save(
	   		@ModelAttribute("surveyService") SurveyService surveyService,
	   		@ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession,
	             ModelMap model, HttpServletRequest req, HttpServletResponse resp){
		 
		try{
			surveyServiceService.saveSurvey(surveyService);
		}catch(DataAccessException e){
			e.printStackTrace();
		}catch(IllegalArgumentException e){
			e.printStackTrace();
		}
		return "dashboard";
		 
	 }

}
