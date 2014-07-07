package com.codex.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
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
	model.addAttribute("project", new ProjectVO());
	model.addAttribute("entryTypes", service.getAllEntryTypes());
	model.addAttribute("entryItemTypes", service.getAllEntryItemTypes());
	model.addAttribute("currencyTypes", service.getAllCurrencyTypes());
	model.addAttribute("taxesTypes", service.getAllTaxesTypes());
	
	model.addAttribute("staff", udService.getStaff());
	   
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
	
}
