package com.blackstar.web.controller;

import javax.servlet.http.HttpServletResponse;

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
import com.blackstar.model.UserSession;
import com.blackstar.services.interfaces.ReportService;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;


@Controller
@RequestMapping("/osDetail")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class ServiceOrderController extends AbstractController {
	
  private ServiceOrderService service = null;
  private ReportService rrService = null;

  public void setService(ServiceOrderService service) {
	this.service = service;
  }
  
  public void setRrService(ReportService rrService) {
	this.rrService = rrService;
  }

  @RequestMapping("/show.do")
  public String  setup(@RequestParam(required = true) Integer serviceOrderId, HttpServletResponse response) {
	String url = "error";
	try {
		String equipmentType = service.getEquipmentTypeBySOId(serviceOrderId);
		String params = "/show.do?operation=2&idObject=" + serviceOrderId;
		String aTemplate = "/aircoservice";
		String bTemplate = "/batteryservice";
		String pTemplate = "/emergencyplantservice";
		String uTemplate = "/upsservice";
		String xTemplate = "/plainservice";
		
		switch(equipmentType){
			case "A": url = aTemplate + params;
				break;
			case "B": url = bTemplate + params;
				break;
			case "P": url = pTemplate + params;
				break;
			case "U": url = uTemplate + params;
				break;
			default: url = xTemplate + params;
				break;
		}
	} catch (Exception e) {
		 Logger.Log(LogLevel.FATAL, Thread.currentThread().getStackTrace()[1].toString(), e);
		 return "error";
	}
	return "forward:" + url;
  }
  
  @RequestMapping("/showReport.do")
  public String  showReport(@RequestParam(required = true) Integer serviceOrderId
                             , @RequestParam(required = false) String osNum
                             , @ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession
                             , ModelMap model, HttpServletResponse response) {
        return null;
  }
}
