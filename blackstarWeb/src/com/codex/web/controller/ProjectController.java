package com.codex.web.controller;

import java.util.Date;

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
import com.blackstar.model.UserSession;
import com.blackstar.web.AbstractController;
import com.codex.service.ClientService;
import com.codex.service.ProjectService;
import com.codex.vo.ClientVO;
import com.codex.vo.ProjectVO;


@Controller
@RequestMapping("/codex/project")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class ProjectController extends AbstractController {

  private ProjectService service;
  private ClientService cService = null;

  public void setService(ProjectService service) {
	this.service = service;
  }
  
  public void setcService(ClientService cService) {
	this.cService = cService;
  }
	
  @RequestMapping(value = "/showList.do") 
  public String showList(ModelMap model){
	try {
		 model.addAttribute("projects", service.getAllProjectsJson());
	} catch (Exception e) {
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
    return "codex/projectList";
  }
  
  @RequestMapping(value = "/edit.do")
  public String edit(ModelMap model, @RequestParam(required = true) Integer projectId){
	ProjectVO project = null;
	try {
		 project = service.getProjectDetail(projectId);
	     model.addAttribute("project", project);
	     model.addAttribute("entryTypes", service.getAllEntryTypes());
	     model.addAttribute("entryItemTypes", service.getAllEntryItemTypes());
	     model.addAttribute("currencyTypes", service.getAllCurrencyTypes());
	     model.addAttribute("taxesTypes", service.getAllTaxesTypes());
		 model.addAttribute("deliverableTypes", service.getDeliverableTypes());
		 model.addAttribute("paymentTypes", service.getAllPaymentTypes());
		 model.addAttribute("staff", udService.getStaff());
		 model.addAttribute("accessToken", gdService.getAccessToken());
		 model.addAttribute("enableEdition", true);
		 model.addAttribute("clients", cService.getAllClients());
		 model.addAttribute("osAttachmentFolder", gdService
		    		           .getAttachmentFolderId(project.getProjectNumber()));
		 model.addAttribute("deliverables", service.getDeliverables(projectId));
		 model.addAttribute("followUps", service.getFollowUps(projectId));
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}   
		return "codex/projectDetail";
  }
  
  @RequestMapping(value = "/create.do")
  public String create(ModelMap model, @RequestParam(required = false) Integer clientId){
	ProjectVO project = new ProjectVO();
	ClientVO client= null;
	Integer projectId = null;
	try {
		 projectId = service.getNewProjectId();
		 if(clientId != null && ((client = cService.getClientById(clientId)) != null)){
			 project.setClientId(client.getId());
			 project.setLocation(client.getState());
			 project.setContactName(client.getContactName());
		 }
	     project.setId(projectId);
	     project.setStatusId(1);
	     project.setStatusDescription("Nuevo");
	     project.setProjectNumber("CQ" + projectId);
	     project.setCreated(new Date());
	     model.addAttribute("project", project);
	     model.addAttribute("entryTypes", service.getAllEntryTypes());
	     model.addAttribute("entryItemTypes", service.getAllEntryItemTypes());
	     model.addAttribute("currencyTypes", service.getAllCurrencyTypes());
	     model.addAttribute("taxesTypes", service.getAllTaxesTypes());
	     model.addAttribute("deliverableTypes", service.getDeliverableTypes());
	     model.addAttribute("paymentTypes", service.getAllPaymentTypes());
	     model.addAttribute("staff", udService.getStaff());
	     model.addAttribute("enableEdition", false);
	     model.addAttribute("clients", cService.getAllClients());
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
    return showList(model);
  }
  
  @RequestMapping(value = "/update.do") 
  public String update(ModelMap model,   @RequestParam(required = true) Integer projectId
		                              ,  @RequestParam(required = true) String strEntries){
	  ProjectVO project = null;
		try {
			 project = service.getProjectDetail(projectId);
			 project.setStrEntries(strEntries);
	         service.updateEntries(project);
	} catch (Exception e) {
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		System.out.println("Error =>" + e);
		return "error";
	}
    return showList(model);
  }
  
  @RequestMapping(value = "/advanceStatus.do") 
  public String advanceStatus(ModelMap model,  @RequestParam(required = true) Integer projectId){
	  ProjectVO project = null;
	  try {
		    project = service.getProjectDetail(projectId);
	        service.advanceStatus(project);
	  } catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			return "error";
	}
	return showList(model);
  }
	
}
