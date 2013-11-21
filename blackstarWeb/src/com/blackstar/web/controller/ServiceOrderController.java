package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;


@Controller
public class ServiceOrderController extends AbstractController {
	
  private ServiceOrderService service = null;
    
  public void setService(ServiceOrderService service) {
	this.service = service;
  }

  @RequestMapping("/osDetail/show.do")
  public String  setup(@RequestParam(required = false) Integer serviceOrderId
		             , @RequestParam(required = false) String osNum, ModelMap model) {
	OrderserviceDTO serviceOrder = null; 
	try {
		 serviceOrder = service.getServiceOrderByIdOrNumber(serviceOrderId, osNum);
		 model.addAttribute("serviceOrderDetail", serviceOrder);
		 model.addAttribute("followUps", service.getFollows(serviceOrder.getServiceOrderId()));
		 model.addAttribute("employees", udService.getStaff());
	} catch (NumberFormatException e) {
		 Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
	}
	return "osDetail";
  }

}
