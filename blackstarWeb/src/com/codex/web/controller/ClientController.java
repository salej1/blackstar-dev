package com.codex.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.web.AbstractController;
import com.codex.service.ClientService;
import com.codex.vo.ClientVO;


@Controller
@RequestMapping("/codex/client")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class ClientController extends AbstractController {
	
  private ClientService service = null;
  
  public void setService(ClientService service) {
	this.service = service;
  }
  
  @RequestMapping(value = "/showClientList.do")
  public String showClientList(ModelMap model){
	model.addAttribute("prospects", service.getClientList(true));
	model.addAttribute("clients", service.getClientList(false));
	return "codex/clientList";
  }
  
  @RequestMapping(value = "/create.do")
  public String create(ModelMap model){
	ClientVO client = new ClientVO();
	client.setId(Integer.valueOf(service.getNextclientId()));
	client.setProspect(true);
	model.addAttribute("client", client);
	model.addAttribute("sellers", service.getUsersByGroup("sysCST"));
	model.addAttribute("states", service.getAllStates());
	model.addAttribute("originTypes", service.getAllOriginTypes());
	model.addAttribute("clientTypes", service.getAllClientTypes());
	return "codex/clientDetail";
  }
  
  @RequestMapping(value = "/insert.do")
  public String insert(ModelMap model, @ModelAttribute("prospect") ClientVO client){
	 service.insertClient(client);
	 return showClientList(model);  
  }
  
  @RequestMapping(value = "/getLocationsByZipCode.do", produces="application/json")
  public @ResponseBody String getLocationsByZipCode(@RequestParam(required = true) String zipCode
		                                                        , ModelMap model) {
	  return service.getLocationsJSONByZipCode(zipCode);
  }
  
}
