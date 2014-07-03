package com.codex.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.web.AbstractController;
import com.codex.service.ProjectService;


@Controller
@RequestMapping("/codex/project")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class ProjectController extends AbstractController {

  private ProjectService service;

  public void setService(ProjectService service) {
	this.service = service;
  }
	
  @RequestMapping(value = "/create.do")
  public String create(ModelMap model){
	return "codex/projectDetail";
  }
	
}
