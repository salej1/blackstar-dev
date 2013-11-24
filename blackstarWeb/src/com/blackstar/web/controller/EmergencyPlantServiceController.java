package com.blackstar.web.controller;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

public class EmergencyPlantServiceController extends AbstractController {
	
	  private ServiceOrderService service = null;
	    
	  public void setService(ServiceOrderService service) {
		this.service = service;
	  }

	  @RequestMapping("/EmergencyPlantService/show.do")
	  public String  setup(@RequestParam(required = false) Integer serviceOrderId, ModelMap model) {
		 
		try 
		{
			EmergencyPlantServiceDTO emergencyPlantService =null;
			OrderserviceDTO serviceOrderDetail = null;
			
			emergencyPlantService= service.getEmergencyPlantService(serviceOrderId);
			
			if(emergencyPlantService.getServiceOrderId() != null)
			{
				serviceOrderDetail = service.getServiceOrderByIdOrNumber(emergencyPlantService.getServiceOrderId(),"");
				model.addAttribute("serviceOrderDetail", serviceOrderDetail);
				model.addAttribute("serviceOrder", emergencyPlantService);
			}
			else
				Logger.Log(LogLevel.WARNING, "EmergencyPlantServiceController", "Referencia a OrderserviceDTO " + emergencyPlantService.getServiceOrderId() + " es nula" , "" );
			
		} catch (NumberFormatException e) {
			 Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		return "EmergencyPlantServiceDTO";
	  }

	}
