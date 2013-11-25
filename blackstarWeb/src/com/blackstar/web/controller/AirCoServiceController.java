package com.blackstar.web.controller;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.blackstar.db.DAOFactory;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Policy;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

public class AirCoServiceController extends AbstractController {
	
	  private ServiceOrderService service = null;
	  private DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
	  
	  public void setService(ServiceOrderService service) {
		this.service = service;
	  }

	  @RequestMapping("/AirCoService/show.do")
	  public String  setup(@RequestParam(required = false) Integer serviceOrderId, ModelMap model) {
		 
		try 
		{
			//Obtener los datos de la poliza
			Policy policy  = this.daoFactory.getPolicyDAO().getPolicyBySerialNo("");
			
			
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
