package com.codex.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
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
  public String show(ModelMap model){
    model.addAttribute("newProjects", service.getProjectsByStatusJson(1));
	model.addAttribute("authProjects", service.getProjectsByStatusJson(2));
	model.addAttribute("cotProjects", service.getProjectsByStatusJson(3));
	return "codex/dashboard";
  }

}
