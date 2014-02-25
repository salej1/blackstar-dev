package com.blackstar.web.controller;

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
import com.blackstar.services.interfaces.SurveyServiceService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/surveyServices")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class SurveyServiceController extends AbstractController {
	
	private SurveyServiceService service;

	public void setService(SurveyServiceService surveyServiceService) {
		this.service = surveyServiceService;
	}


	// Pagina de encuestas de servicio
	@RequestMapping(value = "/show.do", method = RequestMethod.GET)
	public String show(ModelMap model) {

			// init
			try {
				// nada, los datos se recuperan via ajax desde el jsp
			} catch (Exception ex) {
				Logger.Log(LogLevel.ERROR,
						Thread.currentThread().getStackTrace()[1].toString(), ex);
				ex.printStackTrace();
				return "error";
			}
			return "surveyServices";
	}
	
	// Historico de encuestas de servicio
	@RequestMapping(value = "/surveyServiceHistory.do", method = RequestMethod.GET)
	public @ResponseBody String surveyServiceHistory(ModelMap model) {
		String retVal;
		try {
			retVal = service.getAllSurveyServiceList().toString();
		} catch (Exception ex) {
			Logger.Log(LogLevel.ERROR,
					Thread.currentThread().getStackTrace()[1].toString(), ex);
			ex.printStackTrace();
			return "error";
		}
		return retVal;
	}
		
	// Encuestas de servicio Personales
	@RequestMapping(value = "/personalSurveyServices.do", method = RequestMethod.GET)
	public @ResponseBody String personalSurveyServices(ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
		String retVal;
		try {
			retVal = service.getPersonalSurveyServiceList(userSession.getUser().getUserEmail()).toString();
		} catch (Exception ex) {
			Logger.Log(LogLevel.ERROR,
					Thread.currentThread().getStackTrace()[1].toString(), ex);
			ex.printStackTrace();
			return "error";
		}
		return retVal;
	}
}
