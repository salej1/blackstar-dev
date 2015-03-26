package com.codex.web.controller;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.User;
import com.blackstar.model.UserSession;
import com.blackstar.web.AbstractController;
import com.codex.model.dto.CstDTO;
import com.codex.service.CstService;
import com.codex.service.impl.DashboardServiceImpl;

@Controller
@RequestMapping("/codex/dashboard")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class DashboardController extends AbstractController{
	
  private DashboardServiceImpl service;
  private CstService cstService;
  	
  public void setService(DashboardServiceImpl service) {
	this.service = service;
  }
  
  public void setCstService(CstService cstService) {
	this.cstService = cstService;
}

  @RequestMapping(value = "/show.do")
  public String show(ModelMap model,HttpServletRequest request){

	try {
		model.addAttribute("newProjects", "[]");
        model.addAttribute("byAuthProjects", "[]");
	    model.addAttribute("authProjects", "[]");
	} catch (Exception e) {
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getMessage());
		return "error";
	}
	return "codex/dashboard";
  }

  @RequestMapping(value = "/getNewProjects.do", produces="application/json")
  public @ResponseBody String getNewProjects(ModelMap model,HttpServletRequest request) {
	User user = null;
	try {
		user = ((UserSession) request.getSession().getAttribute(Globals
                .SESSION_KEY_PARAM)).getUser();

		CstDTO cst = cstService.getCstByEmail(user.getUserEmail());
		
		if(cst != null){
			return service.getProjectsByStatusAndUserJson(1, cst.getCstId());
		}
		else{
			return "[]";
		}
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		System.out.println("getLocationsByZipCodeError=>" + e);
	}
	return null;
  }
  
  @RequestMapping(value = "/getByAuthProjects.do", produces="application/json")
  public @ResponseBody String getByAuthProjects(ModelMap model,HttpServletRequest request) {
	User user = null;
	try {
		user = ((UserSession) request.getSession().getAttribute(Globals
                .SESSION_KEY_PARAM)).getUser();

		CstDTO cst = cstService.getCstByEmail(user.getUserEmail());
		
		if(cst != null){
			return service.getProjectsByStatusJson(2);
		}
		else{
			return "[]";
		}
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		System.out.println("getLocationsByZipCodeError=>" + e);
	}
	return null;
  }
  
  @RequestMapping(value = "/getAuthProjects.do", produces="application/json")
  public @ResponseBody String getAuthProjects(ModelMap model,HttpServletRequest request) {
	User user = null;
	try {
		user = ((UserSession) request.getSession().getAttribute(Globals
                .SESSION_KEY_PARAM)).getUser();

		CstDTO cst = cstService.getCstByEmail(user.getUserEmail());
		
		if(cst != null){
			return service.getProjectsByStatusJson(3);
		}
		else{
			return "[]";
		}
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		System.out.println("getLocationsByZipCodeError=>" + e);
	}
	return null;
  }
}
