package com.blackstar.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.db.DAOFactory;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Equipmenttype;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.Ticket;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServicePolicyDTO;
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
		  EmergencyPlantServicePolicyDTO emergencyPlantServicePolicyDTO =null;
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
	  				  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(ticket.getPolicyId());
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				  emergencyPlantServicePolicyDTO = new EmergencyPlantServicePolicyDTO(policy, equipType.getEquipmentType());
	  				  model.addAttribute("serviceOrder", emergencyPlantServicePolicyDTO);
		  		  }
		  		  else if( operation==2)
		  		  {
		  			  Integer idOrder = Integer.parseInt(idObject);
		  			  Serviceorder serviceOrder = this.daoFactory.getServiceOrderDAO().getServiceOrderById(idOrder);
		  			  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(serviceOrder.getPolicyId());
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				  emergencyPlantServicePolicyDTO = new EmergencyPlantServicePolicyDTO(policy, equipType.getEquipmentType(), serviceOrder );
	  				  model.addAttribute("serviceOrder", emergencyPlantServicePolicyDTO);
		  		  }
		  		  else if(operation==3)
		  		  {
		  			  Policy policy  = this.daoFactory.getPolicyDAO().getPolicyBySerialNo(idObject);
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				  emergencyPlantServicePolicyDTO = new EmergencyPlantServicePolicyDTO(policy, equipType.getEquipmentType());
	  				  model.addAttribute("serviceOrder", emergencyPlantServicePolicyDTO);
		  		  }
		  		  else if(operation ==4)
		  		  {
		  			  Integer idOrderService = Integer.parseInt(idObject);
		  			EmergencyPlantServiceDTO emergencyPlantServiceDTO = service.getEmergencyPlantService(idOrderService);
		  			  Serviceorder serviceOrder = this.daoFactory.getServiceOrderDAO().getServiceOrderById(emergencyPlantServiceDTO.getServiceOrderId());
		  			  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(serviceOrder.getPolicyId());
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				emergencyPlantServicePolicyDTO = new EmergencyPlantServicePolicyDTO(policy, equipType.getEquipmentType(), serviceOrder,  emergencyPlantServiceDTO);
	  				  model.addAttribute("serviceOrder", emergencyPlantServicePolicyDTO);
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
	  
	    @RequestMapping(value = "/save.do", method = RequestMethod.POST)
	    public String save( 
	    		@ModelAttribute("serviceOrder") EmergencyPlantServicePolicyDTO serviceOrder,
	    		@ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession,
              ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	    {
	    	int idServicio = 0;
	    	// Verificar si existe una orden de servicio
	    	if(serviceOrder.getServiceOrderId()==null)
	    	{
	    		//Crear orden de servicio
	    		Serviceorder servicioOrderSave = new Serviceorder();
	    		servicioOrderSave.setAsignee( serviceOrder.getResponsible());
	    		servicioOrderSave.setClosed(serviceOrder.getClosed());
	    		servicioOrderSave.setPolicyId((Short.parseShort(serviceOrder.getPolicyId().toString())));
	    		servicioOrderSave.setReceivedBy(serviceOrder.getReceivedBy());
	    		servicioOrderSave.setReceivedByPosition(serviceOrder.getReceivedByPosition());
	    		servicioOrderSave.setResponsible(serviceOrder.getResponsible());
	    		servicioOrderSave.setServiceDate(serviceOrder.getServiceDate());
	    		servicioOrderSave.setServiceOrderNumber(serviceOrder.getServiceOrderNumber());
	    		servicioOrderSave.setServiceTypeId('I');
	    		servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
	    		servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
	    		servicioOrderSave.setStatusId("N");
	    		idServicio = service.saveServiceOrder(servicioOrderSave, "EmergencyPlantServiceController", userSession.getUser().getUserName());
	    	}
	    	else
	    	{
	    		//Actualizar orden de servicio
	    		Serviceorder servicioOrderSave = new Serviceorder();
	    		servicioOrderSave.setAsignee( serviceOrder.getResponsible());
	    		servicioOrderSave.setClosed(serviceOrder.getClosed());
	    		servicioOrderSave.setPolicyId((Short.parseShort(serviceOrder.getPolicyId().toString())));
	    		servicioOrderSave.setReceivedBy(serviceOrder.getReceivedBy());
	    		servicioOrderSave.setReceivedByPosition(serviceOrder.getReceivedByPosition());
	    		servicioOrderSave.setResponsible(serviceOrder.getResponsible());
	    		servicioOrderSave.setServiceDate(serviceOrder.getServiceDate());
	    		servicioOrderSave.setServiceOrderNumber(serviceOrder.getServiceOrderNumber());
	    		servicioOrderSave.setServiceTypeId('I');
	    		servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
	    		servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
	    		servicioOrderSave.setStatusId("N");
	    		service.updateServiceOrder(servicioOrderSave, "EmergencyPlantServiceController", userSession.getUser().getUserName());
	    	}
	    	
	    	if(serviceOrder.getEpServiceId()==null)
	    	{
	    		serviceOrder.setServiceOrderId(idServicio);
	    		//Crear orden de servicio de AirCo
	    		service.saveEmergencyPlantService(new EmergencyPlantServiceDTO(serviceOrder), "EmergencyPlantServiceController", userSession.getUser().getUserName());
	    	}

	    	return "dashboard";
	    }

	}
