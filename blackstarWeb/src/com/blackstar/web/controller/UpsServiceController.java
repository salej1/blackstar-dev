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
import com.blackstar.model.OpenCustomer;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.UpsServiceDTO;
import com.blackstar.model.dto.UpsServicePolicyDTO;
import com.blackstar.services.interfaces.OpenCustomerService;
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
				  //si la operation es 4, el idObject es irrelevante (sin poliza)
		  		  if(operation==1)
		  		  {
		  			return "redirect:/plainService?operation=1&idObject=" + idObject;
		  		  }
		  		  else if( operation==2)
		  		  {
		  			  Integer idOrder = Integer.parseInt(idObject);
		  			  UpsServiceDTO upsService = service.getUpsService(idOrder);
		  			  Serviceorder serviceOrder = this.daoFactory.getServiceOrderDAO().getServiceOrderById(idOrder);
		  			  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(serviceOrder.getPolicyId());
	  				  if(policy != null && policy.getPolicyId() > 0){
	  					upsServicePolicyDTO = new UpsServicePolicyDTO(policy, serviceOrder, upsService );
	  					model.addAttribute("hasPolicy", true);
	  				  }
	  				  else if(serviceOrder.getOpenCustomerId() != null && serviceOrder.getOpenCustomerId() > 0){
	  					OpenCustomer oc = ocService.GetOpenCustomerById(serviceOrder.getOpenCustomerId());
	  					upsServicePolicyDTO = new UpsServicePolicyDTO(oc, serviceOrder, upsService );
	  					model.addAttribute("hasPolicy", false);
	  				  }
	  				  model.addAttribute("serviceOrder", upsServicePolicyDTO);
	  				  model.addAttribute("followUps", service.getFollows(idOrder));
	  				  model.addAttribute("mode", "detail");
		  		  }
		  		  else if(operation==3)
		  		  {
		  			  Policy policy  = this.daoFactory.getPolicyDAO().getPolicyBySerialNo(idObject);
	  				  upsServicePolicyDTO = new UpsServicePolicyDTO(policy);
					  upsServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber("U"));
					  upsServicePolicyDTO.setServiceStatusId("N");
					  upsServicePolicyDTO.setServiceTypeId("P");
	  				  model.addAttribute("serviceOrder", upsServicePolicyDTO);
	  			      model.addAttribute("serviceEmployees", udService.getStaffByGroupJson(Globals.GROUP_SERVICE));
	  				  model.addAttribute("mode", "new");
	  				  model.addAttribute("hasPolicy", true);
		  		  }
		  		  else if(operation == 4){
		  			  OpenCustomer cust = new OpenCustomer();
		  			  cust.setEquipmentTypeId("U");
	  				  upsServicePolicyDTO = new UpsServicePolicyDTO(cust);
					  upsServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber("U"));
					  upsServicePolicyDTO.setServiceStatusId("N");
					  upsServicePolicyDTO.setServiceTypeId("P");
	  				  model.addAttribute("serviceOrder", upsServicePolicyDTO);
	  			      model.addAttribute("serviceEmployees", udService.getStaffByGroupJson(Globals.GROUP_SERVICE));
	  				  model.addAttribute("mode", "new");
	  				  model.addAttribute("hasPolicy", false);
		  		  }
		  		  
		  		  model.addAttribute("serviceTypes", service.getServiceTypeList());
				  model.addAttribute("serviceStatuses", service.getServiceStatusList());
				  model.addAttribute("osAttachmentFolder", gdService.getAttachmentFolderId(upsServicePolicyDTO.getServiceOrderNumber()));
				  model.addAttribute("rootFolder", gdService.getRootFolderId());
				  model.addAttribute("accessToken", gdService.getAccessToken());
				  model.addAttribute("equipmentTypeList", service.getEquipmentTypeList());
				  model.addAttribute("checkOptions", this.getCheckOptions());
	  		  }
			  else
			  {
				  Logger.Log(LogLevel.WARNING, "UpsServiceController", "Parametros de navegacion nulos." , "" );
			  }
		  } 
		  catch (Exception e) 
		  {
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[0].toString(), e);
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
	    	int custId = 0;
	        boolean doCommit = false;
	        
			try{
				if(serviceOrder.getServiceOrderId() != null && serviceOrder.getServiceOrderId() > 0){
		    		// Actualizar orden de servicio
		    		Serviceorder servicioOrderSave = new Serviceorder();
		    		servicioOrderSave.setServiceOrderId(serviceOrder.getServiceOrderId());
		    		if(serviceOrder.getClosed() != null && serviceOrder.getServiceStatusId().equals("C")){
		    			servicioOrderSave.setAsignee(null);
		    		}
		    		servicioOrderSave.setClosed(serviceOrder.getClosed());
		    		servicioOrderSave.setIsWrong(serviceOrder.getIsWrong()?1:0);
		    		servicioOrderSave.setStatusId(serviceOrder.getServiceStatusId());
		    		servicioOrderSave.setHasPdf(serviceOrder.getHasPdf());
		    		
		    		service.updateServiceOrder(servicioOrderSave, "UpsServiceController", userSession.getUser().getUserEmail());
		    		idServicio = serviceOrder.getServiceOrderId();
		    	}
				else{
					if(serviceOrder.getPolicyId() == null || serviceOrder.getPolicyId() == 0){
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
			    		customer.setCreatedBy("UpsServiceController");
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
					
					idServicio = service.saveServiceOrder(servicioOrderSave, "UpsServiceController", userSession.getUser().getUserEmail());
					serviceOrder.setServiceOrderId(idServicio);
					doCommit = true;
				}
	    	
	    		if(serviceOrder.getUpsServiceId()==null && doCommit)
	    		{
	    			serviceOrder.setServiceOrderId(idServicio);
	    			//Crear orden de servicio de UpsService
	    			service.saveUpsService(new UpsServiceDTO(serviceOrder), "UpsServiceController", userSession.getUser().getUserName());
	    			commit(serviceOrder);
	    		}
			}
			catch (Exception e) 
			{
				Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[0].toString(), e);
				e.printStackTrace();
				model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
				throw e;
			}
	    	
	    	return "dashboard";
	    }
	    
	     private void commit(UpsServicePolicyDTO serviceOrder) throws Exception {
	    	byte [] report = rpService.getUPSReport(serviceOrder);
	    	saveReport(serviceOrder.getServiceOrderId(), report);
	    	sendNotification(serviceOrder.getReceivedByEmail(), report, serviceOrder.getServiceOrderNumber());
	      }
	      
	      private void saveReport(Integer id, byte[] report) throws Exception {
	      	String parentId = gdService.getReportsFolderId(id);
	      	gdService.insertFileFromStream(id, "application/pdf", "ServiceOrder.pdf", parentId, report);
	      }
	      
	      private void sendNotification(String to, byte [] report, String serviceNumber){
	    	  to = to + "," + Globals.GPOSAC_CALL_CENTER_GROUP;
	      	gmService.sendEmail(to, "Reporte de servicio de UPS", "Reporte de servicio de UPS", serviceNumber + ".pdf", report);
	      }
}
