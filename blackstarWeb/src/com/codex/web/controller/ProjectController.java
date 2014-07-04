package com.codex.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.web.AbstractController;
import com.codex.service.ProjectService;
import com.codex.vo.ProjectVO;


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
	model.addAttribute("project", new ProjectVO());
	model.addAttribute("entryTypes", service.getAllEntryTypes());
	model.addAttribute("entryItemTypes", service.getAllEntryItemTypes());
	model.addAttribute("currencyTypes", service.getAllCurrencyTypes());
	model.addAttribute("taxesTypes", service.getAllTaxesTypes());
	return "codex/projectDetail";
  }
	
}
