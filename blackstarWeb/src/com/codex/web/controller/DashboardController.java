package com.codex.web.controller;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.codex.service.impl.DashboardServiceImpl;

public class DashboardController {
	
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
