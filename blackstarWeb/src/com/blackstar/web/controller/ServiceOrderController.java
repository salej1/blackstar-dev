package com.blackstar.web.controller;

import javax.servlet.http.HttpServletRequest;

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
  public String  setup(@RequestParam(required = true) Integer serviceOrderId
		             , @RequestParam(required = false) String osNum
		             , ModelMap model, HttpServletRequest req) {
	try {
		 model.addAttribute("serviceOrderDetail", service.getServiceOrderByIdOrNumber(serviceOrderId
				                                                                          , osNum));
		 model.addAttribute("followUps", service.getFollows(serviceOrderId));
		 model.addAttribute("employees", udService.getStaff());
		 model.addAttribute("osAttachmentFolder", gdService.getAttachmentFolderId(serviceOrderId));
	} catch (Exception e) {
		 Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		 e.printStackTrace();
		 return "error";
	}
	return "osDetail";
  }

}
