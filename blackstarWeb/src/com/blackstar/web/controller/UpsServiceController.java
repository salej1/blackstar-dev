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
import com.blackstar.model.dto.EmergencyPlantServicePolicyDTO;
import com.blackstar.model.dto.UpsServiceDTO;
import com.blackstar.model.dto.UpsServicePolicyDTO;
import com.blackstar.services.interfaces.ReportService;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/upsService")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class UpsServiceController extends AbstractController {
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
	  public String  upsservice(@RequestParam(required = true) Integer operation, @RequestParam(required = true) String idObject, ModelMap model)
	  {
		  UpsServicePolicyDTO upsServicePolicyDTO =null;
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
	  				  upsServicePolicyDTO = new UpsServicePolicyDTO(policy, equipType.getEquipmentType());
					  upsServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber(policy));
					  upsServicePolicyDTO.setServiceStatusId("N");
					  upsServicePolicyDTO.setServiceTypeId("P");
	  				  model.addAttribute("serviceOrder", upsServicePolicyDTO);
	  				  model.addAttribute("mode", "new");
		  		  }
		  		  else if( operation==2)
		  		  {
		  			  Integer idOrder = Integer.parseInt(idObject);
		  			  Serviceorder serviceOrder = this.daoFactory.getServiceOrderDAO().getServiceOrderById(idOrder);
		  			  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(serviceOrder.getPolicyId());
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				  upsServicePolicyDTO = new UpsServicePolicyDTO(policy, equipType.getEquipmentType(), serviceOrder );
	  				  model.addAttribute("serviceOrder", upsServicePolicyDTO);
	  				  model.addAttribute("mode", "detail");
		  		  }
		  		  else if(operation==3)
		  		  {
		  			  Policy policy  = this.daoFactory.getPolicyDAO().getPolicyBySerialNo(idObject);
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				  upsServicePolicyDTO = new UpsServicePolicyDTO(policy, equipType.getEquipmentType());
					  upsServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber(policy));
					  upsServicePolicyDTO.setServiceStatusId("N");
					  upsServicePolicyDTO.setServiceTypeId("P");
	  				  model.addAttribute("serviceOrder", upsServicePolicyDTO);
	  				  model.addAttribute("mode", "new");
		  		  }

		  		  model.addAttribute("osAttachmentFolder", gdService.getAttachmentFolderId(upsServicePolicyDTO.getServiceOrderNumber()));
	  		  }
			  else
			  {
				  Logger.Log(LogLevel.WARNING, "UpsServiceController", "Parametros de navegacion nulos." , "" );
			  }
		  } 
		  catch (Exception e) 
		  {
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
			return "error";
		  }
		  
		  return "upsService";
	  }
	  
	    @RequestMapping(value = "/save.do", method = RequestMethod.POST)
	    public String save( 
	    		@ModelAttribute("serviceOrder") UpsServicePolicyDTO serviceOrder,
	    		@ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession,
              ModelMap model, HttpServletRequest req, HttpServletResponse resp) throws Exception{
	    	int idServicio = 0;

			try{
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
	    			servicioOrderSave.setServiceTypeId(serviceOrder.getServiceTypeId().toCharArray()[0]);
	    			servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
	    			servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
	    			servicioOrderSave.setClosed(new Date());
	    		    servicioOrderSave.setStatusId("N");
	    			idServicio = service.saveServiceOrder(servicioOrderSave, "UpsServiceController", userSession.getUser().getUserName());
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
	    			servicioOrderSave.setServiceTypeId(serviceOrder.getServiceTypeId().toCharArray()[0]);
	    			servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
	    			servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
	    			servicioOrderSave.setStatusId("N");
	    			service.updateServiceOrder(servicioOrderSave, "UpsServiceController", userSession.getUser().getUserName());
	    		}
	    	
	    		if(serviceOrder.getUpsServiceId()==null)
	    		{
	    			serviceOrder.setServiceOrderId(idServicio);
	    			//Crear orden de servicio de UpsService
	    			service.saveUpsService(new UpsServiceDTO(serviceOrder), "UpsServiceController", userSession.getUser().getUserName());
	    			saveReport(serviceOrder);
	    		}
			}
			catch (Exception e) 
			{
				Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
				e.printStackTrace();
				model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
				return "error";
			}
	    	
	    	return "dashboard";
	    }
	    
  private void saveReport(UpsServicePolicyDTO serviceOrder) throws Exception {
	Integer id = serviceOrder.getServiceOrderId();
	String parentId = gdService.getReportsFolderId(id);
	gdService.insertFileFromStream(id, "application/pdf", "ServiceOrder.pdf"
	    	      , parentId, rpService.getUPSReport(serviceOrder));
  }
}
