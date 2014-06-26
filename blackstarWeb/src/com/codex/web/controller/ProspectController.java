package com.codex.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.web.AbstractController;
import com.codex.service.ProspectService;
import com.codex.vo.ProspectVO;


@Controller
@RequestMapping("/codex/prospect")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class ProspectController extends AbstractController {
	
  private ProspectService service = null;
  
  public void setService(ProspectService service) {
	this.service = service;
  }
  
  @RequestMapping(value = "/create.do")
  public String create(ModelMap model){
	model.addAttribute("prospect", new ProspectVO());
	model.addAttribute("sellers", service.getUsersByGroup("sysCST"));
	model.addAttribute("states", service.getAllStates());
	model.addAttribute("originTypes", service.getAllOriginTypes());
	model.addAttribute("clientTypes", service.getAllClientTypes());
	return "codex/prospectDetail";
  }
  
  @RequestMapping(value = "/getLocationsByZipCode.do", produces="application/json")
  public @ResponseBody String getLocationsByZipCode(@RequestParam(required = true) String zipCode
		                                                        , ModelMap model) {
	  return service.getLocationsJSONByZipCode(zipCode);
  }
  
}
