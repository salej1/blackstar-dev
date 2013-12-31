package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.blackstar.services.interfaces.OfflineOSService;
import com.blackstar.web.AbstractController;


@Controller
@RequestMapping("/offlineOS")
public class OfflineOSController extends AbstractController {
	
  private OfflineOSService service;
	
  public void setService(OfflineOSService service) {
	this.service = service;
  }

  @RequestMapping(value = "/save.do", method = RequestMethod.POST, produces="text/plain")
  public String save(@RequestParam(required = true) String json,ModelMap model){
	try{
	    service.save(json, "offline");
	} catch(Exception e){
		e.printStackTrace();
		return e.toString();
	}
	return "OK";
  }

}
