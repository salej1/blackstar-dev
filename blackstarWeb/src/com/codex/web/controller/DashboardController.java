package com.codex.web.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.model.User;
import com.blackstar.model.UserSession;
import com.blackstar.web.AbstractController;
import com.codex.service.impl.DashboardServiceImpl;

@Controller
@RequestMapping("/codex/dashboard")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class DashboardController extends AbstractController{
	
  private DashboardServiceImpl service;
	
  public void setService(DashboardServiceImpl service) {
	this.service = service;
  }
  
  @RequestMapping(value = "/show.do")
  public String show(ModelMap model,HttpServletRequest request){
	User user = null;
	try {
		 user = ((UserSession) request.getSession().getAttribute(Globals
                                         .SESSION_KEY_PARAM)).getUser();
         model.addAttribute("newProjects", service
        		 .getProjectsByStatusAndUserJson(1, user.getBlackstarUserId()));
         model.addAttribute("byAuthProjects", service.getProjectsByStatusJson(2));
	     model.addAttribute("authProjects", service.getProjectsByStatusJson(3));

	} catch (Exception e) {
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		System.out.println("Error =>" + e);
		return "error";
	}
	return "codex/dashboard";
  }

}
