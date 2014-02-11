package com.blackstar.web.controller;

import java.util.Date;

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
import com.blackstar.model.AirCoService;
import com.blackstar.model.Equipmenttype;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.Ticket;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.AirCoServicePolicyDTO;
import com.blackstar.services.interfaces.ReportService;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/aircoService")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class AirCoServiceController extends AbstractController {
	
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
	  public String  aircoservice(@RequestParam(required = true) Integer operation, @RequestParam(required = true) String idObject, ModelMap model)
	  {
		  AirCoServicePolicyDTO airCoServicePolicyDTO =null;
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
	  				  airCoServicePolicyDTO = new AirCoServicePolicyDTO(policy, equipType.getEquipmentType());
	  				  airCoServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber(policy));
	  				  airCoServicePolicyDTO.setServiceStatusId("N");
	  				  airCoServicePolicyDTO.setServiceTypeId("P");
	  				  model.addAttribute("serviceOrder", airCoServicePolicyDTO);
	  				  model.addAttribute("serviceEmployees", udService.getStaffByGroupJson(Globals.GROUP_SERVICE));
	  				  model.addAttribute("mode", "new");
		  		  }
		  		  else if( operation==2)
		  		  {
		  			  Integer idOrder = Integer.parseInt(idObject);
		  			  AirCoServiceDTO aircoService = service.getAirCoService(idOrder);
		  			  Serviceorder serviceOrder = this.daoFactory.getServiceOrderDAO().getServiceOrderById(idOrder);
		  			  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(serviceOrder.getPolicyId());
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				  airCoServicePolicyDTO = new AirCoServicePolicyDTO(policy, equipType.getEquipmentType(), serviceOrder, aircoService );
	  				  model.addAttribute("serviceOrder", airCoServicePolicyDTO);
	  				  model.addAttribute("mode", "detail");
		  		  }
		  		  else if(operation==3)
		  		  {
		  			  Policy policy  = this.daoFactory.getPolicyDAO().getPolicyBySerialNo(idObject);
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				  airCoServicePolicyDTO = new AirCoServicePolicyDTO(policy, equipType.getEquipmentType());
	  				  airCoServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber(policy));
	  				  airCoServicePolicyDTO.setServiceStatusId("N");
	  				  airCoServicePolicyDTO.setServiceTypeId("P");
	  				  model.addAttribute("serviceOrder", airCoServicePolicyDTO);
	  				  model.addAttribute("serviceEmployees", udService.getStaffByGroupJson(Globals.GROUP_SERVICE));
	  				  model.addAttribute("mode", "new");
		  		  }
		  		model.addAttribute("osAttachmentFolder", gdService.getAttachmentFolderId(airCoServicePolicyDTO.getServiceOrderNumber()));
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
		  
		  return "aircoService";
	  }
	  
  @RequestMapping(value = "/save.do", method = RequestMethod.POST)
  public String save(@ModelAttribute("serviceOrder") AirCoServicePolicyDTO serviceOrder,
	    		     @ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession,
                     ModelMap model){
    int idServicio = 0;
	try {
	   	 // Verificar si existe una orden de servicio
	    if(serviceOrder.getServiceOrderId()==null){
	      //Crear orden de servicio
	      Serviceorder servicioOrderSave = new Serviceorder();
	      servicioOrderSave.setPolicyId((Short.parseShort(serviceOrder.getPolicyId().toString())));
	      servicioOrderSave.setReceivedBy(serviceOrder.getReceivedBy());
	      servicioOrderSave.setReceivedByPosition(serviceOrder.getReceivedByPosition());
	      servicioOrderSave.setEmployeeListString(serviceOrder.getResponsible());
	      servicioOrderSave.setServiceDate(serviceOrder.getServiceDate());
	      servicioOrderSave.setServiceOrderNumber(serviceOrder.getServiceOrderNumber());
	      servicioOrderSave.setServiceTypeId(serviceOrder.getServiceTypeId().toCharArray()[0]);
	      servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
	      servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
	      servicioOrderSave.setReceivedByEmail(serviceOrder.getReceivedByEmail());
	      servicioOrderSave.setClosed(new Date());
	      servicioOrderSave.setStatusId("N");
	      idServicio = service.saveServiceOrder(servicioOrderSave, "AirCoServiceController", userSession.getUser().getUserName());
	    } else {
	    	//Actualizar orden de servicio
	    	Serviceorder servicioOrderSave = new Serviceorder();
	    	servicioOrderSave.setClosed(serviceOrder.getClosed());
	    	servicioOrderSave.setPolicyId((Short.parseShort(serviceOrder.getPolicyId().toString())));
	    	servicioOrderSave.setReceivedBy(serviceOrder.getReceivedBy());
	    	servicioOrderSave.setReceivedByPosition(serviceOrder.getReceivedByPosition());
	    	servicioOrderSave.setEmployeeListString(serviceOrder.getResponsible());
	    	servicioOrderSave.setServiceDate(serviceOrder.getServiceDate());
	    	servicioOrderSave.setServiceOrderNumber(serviceOrder.getServiceOrderNumber());
	    	servicioOrderSave.setServiceTypeId(serviceOrder.getServiceTypeId().toCharArray()[0]);
	    	servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
	    	servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
	    	servicioOrderSave.setStatusId("N");
	    	service.updateServiceOrder(servicioOrderSave, "AirCoServiceController", userSession.getUser().getUserName());
	    }
	    if(serviceOrder.getAaServiceId()==null) {
	      serviceOrder.setServiceOrderId(idServicio);
	      //Crear orden de servicio de AirCo
	      service.saveAirCoService(new AirCoServiceDTO(serviceOrder), "AirCoServiceController", userSession.getUser().getUserName());
	      commit(serviceOrder);
	    }
	} catch(Exception e){
	    Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1]
	    		                                           .toString(), e);
	    e.printStackTrace();
	    model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
	    return "error";
	}
    return "dashboard";
  }
  
  private void commit(AirCoServicePolicyDTO serviceOrder) throws Exception {
	byte [] report = rpService.getAirCoReport(serviceOrder);
	saveReport(serviceOrder.getServiceOrderId(), report);
	sendNotification(serviceOrder.getReceivedByEmail(), report);
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

}
