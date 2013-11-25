package com.blackstar.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.UserSession;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;


@Controller
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class ServiceOrderController extends AbstractController {
	
  private ServiceOrderService service = null;
    
  public void setService(ServiceOrderService service) {
	this.service = service;
  }

  @RequestMapping("/osDetail/show.do")
  public String  setup(@RequestParam(required = true) Integer serviceOrderId
		             , @RequestParam(required = false) String osNum
		             , @ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession
		             , ModelMap model, HttpServletRequest req, HttpServletResponse resp) {
	try {
		 System.out.println("2. gId = > " + userSession.getGoogleId());
		 model.addAttribute("serviceOrderDetail", service.getServiceOrderByIdOrNumber(serviceOrderId
				                                                                          , osNum));
		 model.addAttribute("followUps", service.getFollows(serviceOrderId));
		 model.addAttribute("employees", udService.getStaff());
		 model.addAttribute("osAttachmentFolder", gdService.getAttachmentFolderId(serviceOrderId
				                   , secService.getStoredCredential(userSession.getGoogleId())));
	} catch (Exception e) {
		 Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		 
		 model.addAttribute("stackTrace", e.getStackTrace());
		 model.addAttribute("errMessage", e.toString());
		 return "error";
	}
	return "osDetail";
  }

}
