package com.blackstar.web.controller;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

public class PlainServiceController extends AbstractController {
	
	  private ServiceOrderService service = null;
	    
	  public void setService(ServiceOrderService service) {
		this.service = service;
	  }

	  @RequestMapping("/PlainService/show.do")
	  public String  setup(@RequestParam(required = false) Integer serviceOrderId, ModelMap model) {
		 
		try 
		{
			PlainServiceDTO plainServiceOrder =null;
			OrderserviceDTO serviceOrderDetail = null;
			
			plainServiceOrder= service.getPlainService(serviceOrderId);
			
			if(plainServiceOrder.getServiceOrderId() != null)
			{
				serviceOrderDetail = service.getServiceOrderByIdOrNumber(plainServiceOrder.getServiceOrderId(),"");
				model.addAttribute("serviceOrderDetail", serviceOrderDetail);
				model.addAttribute("serviceOrder", plainServiceOrder);
			}
			else
				Logger.Log(LogLevel.WARNING, "PlainServiceController", "Referencia a OrderserviceDTO " + plainServiceOrder.getServiceOrderId() + " es nula" , "" );
			
		} catch (NumberFormatException e) {
			 Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		return "PlainService";
	  }

	}
