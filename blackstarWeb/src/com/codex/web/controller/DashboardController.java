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
	User user = null;
	try {
		 user = ((UserSession) request.getSession().getAttribute(Globals
                                         .SESSION_KEY_PARAM)).getUser();
		 
		 CstDTO cst = cstService.getCstByEmail(user.getUserEmail());
		 
		 if(cst != null){
			 model.addAttribute("newProjects", service.getProjectsByStatusAndUserJson(1, cst.getCstId()));
	         model.addAttribute("byAuthProjects", service.getProjectsByStatusJson(2));
		     model.addAttribute("authProjects", service.getProjectsByStatusJson(3));
		 }
		 else{
			 model.addAttribute("newProjects", "[]");
	         model.addAttribute("byAuthProjects", "[]");
		     model.addAttribute("authProjects", "[]");
		 }

	} catch (Exception e) {
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getMessage());
		return "error";
	}
	return "codex/dashboard";
  }

}
