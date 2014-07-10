package com.codex.web.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.web.AbstractController;
import com.codex.service.ProjectService;
import com.codex.vo.ProjectVO;


@Controller
@RequestMapping("/codex/project")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class ProjectController extends AbstractController {

  private ProjectService service;

  public void setService(ProjectService service) {
	this.service = service;
  }
	
  @RequestMapping(value = "/create.do")
  public String create(ModelMap model){
	ProjectVO project = new ProjectVO();
	Integer projectId = null;
	try {
		 projectId = service.getNewProjectId();
	     project.setId(projectId);
	     project.setStatusId(1);
	     project.setProjectNumber("CQ" + projectId);
	     model.addAttribute("project", project);
	     model.addAttribute("entryTypes", service.getAllEntryTypes());
	     model.addAttribute("entryItemTypes", service.getAllEntryItemTypes());
	     model.addAttribute("currencyTypes", service.getAllCurrencyTypes());
	     model.addAttribute("taxesTypes", service.getAllTaxesTypes());
	     model.addAttribute("deliverableTypes", service.getDeliverableTypes());
	     model.addAttribute("staff", udService.getStaff());
	     model.addAttribute("accessToken", gdService.getAccessToken());
	     model.addAttribute("enableEdition", false);
	     model.addAttribute("osAttachmentFolder", gdService
	    		           .getAttachmentFolderId(project.getProjectNumber()));
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		return "error";
	}   
	return "codex/projectDetail";
  }
  
  @RequestMapping(value = "/addFollow.do", method = RequestMethod.GET)
  public String addFollow(@RequestParam(required = true) Integer projectId
		                , @RequestParam(required = true) Integer userId
		                , @RequestParam(required = true) String comment
		                , @RequestParam(required = true) Integer userToAssign
				                                    , ModelMap model) {
	boolean sendNotification = true;
	try {
		//Comment
		if(userToAssign == -2){
			// Nada no se cambia el asignatario
			sendNotification = false;
		} else if (userToAssign == -3){ //Response
			userToAssign = service.getResponseUser(userId).get(0)
					                       .getBlackstarUserId();
		}
		service.addFollow(userId, userId, comment);
		if(userToAssign != null && userToAssign > 0){
			service.addProjectTeam(userId, 1, userToAssign);
		}

		if(sendNotification){
			service.sendNotification(userId, userToAssign, userId, comment);
		}
		model.addAttribute("followUps", service.getFollowUps(userId));
	} catch (Exception e) {
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "codex/_ticketFollow";
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
	
}
