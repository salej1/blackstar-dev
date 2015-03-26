package com.codex.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.UserSession;
import com.blackstar.web.AbstractController;
import com.codex.service.SalesCallService;

@Controller
@RequestMapping("/codex/salesCall")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class SalesCallController extends AbstractController{
	private SalesCallService service;
	
	public void setService(SalesCallService service) {
		this.service = service;
	}

	@RequestMapping(value = "/record.do", method=RequestMethod.POST, produces="application/json") 
	public  @ResponseBody String insert(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession,
			@ModelAttribute("cstEmail") String cstEmail){
		try{
			service.recordSalesCall(cstEmail);
		}
		catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			System.out.println("Error =>" + e);
			return "{ \"result\" : \"Error\" }";
		}
		
		return "{ \"result\" : \"OK\" }";
	}
}
