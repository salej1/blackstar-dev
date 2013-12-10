package com.blackstar.web.controller;

import java.io.ByteArrayOutputStream;

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
import com.blackstar.services.interfaces.ReporterService;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;


@Controller
@RequestMapping("/osDetail")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class ServiceOrderController extends AbstractController {
	
  private ServiceOrderService service = null;
  private ReporterService rrService = null;
    
  public void setService(ServiceOrderService service) {
	this.service = service;
  }
  
  public void setRrService(ReporterService rrService) {
	this.rrService = rrService;
  }

  @RequestMapping("/show.do")
  public String  setup(@RequestParam(required = true) Integer serviceOrderId
		             , @RequestParam(required = false) String osNum
		             , @ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession
		             , ModelMap model) {
	try {
		 model.addAttribute("serviceOrderDetail", service.getServiceOrderByIdOrNumber(serviceOrderId
				                                                                          , osNum));
		 model.addAttribute("followUps", service.getFollows(serviceOrderId));
		 model.addAttribute("employees", udService.getStaff());
		 model.addAttribute("osAttachmentFolder", gdService.getAttachmentFolderId(serviceOrderId));
		 model.addAttribute("accessToken", gdService.getAccessToken());
	} catch (Exception e) {
		 Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		 model.addAttribute("stackTrace", e.getStackTrace());
		 model.addAttribute("errMessage", e.toString());
		 return "error";
	}
	return "osDetail";
  }
  
  @RequestMapping("/showReport.do")
  public String  showReport(@RequestParam(required = true) Integer serviceOrderId
		             , @RequestParam(required = false) String osNum
		             , @ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession
		             , ModelMap model, HttpServletResponse response) {
	  ByteArrayOutputStream file = null;
      try {
    	  file = rrService.run();
    	  response.setHeader("Content-Type", "application/pdf");
    	  response.setHeader("Content-Length", String.valueOf(file.size()));	
          response.setHeader("Content-Disposition","inline;filename=SACOrderService.pdf");
          response.getOutputStream().write(file.toByteArray(), 0, file.size());
      } catch (Exception e) {
 		 Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
 		 model.addAttribute("stackTrace", e.getStackTrace());
 		 model.addAttribute("errMessage", e.toString());
 		 return "error";
 	 }
	return null;
  }

}
