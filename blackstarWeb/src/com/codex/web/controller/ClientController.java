package com.codex.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
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
import com.codex.service.ClientService;
import com.codex.service.CstService;
import com.codex.vo.ClientVO;


@Controller
@RequestMapping("/codex/client")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class ClientController extends AbstractController {
	
  private ClientService service = null;
  private CstService cService = null;
  
  public void setService(ClientService service) {
	this.service = service;
  }
  
  public void setcService(CstService cService) {
	this.cService = cService;
}

@RequestMapping(value = "/showClientList.do")
  public String showClientList(ModelMap model){
	  try{
		  model.addAttribute("prospects", service.getClientList(true));
		  model.addAttribute("clients", service.getClientList(false));
		  return "codex/clientList";
	  }
	  catch(Exception e){
		  Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		  model.addAttribute("errorDetails", e.getMessage());
		  e.printStackTrace();
		  return "error";
	  }
  }
  
  @RequestMapping(value = "/create.do")
  public String create(ModelMap model){
	  try{
		  ClientVO client = new ClientVO();
		  client.setId(Integer.valueOf(service.getNextclientId()));
		  client.setProspect(false);
		  model.addAttribute("client", client);
		  model.addAttribute("cstList", service.getCstList());
		  model.addAttribute("states", service.getAllStates());
		  model.addAttribute("originTypes", service.getAllOriginTypes());
		  model.addAttribute("clientTypes", service.getAllClientTypes());
		  model.addAttribute("mode", "new");
		  return "codex/clientDetail";		  
	  }
	  catch(Exception e){
		  Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		  model.addAttribute("errorDetails", e.getMessage());
		  e.printStackTrace();
		  return "error";
	  }
  }
  
  @RequestMapping(value = "/edit.do")
  public String edit(ModelMap model, @RequestParam(required = true) Integer clientId, 
		  @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	  try{
		  ClientVO client = service.getClientById(clientId);
		  CstDTO cst = cService.getCstByEmail(userSession.getUser().getUserEmail());
		  model.addAttribute("client", client);
		  model.addAttribute("cstList", service.getCstList());
		  model.addAttribute("states", service.getAllStates());
		  model.addAttribute("originTypes", service.getAllOriginTypes());
		  model.addAttribute("clientTypes", service.getAllClientTypes());
		  model.addAttribute("userCanEdit", getUserCanEdit(client, cst));
		  
		  return "codex/clientDetail";
	  }
	  catch(Exception e){
		  Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		  model.addAttribute("errorDetails", e.getMessage());
		  e.printStackTrace();
		  return "error";
	  }
  }
  
  @RequestMapping(value = "/insert.do")
  public String insert(ModelMap model, @ModelAttribute("prospect") ClientVO client){
	  try{
		  service.insertClient(client);
		  return showClientList(model); 
	  }
	  catch(Exception e){
		  Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		  model.addAttribute("errorDetails", e.getMessage());
		  e.printStackTrace();
		  return "error";
	  }
  }
  
  @RequestMapping(value = "/getLocationsByZipCode.do", produces="application/json")
  public @ResponseBody String getLocationsByZipCode(@RequestParam(required = true) String zipCode
		                                                        , ModelMap model) {
	  try {
	        return service.getLocationsJSONByZipCode(zipCode);
	  } catch (Exception e) {
            System.out.println("getLocationsByZipCodeError=>" + e);
	  }
	  return null;
  }
  
  private Boolean getUserCanEdit(ClientVO client, CstDTO cst){
	  if(cst == null){
		  return false;
	  }
	  
	  if(!client.isProspect()){
		  return true;
	  }
	  else{
		  if(cst.getScope() > 0){
			  return true;
		  }
		  else{
			  return false;
		  }
	  }
  }
  
}
