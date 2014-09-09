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
import com.blackstar.model.OpenCustomer;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.AirCoServicePolicyDTO;
import com.blackstar.services.interfaces.OpenCustomerService;
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
	  private OpenCustomerService ocService = null; // OpenCustomerService
	  
	  public void setGmService(IEmailService gmService) {
		this.gmService = gmService;
	  }
	  
	  public void setRpService(ReportService rpService) {
		this.rpService = rpService;
	  }

	  public void setService(ServiceOrderService service) {
		this.service = service;
	  }
	  
	  public void setOcService(OpenCustomerService customerService) {
		this.ocService = customerService;
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
				  //si la operation es 4, el idObject es irrelevante (sin poliza)
		  		  if(operation==1)
		  		  {
		  			 return "redirect:/plainService?operation=1&idObject=" + idObject;
		  		  }
		  		  else if( operation==2)
		  		  {
		  			  Integer idOrder = Integer.parseInt(idObject);
		  			  AirCoServiceDTO aircoService = service.getAirCoService(idOrder);
		  			  Serviceorder serviceOrder = this.daoFactory.getServiceOrderDAO().getServiceOrderById(idOrder);
		  			  
		  			  // Verificar si la OS pertenece a poliza o a cliente abierto
		  			  if(serviceOrder.getPolicyId() != null && serviceOrder.getPolicyId() > 0){
		  				Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(serviceOrder.getPolicyId());
		  				airCoServicePolicyDTO = new AirCoServicePolicyDTO(policy, serviceOrder, aircoService );
		  				model.addAttribute("hasPolicy", true);
		  			  }
		  			  else if(serviceOrder.getOpenCustomerId() != null && serviceOrder.getOpenCustomerId() > 0){
		  				OpenCustomer customer = ocService.GetOpenCustomerById(serviceOrder.getOpenCustomerId());
		  				if(customer.getEquipmentTypeId() == null || customer.getEquipmentTypeId() == ""){
		  					throw new Exception("Cliente asociado a la OS no tiene tipo de equipo valido registrado");
		  				}
		  				airCoServicePolicyDTO = new AirCoServicePolicyDTO(customer, serviceOrder, aircoService);
		  				model.addAttribute("hasPolicy", false);
		  			  }
	  				  
	  				  model.addAttribute("serviceOrder", airCoServicePolicyDTO);
	  				  model.addAttribute("mode", "detail");
	  				  model.addAttribute("followUps", service.getFollows(idOrder));
		  		  }
		  		  else if(operation==3)
		  		  {
		  			  Policy policy  = this.daoFactory.getPolicyDAO().getPolicyBySerialNo(idObject);
	  				  airCoServicePolicyDTO = new AirCoServicePolicyDTO(policy);
	  				  airCoServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber("A"));
	  				  airCoServicePolicyDTO.setServiceStatusId("N");
	  				  airCoServicePolicyDTO.setServiceTypeId("P");
	  				  model.addAttribute("serviceOrder", airCoServicePolicyDTO);
	  				  model.addAttribute("serviceEmployees", udService.getStaffByGroupJson(Globals.GROUP_SERVICE));
	  				  model.addAttribute("mode", "new");
	  				  model.addAttribute("hasPolicy", true);
		  		  }
		  		  else if(operation==4){
		  			  OpenCustomer cust = new OpenCustomer();
		  			  cust.setEquipmentTypeId("A");
		  			  airCoServicePolicyDTO = new AirCoServicePolicyDTO(new OpenCustomer());
		  			  airCoServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber("A"));
		  			  airCoServicePolicyDTO.setServiceStatusId("N");
	  				  airCoServicePolicyDTO.setServiceTypeId("P");
	  				  model.addAttribute("serviceOrder", airCoServicePolicyDTO);
	  				  model.addAttribute("serviceEmployees", udService.getStaffByGroupJson(Globals.GROUP_SERVICE));
	  				  model.addAttribute("mode", "new");
	  				  model.addAttribute("hasPolicy", false);
		  		  }
		  		  
		  		  model.addAttribute("serviceTypes", service.getServiceTypeList());
				  model.addAttribute("serviceStatuses", service.getServiceStatusList());
				  model.addAttribute("osAttachmentFolder", gdService.getAttachmentFolderId(airCoServicePolicyDTO.getServiceOrderNumber()));
				  model.addAttribute("rootFolder", gdService.getRootFolderId());
				  model.addAttribute("accessToken", gdService.getAccessToken());
				  model.addAttribute("equipmentTypeList", service.getEquipmentTypeList());
				  model.addAttribute("checkOptions", this.getCheckOptions());
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
                     ModelMap model) throws Exception{
    int idServicio = 0;
    boolean doCommit = false;
    int custId = 0;
	try {
			// update?
			if(serviceOrder.getServiceOrderId() != null && serviceOrder.getServiceOrderId() > 0){
				// Update
				Serviceorder servicioOrderSave = new Serviceorder();
				servicioOrderSave.setServiceOrderId(serviceOrder.getServiceOrderId());
				if(serviceOrder.getClosed() != null && serviceOrder.getServiceStatusId().equals("C")){
					serviceOrder.setAsignee(null);
				}
				servicioOrderSave.setClosed(serviceOrder.getClosed());
				servicioOrderSave.setIsWrong(serviceOrder.getIsWrong()?1:0);
				servicioOrderSave.setServiceStatusId(serviceOrder.getServiceStatusId());
			
				service.updateServiceOrder(servicioOrderSave, "AirCoServiceController", userSession.getUser().getUserEmail());
			}
			else{
				// Sin poliza
				if(serviceOrder.getPolicyId() == null  || serviceOrder.getPolicyId() == 0){
					// Guardando el cliente capturado
		    		OpenCustomer customer = new OpenCustomer();
		    		customer.setCustomerName(serviceOrder.getCustomer());
		    		customer.setContactEmail(serviceOrder.getFinalUser());
		    		customer.setEquipmentTypeId("A");
		    		customer.setBrand(serviceOrder.getBrand());
		    		customer.setModel(serviceOrder.getModel());
		    		customer.setSerialNumber(serviceOrder.getSerialNumber());
		    		customer.setCapacity(serviceOrder.getCapacity());
		    		customer.setAddress(serviceOrder.getEquipmentAddress());
		    		customer.setContactName(serviceOrder.getContactName());
		    		customer.setPhone(serviceOrder.getContactPhone());
		    		customer.setProject(serviceOrder.getProject());
		    		customer.setOfficeId(String.valueOf(serviceOrder.getOfficeId()));		    		
		    		customer.setCreated(new Date());
		    		customer.setCreatedBy("AircoServiceController");
		    		customer.setCreatedByUsr(userSession.getUser().getUserEmail());
		    		custId = ocService.SaveOpenCustomer(customer);
		    		
				}
				// Guardando la OS 
	    		Serviceorder servicioOrderSave = new Serviceorder();
	    		if(custId > 0){
	    			servicioOrderSave.setOpenCustomerId(custId);
	    		}
				servicioOrderSave.setReceivedBy(serviceOrder.getReceivedBy());
				servicioOrderSave.setReceivedByPosition(serviceOrder.getReceivedByPosition());
				servicioOrderSave.setEmployeeListString(serviceOrder.getResponsible());
				servicioOrderSave.setServiceDate(serviceOrder.getServiceDate());
				servicioOrderSave.setServiceEndDate(serviceOrder.getServiceEndDate());
				servicioOrderSave.setServiceOrderNumber(serviceOrder.getServiceOrderNumber());
				servicioOrderSave.setServiceTypeId(serviceOrder.getServiceTypeId().toCharArray()[0]);
				servicioOrderSave.setReceivedByEmail(serviceOrder.getReceivedByEmail());
	    		servicioOrderSave.setIsWrong(serviceOrder.getIsWrong()?1:0);
	    		servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
	    		servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
	    		if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_COORDINATOR) != null){
	    			servicioOrderSave.setStatusId("E");
	    		}
	    		else{
	    			servicioOrderSave.setStatusId("N");	
	    		}
				servicioOrderSave.setPolicyId(serviceOrder.getPolicyId());
				servicioOrderSave.setResponsible(serviceOrder.getResponsible());
				servicioOrderSave.setTicketId(serviceOrder.getTicketId());
				servicioOrderSave.setHasPdf(1);
				
				idServicio = service.saveServiceOrder(servicioOrderSave, "PlainServiceController", userSession.getUser().getUserEmail());
				doCommit = true;
		}
	   
	    if(serviceOrder.getAaServiceId() == null && doCommit) {
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
	    throw e;
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
  	gdService.insertFileFromStream(id, "application/pdf", "ServiceOrder.pdf", parentId, report);
  }
  
  private void sendNotification(String to, byte [] report){
  	gmService.sendEmail(to, "Reporte de servicio de Aire Acondicionado", "Reporte de servicio de Aire Acondicionado", "ServiceOrder.pdf", report);
  }

}
