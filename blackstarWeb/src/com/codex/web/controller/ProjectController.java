package com.codex.web.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.User;
import com.blackstar.model.UserSession;
import com.blackstar.web.AbstractController;
import com.codex.model.dto.CostCenterDTO;
import com.codex.model.dto.CstDTO;
import com.codex.service.ClientService;
import com.codex.service.CstService;
import com.codex.service.ExchangeRateService;
import com.codex.service.ProjectService;
import com.codex.vo.ClientVO;
import com.codex.vo.ProjectVO;

@Controller
@RequestMapping("/codex/project")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class ProjectController extends AbstractController {

	private ProjectService service;
	private ClientService cService = null;
	private ExchangeRateService xrService;
	private CstService cstService;
	
	public void setService(ProjectService service) {
		this.service = service;
	}

	public void setcService(ClientService cService) {
		this.cService = cService;
	}

	public void setXrService(ExchangeRateService xrService) {
		this.xrService = xrService;
	}
	
  public void setCstService(CstService cstService) {
		this.cstService = cstService;
	}

@RequestMapping(value = "/showList.do") 
  public String showList(ModelMap model, HttpServletRequest request,
		  @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession ){
	User user = null;
	try {
		 CstDTO cstId =  cstService.getCstByEmail(userSession.getUser().getUserEmail());
		 
		 if(cstId != null){
			 model.addAttribute("projects", service.getAllProjectsByUsrJson(cstId.getCstId()));
		 }
		 
	} catch (Exception e) {
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
    return "codex/projectList";
  }
  
  @RequestMapping(value = "/edit.do")
  public String edit(ModelMap model, @RequestParam(required = true) Integer projectId,
		  @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	ProjectVO project = null;
	try {
		 CstDTO cstId =  cstService.getCstByEmail(userSession.getUser().getUserEmail());
		 project = service.getProjectDetail(projectId, cstId);
		
	     model.addAttribute("project", project);
	     model.addAttribute("entryTypes", service.getAllEntryTypes());
	     model.addAttribute("entryItemTypes", service.getAllEntryItemTypes());
	     model.addAttribute("currencyTypes", service.getAllCurrencyTypes());
	     model.addAttribute("taxesTypes", service.getAllTaxesTypes());
		 model.addAttribute("deliverableTypes", service.getDeliverableTypes());
		 model.addAttribute("paymentTypes", service.getAllPaymentTypes());
		 model.addAttribute("staff", udService.getStaff());
		 model.addAttribute("accessToken", gdService.getAccessToken());

		 Boolean enableEdition = false;
		 Boolean enableFallback = false;
		 if(project.getStatusId() == 1){
			 if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_SALES_MANAGER) != null || project.getCstEmail().equals(userSession.getUser().getUserEmail())){
				 enableEdition = true;
			 }
		 }
		 else if(project.getStatusId() > 1 && project.getStatusId() <= 4){
			 if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_SALES_MANAGER) != null && userSession.getUser().getBelongsToGroup().get(Globals.GROUP_SALES_MANAGER) == true){
				 enableEdition = true;
			 }
			 if(project.getCstEmail().equals(userSession.getUser().getUserEmail())){
				 enableFallback = true;
			 }
		 }
		 
		 model.addAttribute("enableEdition", enableEdition);
		 model.addAttribute("enableFallback", enableFallback);
		 model.addAttribute("isUpdate", true);
		 model.addAttribute("clients", cService.getAllClients());
		 model.addAttribute("osAttachmentFolder", gdService.getAttachmentFolderId(project.getProjectNumber()));
		 model.addAttribute("deliverables", service.getDeliverables(projectId));
		 model.addAttribute("costCenterList", getCostCenterList(project.getProjectNumber()));
		 model.addAttribute("followUps", service.getFollowUps(projectId));
		 model.addAttribute("incotermList", service.getIncotermList());
		 model.addAttribute("priceListJson", service.getPriceList());
		 model.addAttribute("userCanAuth", userSession.getUser().getBelongsToGroup().get(Globals.GROUP_SALES_MANAGER) != null);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}   
		return "codex/projectDetail";
  }
  
  @RequestMapping(value = "/create.do")
  public String create(ModelMap model, @RequestParam(required = false) Integer clientId,
		  @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	ProjectVO project;
	ClientVO client= null;
	Integer projectNum = null;
	String officeId = null;
	try {
		
		 officeId = service.getCSTOffice(userSession.getUser().getUserEmail());
		 projectNum = service.getNewProjectId(officeId);
		 CstDTO cst = cstService.getCstByEmail(userSession.getUser().getUserEmail());
	     if(cst == null){
	    	 throw new Exception(String.format("El usuario %s no esta registrado como CST", userSession.getUser().getUserName()));
	     }
		 
	     project = new ProjectVO(cst);
		 
		 if(clientId != null && ((client = cService.getClientById(clientId)) != null)){
			 project.setClientId(client.getId());
			 if(client.getCity() != null && !client.getCity().equals("") && client.getState() != null && !client.getState().equals("") ){
				 project.setLocation(client.getCity() + ", " + client.getState());
			 }
			 project.setContactName(client.getContactName());
		 }
	     project.setId(0);
	     project.setStatusId(1);
	     project.setStatusDescription("Nuevo");
	     project.setProjectNumber("C" + officeId + projectNum);
	     project.setCostCenter(project.getProjectNumber());
	     project.setCreated(Globals.getLocalTime());
	     project.setPaymentTypeId(1);
	     project.setChangeType(xrService.getExchangeRate());
	     
	     model.addAttribute("project", project);
	     model.addAttribute("entryTypes", service.getAllEntryTypes());
	     model.addAttribute("entryItemTypes", service.getAllEntryItemTypes());
	     model.addAttribute("currencyTypes", service.getAllCurrencyTypes());
	     model.addAttribute("taxesTypes", service.getAllTaxesTypes());
	     model.addAttribute("deliverableTypes", service.getDeliverableTypes());
	     model.addAttribute("paymentTypes", service.getAllPaymentTypes());
	     model.addAttribute("staff", udService.getStaff());
	     model.addAttribute("enableEdition", true);
	     model.addAttribute("isUpdate", false);
	     model.addAttribute("clients", cService.getAllClients());
	     model.addAttribute("costCenterList", getCostCenterList(project.getProjectNumber()));
	     model.addAttribute("incotermList", service.getIncotermList());
	     model.addAttribute("priceListJson", service.getPriceList());
	     
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		System.out.println("CodexCreateProjectError=> " + e);
		e.printStackTrace();
		return "error";
	}   
	return "codex/projectDetail";
  }
  
  @RequestMapping(value = "/getDeliverables.do")
  public String getDeliverables(ModelMap model
		                   , @RequestParam(required = true) Integer projectId) {
	model.addAttribute("deliverables", service.getDeliverables(projectId));
	return "codex/_fileTraceTable";
  }
  
  @RequestMapping(value = "/addFollow.do", method = RequestMethod.GET)
  public String addFollow(@RequestParam(required = true) Integer projectId
		                , @RequestParam(required = true) Integer userId
		                , @RequestParam(required = true) String comment
		                , @RequestParam(required = true) Integer userToAssign
				                                    , ModelMap model) {
	boolean sendNotification = true;
	try {
		service.addFollow(projectId, userId, userToAssign, comment);
		if(userToAssign != null && userToAssign > 0){
			service.addProjectTeam(projectId, 1, userToAssign);
		}

		if(sendNotification){
			service.sendNotification(userId, userToAssign, projectId, comment);
		}
		model.addAttribute("followUps", service.getFollowUps(projectId));
	} catch (Exception e) {
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		System.out.println("CodexAddFollowError=> " + e);
		return "error";
	}
	return "codex/_follow";
  }
  
  @RequestMapping(value = "/getReferenceTypes.do", produces="application/json")
  public @ResponseBody String getReferenceTypes(@RequestParam(required = true) Integer itemTypeId
		                                                                      , ModelMap model) {
	  return service.getReferenceTypes(itemTypeId);
  }
  
  @RequestMapping(value = "/addDeliverableTrace.do", method = RequestMethod.GET)
  public ResponseEntity<HttpStatus> addDeliverableTrace(@RequestParam(required = true) Integer projectId
		                        , @RequestParam(required = true) Integer deliverableTypeId
		                        , @RequestParam(required = true) Integer userId
				                                            , ModelMap model) {
	try {
		 if(deliverableTypeId > 0){
		   service.addDeliverableTrace(projectId, deliverableTypeId, userId);
		 }
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return new ResponseEntity<HttpStatus>(HttpStatus.BAD_REQUEST);
	}
	return new ResponseEntity<HttpStatus>(HttpStatus.OK);
  }
  
  @RequestMapping(value = "/insert.do") 
  public String insert(ModelMap model, HttpServletRequest request 
		       ,  @ModelAttribute("project") ProjectVO project) {
	UserSession userSession = null;
	try {
		userSession = (UserSession) request.getSession().getAttribute(Globals
				                                         .SESSION_KEY_PARAM);
	     service.insertProject(project, userSession.getUser());
	} catch (Exception e) {
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		System.out.println("Error =>" + e);
		return "error";
	}
    return "redirect:/codex/project/edit.do?projectId=" + project.getId();
  }
  
  @RequestMapping(value = "/update.do") 
  public String update(ModelMap model, HttpServletRequest request 
		       ,   @ModelAttribute("project") ProjectVO project,
	            @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
    User user = null;
	try {
		 user = ((UserSession) request.getSession().getAttribute(Globals
                                         .SESSION_KEY_PARAM)).getUser();
		 if(project.getStatusId() == 1){
			service.updateProject(project, user);
		 } else {
	        service.updateEntries(project);
		 }
	} catch (Exception e) {
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		System.out.println("Error =>" + e);
		return "error";
	}
	return "redirect:/codex/project/edit.do?projectId=" + project.getId();
  }
  
  @RequestMapping(value = "/advanceStatus.do") 
  public String advanceStatus(ModelMap model, HttpServletRequest request 
		            , @RequestParam(required = true) Integer projectId,
		            @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	  ProjectVO project = null;
	  	  
	  try {
		    project = service.getProjectDetail(projectId, cstService.getCstByEmail(userSession.getUser().getUserEmail()));
		    if(project == null){
		    	throw new Exception("No fue posible cargar el proyecto " + projectId.toString());
		    }
	        service.advanceStatus(project);
	  } catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			return "error";
	}
	return showList(model, request, userSession);
  }
  
  @RequestMapping(value = "/fallbackStatus.do") 
  public String fallbackStatus(ModelMap model, HttpServletRequest request 
		            , @RequestParam(required = true) Integer projectId,
		            @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	  ProjectVO project = null;
	  try {
		    project = service.getProjectDetail(projectId, cstService.getCstByEmail(userSession.getUser().getUserEmail()));
	        service.fallbackStatus(project);
	  } catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			return "error";
	}
	return edit(model, projectId, userSession);
  }
	
  private List<CostCenterDTO> getCostCenterList(String projectNumber){
	  List<CostCenterDTO> ccList = service.getCostCenterList();
	  
	  if(ccList == null){
		  ccList = new ArrayList<CostCenterDTO>();
	  }
	  ccList.add(0, new CostCenterDTO(0, projectNumber));
	  
	  return ccList;
  }
  
}
