package com.blackstar.web.controller;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

public class AirCoServiceController extends AbstractController {
	
	  private ServiceOrderService service = null;
	    
	  public void setService(ServiceOrderService service) {
		this.service = service;
	  }

	  @RequestMapping("/AirCoService/show.do")
	  public String  setup(@RequestParam(required = false) Integer serviceOrderId, ModelMap model) {
		 
		try 
		{
			AirCoServiceDTO airCoServiceOrder =null;
			OrderserviceDTO serviceOrderDetail = null;
			
			airCoServiceOrder= service.getAirCoService(serviceOrderId);
			
			if(airCoServiceOrder.getServiceOrderId() != null)
			{
				serviceOrderDetail = service.getServiceOrderByIdOrNumber(airCoServiceOrder.getServiceOrderId(),"");
				model.addAttribute("serviceOrderDetail", serviceOrderDetail);
				model.addAttribute("serviceOrder", airCoServiceOrder);
			}
			else
				Logger.Log(LogLevel.WARNING, "AirCoServiceController", "Referencia a OrderserviceDTO " + airCoServiceOrder.getServiceOrderId() + " es nula" , "" );
			
		} catch (NumberFormatException e) {
			 Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		return "AirCoService";
	  }

	}
