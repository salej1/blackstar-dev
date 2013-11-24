package com.blackstar.web.controller;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

public class BatteryServiceController extends AbstractController {
	
	  private ServiceOrderService service = null;
	    
	  public void setService(ServiceOrderService service) {
		this.service = service;
	  }

	  @RequestMapping("/BatteryService/show.do")
	  public String  setup(@RequestParam(required = false) Integer serviceOrderId, ModelMap model) {
		 
		try 
		{
			BatteryServiceDTO batteryServiceOrder =null;
			OrderserviceDTO serviceOrderDetail = null;
			
			batteryServiceOrder= service.getBateryService(serviceOrderId);
			
			if(batteryServiceOrder.getServiceOrderId() != null)
			{
				serviceOrderDetail = service.getServiceOrderByIdOrNumber(batteryServiceOrder.getServiceOrderId(),"");
				model.addAttribute("serviceOrderDetail", serviceOrderDetail);
				model.addAttribute("serviceOrder", batteryServiceOrder);
			}
			else
				Logger.Log(LogLevel.WARNING, "BatteryServiceController", "Referencia a OrderserviceDTO " + batteryServiceOrder.getServiceOrderId() + " es nula" , "" );
			
		} catch (NumberFormatException e) {
			 Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		return "BatteryService";
	  }

	}
