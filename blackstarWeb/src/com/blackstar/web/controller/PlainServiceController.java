package com.blackstar.web.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.common.Utils;
import com.blackstar.db.DAOFactory;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Equipmenttype;
import com.blackstar.model.OpenCustomer;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.Ticket;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.EmployeeDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.PlainServicePolicyDTO;
import com.blackstar.services.interfaces.OpenCustomerService;
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
	  
	  public void setOcService(OpenCustomerService ocService) {
		this.ocService = ocService;
	}

	@RequestMapping(value= "/show.do", method = RequestMethod.GET)
	  public String  plainservice(@RequestParam(required = true) Integer operation, @RequestParam(required = true) String idObject,
			  @RequestParam(required = false) String soNumber, ModelMap model,
			  @ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession)
	  {
		  PlainServicePolicyDTO plainServicePolicyDTO =null;
		  try
		  {
			  if(operation!= null && idObject!=null)
			  {
				  //si la operation es 1, el idObject es el id de un ticket
				  //si la operation es 2, el idObject es el id de un servicio
				  //si la operation es 3, el idObject es el no de serie del equipo
				  //si la operation es 4, el idObject es es irrelevante (sin poliza)

		  		  if(operation==1)
		  		  {
		  			  Integer idTicket = Integer.parseInt(idObject);
		  			  Ticket ticket = daoFactory.getTicketDAO().getTicketById(idTicket);
	  				  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(ticket.getPolicyId());
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				  plainServicePolicyDTO = new PlainServicePolicyDTO(policy, equipType.getEquipmentType());
	  				  plainServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber());  
	  				  plainServicePolicyDTO.setServiceStatusId("N");
	  				  plainServicePolicyDTO.setServiceTypeId("C");
	  				  plainServicePolicyDTO.setTicketNumber(ticket.getTicketNumber());
	  				  plainServicePolicyDTO.setTicketId(idTicket);
	  				  model.addAttribute("serviceOrder", plainServicePolicyDTO);
	  				  model.addAttribute("serviceEmployees", udService.getStaffByGroupJson(Globals.GROUP_SERVICE));
	  				  model.addAttribute("mode", "new");
	  				  model.addAttribute("hasPolicy", true);
		  		  }
		  		  else if( operation==2)
		  		  {
		  			  Integer idOrderService = Integer.parseInt(idObject);
		  			  PlainServiceDTO plainServiceDTO = service.getPlainService(idOrderService);
	  				  if(plainServiceDTO == null){
	  					  plainServiceDTO = new PlainServiceDTO();
	  					  plainServiceDTO.setServiceOrderId(idOrderService);
	  				  }
		  			  Serviceorder serviceOrder = this.daoFactory.getServiceOrderDAO().getServiceOrderById(idOrderService);
		  			  Policy policy = this.daoFactory.getPolicyDAO().getPolicyById(serviceOrder.getPolicyId());
		  			  Equipmenttype equipType;
		  			  if(policy != null && policy.getPolicyId() > 0){
		  				  equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
		  				  plainServicePolicyDTO = new PlainServicePolicyDTO(policy, equipType.getEquipmentType(), serviceOrder,  plainServiceDTO);
		  				  model.addAttribute("hasPolicy", true);
		  			  }
		  			  else if(serviceOrder.getOpenCustomerId() > 0){
		  				  OpenCustomer oc = ocService.GetOpenCustomerById(serviceOrder.getOpenCustomerId());
		  				  plainServicePolicyDTO = new PlainServicePolicyDTO(oc, serviceOrder, plainServiceDTO);
		  				  model.addAttribute("hasPolicy", false);
		  			  }
	  				  
	  				  model.addAttribute("serviceOrder", plainServicePolicyDTO);
	  				  model.addAttribute("followUps", service.getFollows(idOrderService));
	  				  model.addAttribute("mode", "detail");
		  		  }
		  		  else if(operation==3)
		  		  {
		  			  Policy policy  = this.daoFactory.getPolicyDAO().getPolicyBySerialNo(idObject);
	  				  Equipmenttype equipType = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
	  				  plainServicePolicyDTO = new PlainServicePolicyDTO(policy, equipType.getEquipmentType());
	  				  if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_SERVICE) != null){
	  					plainServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber("O"));
	  				  }
	  				  else
	  				  {
	  					if(!soNumber.equals("")){
	  						try{
	  							OrderserviceDTO checkSo = service.getServiceOrderByIdOrNumber(0, soNumber);
	  							if(checkSo != null){
		  							throw new Exception(String.format("La orden de servicio %s ya existe", soNumber));
		  						}
	  						}
	  						catch(EmptyResultDataAccessException ex){
	  							// Todo bien, la orden de servicio no existe
	  						}
	  						plainServicePolicyDTO.setServiceOrderNumber(soNumber);
	  					}
	  					else{
	  						throw new Exception("Numero de folio no valido");
	  					}
	  				  }
	  				  plainServicePolicyDTO.setServiceStatusId("N");
	  				  plainServicePolicyDTO.setServiceTypeId("C");
	  				  plainServicePolicyDTO.setTicketNumber("NA");
	  				  model.addAttribute("serviceOrder", plainServicePolicyDTO);
	  				  model.addAttribute("serviceEmployees", udService.getStaffByGroupJson(Globals.GROUP_SERVICE));
	  				  model.addAttribute("mode", "new");
	  				  model.addAttribute("hasPolicy", true);
		  		  }
		  		  else if(operation == 4){
		  			  OpenCustomer cust = new OpenCustomer();
		  			  cust.setEquipmentTypeId("A");
		  			  plainServicePolicyDTO = new PlainServicePolicyDTO(cust);
		  			  if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_SERVICE) != null){
		  					plainServicePolicyDTO.setServiceOrderNumber(service.getNewServiceNumber());
		  			  }
		  			  else
	  				  {
		  				if(!soNumber.equals("")){
	  						plainServicePolicyDTO.setServiceOrderNumber(soNumber);
	  					}
	  					else{
	  						throw new Exception("Numero de folio no valido");
	  					}
	  				  }
		  			  plainServicePolicyDTO.setServiceStatusId("N");
		  			  plainServicePolicyDTO.setServiceTypeId("P");
		  			  plainServicePolicyDTO.setTicketNumber("NA");
	  				  model.addAttribute("serviceOrder", plainServicePolicyDTO);
	  				  model.addAttribute("serviceEmployees", udService.getStaffByGroupJson(Globals.GROUP_SERVICE));
	  				  model.addAttribute("mode", "new");
	  				  model.addAttribute("hasPolicy", false);
		  		  }
		  		  
		  		  model.addAttribute("serviceTypes", service.getServiceTypeList());
				  model.addAttribute("serviceStatuses", service.getServiceStatusList());
				  model.addAttribute("osAttachmentFolder", gdService.getAttachmentFolderId(plainServicePolicyDTO.getServiceOrderNumber()));
				  model.addAttribute("rootFolder", gdService.getRootFolderId());
				  model.addAttribute("accessToken", gdService.getAccessToken());
				  model.addAttribute("equipmentTypeList", service.getEquipmentTypeList());
				  List<Ticket> tickets = daoFactory.getTicketDAO().selectAllTicket();
  				  model.addAttribute("ticketList", tickets);
	  		  }
			  else
			  {
				  Logger.Log(LogLevel.WARNING, "PlainServiceController", "Parametros de navegacion nulos." , "" );
			  }
		  } 
		  catch (Exception e) 
		  {
			  	 e.printStackTrace();
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
	    	int idServicio = 0;
	    	int custId = 0;
	    	
	    	try{
	    		// Update?
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
		    		if(serviceOrder.getLoadedOSFileId() == null || serviceOrder.getLoadedOSFileId().equals("")){
		    			servicioOrderSave.setHasPdf(0);
		    		}
		    		else{
		    			servicioOrderSave.setHasPdf(1);
		    		}
		    		service.updateServiceOrder(servicioOrderSave, "PlainServiceController", userSession.getUser().getUserEmail());
		    		idServicio = serviceOrder.getServiceOrderId();
	    		}
	    		else{
	    			if(serviceOrder.getPolicyId() == null || serviceOrder.getPolicyId() == 0){
	    				// Guardando el cliente capturado
			    		OpenCustomer customer = new OpenCustomer();
			    		customer.setCustomerName(serviceOrder.getCustomer());
			    		customer.setContactEmail(serviceOrder.getFinalUser());
			    		customer.setEquipmentTypeId(serviceOrder.getEquipmentTypeId().toString());
			    		customer.setBrand(serviceOrder.getBrand());
			    		customer.setModel(serviceOrder.getModel());
			    		customer.setSerialNumber(serviceOrder.getSerialNumber());
			    		customer.setCapacity(serviceOrder.getCapacity());
			    		customer.setAddress(serviceOrder.getEquipmentAddress());
			    		customer.setContactName(serviceOrder.getContactName());
			    		customer.setPhone(serviceOrder.getContactPhone());
			    		customer.setProject(serviceOrder.getProject());
			    		customer.setOfficeId(serviceOrder.getOfficeId().length()>0?serviceOrder.getOfficeId().substring(0,1):null);
			    		customer.setCreated(new Date());
			    		customer.setCreatedBy("PlainServiceController");
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
		    		if(serviceOrder.getLoadedOSFileId() == null || serviceOrder.getLoadedOSFileId().equals("")){
		    			servicioOrderSave.setHasPdf(0);
		    		}
		    		else{
		    			servicioOrderSave.setHasPdf(1);
		    		}
					servicioOrderSave.setPolicyId(serviceOrder.getPolicyId());
					servicioOrderSave.setResponsible(serviceOrder.getResponsible());
					servicioOrderSave.setTicketId(serviceOrder.getTicketId());
					if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_SERVICE) != null){
						servicioOrderSave.setHasPdf(1);
					}
					idServicio = service.saveServiceOrder(servicioOrderSave, "PlainServiceController", userSession.getUser().getUserEmail());
					serviceOrder.setServiceOrderId(idServicio);
					
	                //Crear orden de servicio Plain
	                service.savePlainService(new PlainServiceDTO(serviceOrder), "PlainServiceController", userSession.getUser().getUserEmail());
	    		}
	    		
		    	if(serviceOrder.getPlainServiceId()==null && userSession.getUser().getBelongsToGroup().get(Globals.GROUP_SERVICE) != null)
                {
		    		commit(serviceOrder);
                }
		    	else{
		    		if(idServicio > 0 && serviceOrder.getLoadedOSFileId() != null && !serviceOrder.getLoadedOSFileId().equals("")){
		    			importReport(serviceOrder.getLoadedOSFileId(), idServicio);
		    		}
		    	}
	    	}
	    	catch(Exception e){
	    		 Logger.Log(LogLevel.FATAL, e.getStackTrace()[0].toString(), e);
				 model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
				 return "error";
	    	}
	    	return "redirect:/dashboard/show.do";
	    }
	    
	    private void saveReport(Integer id, byte[] report) throws Exception {
	    	String parentId = gdService.getReportsFolderId(id);
	    	gdService.insertFileFromStream(id, "application/pdf", "ServiceOrder.pdf", parentId, report);
	    }
	    
	    private void importReport(String fileId, Integer serviceOrderId) throws Exception {
	    	gdService.LoadOSFile(fileId, serviceOrderId);
	    }
	    
	    private void sendNotification(String to, byte [] report){
	    	gmService.sendEmail(to, "Orden de Servicio", "Orden de Servicio", "ServiceOrder.pdf", report);
	    }
	    
	    private void callCenterLink(PlainServicePolicyDTO serviceOrder){
	    	String who = serviceOrder.getResponsible().split(";")[0];
	    	StringBuilder asignee = new StringBuilder();
	    	String message = "Orden de servicio creada";
	    	
	    	List<EmployeeDTO> receivers = udService.getStaff(Globals.GROUP_CALL_CENTER);
	    	
	    	for(EmployeeDTO emp : receivers){
	    		asignee.append(emp.getEmail() + ";");
	    	}
	    	
	    	AddFollowUpController.AssignServiceOrder(serviceOrder.getServiceOrderId(), Utils.noCommas(asignee.toString()), who, message);
	    }
	    
	    private void commit(PlainServicePolicyDTO serviceOrder) throws Exception {
	      byte [] report = rpService.getGeneralReport(serviceOrder);
	      saveReport(serviceOrder.getServiceOrderId(), report);
	      sendNotification(serviceOrder.getReceivedByEmail(), report);
	      // enviar email a Call Center en caso de tener ticket asociado
	      if(serviceOrder.getTicketNumber() != null && !serviceOrder.getTicketNumber().equals("")){
	    	  callCenterLink(serviceOrder);
	      }
	    }
	    
	    @RequestMapping(value = "/loadOs.do", method = RequestMethod.POST)
	    public String loadOs( 
	    		@ModelAttribute("serviceOrder") PlainServicePolicyDTO serviceOrder,
	    		@ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession,
              ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	    {
	    	return "";
	    }
	}
