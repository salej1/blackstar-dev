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
import com.blackstar.model.Serviceorder;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.OrderserviceDTO;
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
		OrderserviceDTO so = service.getServiceOrderByIdOrNumber(serviceOrderId, null);
		if(so == null){
			throw new Exception("No se encontro la orden de servicio con ID: " + serviceOrderId.toString());
		}
		
		String params = "/show.do?operation=2&idObject=" + serviceOrderId;
		String aTemplate = "/aircoService";
		String bTemplate = "/batteryService";
		String pTemplate = "/emergencyPlantService";
		String uTemplate = "/upsService";
		String xTemplate = "/plainService";
		
		if(so.getServiceOrderNo().indexOf("-e") > 0){
			switch(so.getServiceOrderNo().substring(0, 2)){
				case "AA": url = aTemplate + params;
					break;
				case "BB": url = bTemplate + params;
					break;
				case "PE": url = pTemplate + params;
					break;
				case "UP": url = uTemplate + params;
					break;
				default: url = xTemplate + params;
					break;
			}
		}
		else{
			url = xTemplate + params;
		}
		
	} catch (Exception e) {
		 Logger.Log(LogLevel.FATAL, e.getStackTrace()[0].toString(), e);
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
