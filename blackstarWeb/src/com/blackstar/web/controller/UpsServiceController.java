package com.blackstar.web.controller;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.UpsServiceDTO;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

public class UpsServiceController extends AbstractController {
	
	  private ServiceOrderService service = null;
	    
	  public void setService(ServiceOrderService service) {
		this.service = service;
	  }

	  @RequestMapping("/UpsService/show.do")
	  public String  setup(@RequestParam(required = false) Integer serviceOrderId, ModelMap model) {
		 
		try 
		{
			UpsServiceDTO upsServiceOrder =null;
			OrderserviceDTO serviceOrderDetail = null;
			
			upsServiceOrder= service.getUpsService(serviceOrderId);
			
			if(upsServiceOrder.getServiceOrderId() != null)
			{
				serviceOrderDetail = service.getServiceOrderByIdOrNumber(upsServiceOrder.getServiceOrderId(),"");
				model.addAttribute("serviceOrderDetail", serviceOrderDetail);
				model.addAttribute("serviceOrder", upsServiceOrder);
			}
			else
				Logger.Log(LogLevel.WARNING, "UpsServiceController", "Referencia a OrderserviceDTO " + upsServiceOrder.getServiceOrderId() + " es nula" , "" );
			
		} catch (NumberFormatException e) {
			 Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		return "UpsService";
	  }

	}
