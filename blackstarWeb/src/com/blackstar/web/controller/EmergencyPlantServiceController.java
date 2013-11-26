package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.db.DAOFactory;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Policy;
import com.blackstar.model.Ticket;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/emergencyplantservice")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class EmergencyPlantServiceController extends AbstractController {
	
	  private ServiceOrderService service = null;
	  private DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
	  
	  public void setService(ServiceOrderService service) {
		this.service = service;
	  }
	  
	  @RequestMapping(value= "/show.do", method = RequestMethod.GET)
	  public String  emergencyplantservice(@RequestParam(required = true) Integer operation, @RequestParam(required = true) String idObject, ModelMap model)
	  {
		  try
		  {
			  if(operation!= null && idObject!=null)
			  {
				  //si la operation es 1, el idObject es el id de un ticket
				  //si la operation es 2, el idObject es el id de un servicio
				  //si la operation es 3, el idObject es el no de serie del equipo
				  //si la operation es 4, el idObject es el id del aircoservice
		  		  if(operation==1)
		  		  {
		  			  Integer idTicket = Integer.parseInt(idObject);
		  			  Ticket ticket = daoFactory.getTicketDAO().getTicketById(idTicket);
		  			  
		  			  if(ticket.getPolicyId()!=0)
		  			  {	
		  				  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(ticket.getPolicyId());
		  				  model.addAttribute("policyDetail", policy);
		  				  model.addAttribute("serviceOrder", new EmergencyPlantServiceDTO());
		  			  }
		  		  }
		  		  else if( operation==2)
		  		  {
		  			  OrderserviceDTO serviceOrderDetail = null;
		  			
		  			  Integer idOrderService = Integer.parseInt(idObject);
		  			  serviceOrderDetail = service.getServiceOrderByIdOrNumber(idOrderService,"");
		  			  			  
		  			  if(serviceOrderDetail.getPolicyId()!=0)
		  			  {	
		  				  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(serviceOrderDetail.getPolicyId());
		  				  model.addAttribute("policyDetail", policy);
		  				  model.addAttribute("serviceOrder", new EmergencyPlantServiceDTO());
		  				  model.addAttribute("serviceOrderDetail", serviceOrderDetail);
		  			  }  
		  		  }
		  		  else if(operation==3)
		  		  {
		  			  Policy policy  = this.daoFactory.getPolicyDAO().getPolicyBySerialNo(idObject);
		  			  if(policy.getPolicyId()!=0)
		  			  {	
		  				  model.addAttribute("policyDetail", policy);
		  				  model.addAttribute("serviceOrder", new EmergencyPlantServiceDTO());
		  			  }  
		  		  }
		  		  else if(operation ==4)
		  		  {
		  			  Integer idOrderService = Integer.parseInt(idObject);
		  			  EmergencyPlantServiceDTO emergencyService = service.getEmergencyPlantService(idOrderService);
		  			  
		  			  OrderserviceDTO serviceOrderDetail = null;
		  			  serviceOrderDetail = service.getServiceOrderByIdOrNumber(emergencyService.getServiceOrderId(),"");
		  			  			  
		  			  if(serviceOrderDetail.getPolicyId()!=0)
		  			  {	
		  				  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(serviceOrderDetail.getPolicyId());
		  				  model.addAttribute("policyDetail", policy);
		  				  model.addAttribute("serviceOrder", emergencyService);
		  				  model.addAttribute("serviceOrderDetail", serviceOrderDetail);
		  			  }  
		  		  }
	  		  }
			  else
			  {
				  Logger.Log(LogLevel.WARNING, "EmergencyPlantServiceController", "Parametros de navegacion nulos." , "" );
			  }
		  } 
		  catch (Exception e) 
		  {
				 Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		  }
		  
		  return "emergencyplantservice";
	  }


	}
