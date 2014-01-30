package com.blackstar.web.controller;

import java.util.Date;

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
import com.blackstar.interfaces.IEmailService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Equipmenttype;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.Ticket;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.PlainServicePolicyDTO;
import com.blackstar.services.interfaces.ReportService;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/plainService")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class PlainServiceController extends AbstractController {
	
	  private ServiceOrderService service = null;
	  private DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
	  private ReportService rpService = null;
	  private IEmailService gmService = null;
	  
	  public void setGmService(IEmailService gmService) {
		this.gmService = gmService;
	  }
	  
	  public void setRpService(ReportService rpService) {
		this.rpService = rpService;
	  }
	  
	  public void setService(ServiceOrderService service) {
		this.service = service;
	  }
	  
	  @RequestMapping(value= "/show.do", method = RequestMethod.GET)
	  public String  plainservice(@RequestParam(required = true) Integer operation, @RequestParam(required = true) String idObject, ModelMap model)
	  {
		  PlainServicePolicyDTO plainServicePolicyDTO =null;
		  try
		  {
			  if(operation!= null && idObject!=null)
			  {
				  //si la operation es 1, el idObject es el id de un ticket
				  //si la operation es 2, el idObject es el id de un servicio
				  //si la operation es 3, el idObject es el no de serie del equipo

		  		  if(operation==1)
		  		  {
		  			  Integer idTicket = Integer.parseInt(idObject);
		  			  Ticket ticket = daoFactory.getTicketDAO().getTicketById(idTicket);
	  				  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(ticket.getPolicyId());
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				  plainServicePolicyDTO = new PlainServicePolicyDTO(policy, equipType.getEquipmentType());
	  				  plainServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber());  
	  				  plainServicePolicyDTO.setServiceStatusId("N");
	  				  plainServicePolicyDTO.setTicketNumber(ticket.getTicketNumber());
	  				  model.addAttribute("serviceOrder", plainServicePolicyDTO);
	  				  model.addAttribute("mode", "new");
		  		  }
		  		  else if( operation==2)
		  		  {
		  			  Integer idOrderService = Integer.parseInt(idObject);
		  			  PlainServiceDTO plainServiceDTO = service.getPlainService(idOrderService);
		  			  Serviceorder serviceOrder = this.daoFactory.getServiceOrderDAO().getServiceOrderById(plainServiceDTO.getServiceOrderId());
		  			  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(serviceOrder.getPolicyId());
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				  plainServicePolicyDTO = new PlainServicePolicyDTO(policy, equipType.getEquipmentType(), serviceOrder,  plainServiceDTO);
	  				  model.addAttribute("serviceOrder", plainServicePolicyDTO);
	  				  model.addAttribute("followUps", service.getFollows(idOrderService));
	  				  model.addAttribute("mode", "detail");
		  		  }
		  		  else if(operation==3)
		  		  {
		  			  Policy policy  = this.daoFactory.getPolicyDAO().getPolicyBySerialNo(idObject);
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				  plainServicePolicyDTO = new PlainServicePolicyDTO(policy, equipType.getEquipmentType());
	  				  plainServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber(policy));
	  				  plainServicePolicyDTO.setServiceStatusId("N");
	  				  plainServicePolicyDTO.setTicketNumber("NA");
	  				  model.addAttribute("serviceOrder", plainServicePolicyDTO);
	  				  model.addAttribute("mode", "new");
		  		  }
		  		  
		  		  model.addAttribute("serviceTypes", service.getServiceTypeList());
				  model.addAttribute("serviceStatuses", service.getServiceStatusList());
				  model.addAttribute("osAttachmentFolder", gdService.getAttachmentFolderId(plainServicePolicyDTO.getServiceOrderNumber()));
	  		  }
			  else
			  {
				  Logger.Log(LogLevel.WARNING, "AirCoServiceController", "Parametros de navegacion nulos." , "" );
			  }
		  } 
		  catch (Exception e) 
		  {
				 Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
				 model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
				 return "error";
		  }
		  
		  return "plainService";
	  }
	  
	    @RequestMapping(value = "/save.do", method = RequestMethod.POST)
	    public String save( 
	    		@ModelAttribute("serviceOrder") PlainServicePolicyDTO serviceOrder,
	    		@ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession,
              ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	    {
	    	try{
		    	int idServicio = 0;
		    	// Verificar si existe una orden de servicio
		    	if(serviceOrder.getServiceOrderId()==null)
		    	{
		    		//Crear orden de servicio
		    		Serviceorder servicioOrderSave = new Serviceorder();
		    		// TODO: Se debe asignar a la coordinadora, no al ingeniero // servicioOrderSave.setAsignee( serviceOrder.getResponsible());
		    		servicioOrderSave.setPolicyId((Short.parseShort(serviceOrder.getPolicyId().toString())));
		    		servicioOrderSave.setReceivedBy(serviceOrder.getReceivedBy());
		    		servicioOrderSave.setReceivedByPosition(serviceOrder.getReceivedByPosition());
		    		servicioOrderSave.setResponsible(serviceOrder.getResponsible());
		    		servicioOrderSave.setServiceDate(serviceOrder.getServiceDate());
		    		servicioOrderSave.setServiceOrderNumber(serviceOrder.getServiceOrderNumber());
		    		servicioOrderSave.setServiceTypeId(serviceOrder.getServiceTypeId().toCharArray()[0]);
		    		servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
		    		servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
		    		servicioOrderSave.setReceivedByEmail(serviceOrder.getReceivedByEmail());
		  	        servicioOrderSave.setClosed(new Date());
			        servicioOrderSave.setStatusId("N");
		    		idServicio = service.saveServiceOrder(servicioOrderSave, "PlainServiceController", userSession.getUser().getUserName());
		    	}
		    	else
		    	{
		    		//Actualizar orden de servicio
		    		Serviceorder servicioOrderSave = new Serviceorder();
		    		servicioOrderSave.setServiceOrderId(serviceOrder.getServiceOrderId());
		    		servicioOrderSave.setAsignee( serviceOrder.getResponsible());
		    		servicioOrderSave.setClosed(serviceOrder.getClosed());
		    		servicioOrderSave.setIsWrong(serviceOrder.getIsWrong()?1:0);
		    		servicioOrderSave.setStatusId(serviceOrder.getServiceStatusId());
		    		service.updateServiceOrder(servicioOrderSave, "PlainServiceController", userSession.getUser().getUserName());
		    	}
		    	
		    	 if(serviceOrder.getPlainServiceId()==null)
                 {
                         serviceOrder.setServiceOrderId(idServicio);
                         //Crear orden de servicio de AirCo
                         service.savePlainService(new PlainServiceDTO(serviceOrder), "PlainServiceController", userSession.getUser().getUserName());
                         commit(serviceOrder);
                 }
	    	}
	    	catch(Exception e){
				 StringBuilder details = new StringBuilder(e.toString() + "\n");
				 for(StackTraceElement element : e.getStackTrace()){
					 details.append(element.toString() + "\n");
				 }
				 model.addAttribute("errorDetails", details.toString());
				 e.printStackTrace();
				 return "error";
	    	}
	    	return "dashboard";
	    }
	    
	    private void saveReport(Integer id, byte[] report) throws Exception {
	    	String parentId = gdService.getReportsFolderId(id);
	    	gdService.insertFileFromStream(id, "application/pdf"
	    			   , "ServiceOrder.pdf", parentId, report);
	    }
	    
	    private void sendNotification(String to, byte [] report){
	    	gmService.sendEmail(to, "Orden de Servicio", "Orden de Servicio"
	    			                          , "ServiceOrder.pdf", report);
	    }
	    
	    private void commit(PlainServicePolicyDTO serviceOrder) throws Exception {
	      byte [] report = rpService.getGeneralReport(serviceOrder);
	      saveReport(serviceOrder.getServiceOrderId(), report);
	      sendNotification(serviceOrder.getReceivedByEmail(), report);
	    }
	}
