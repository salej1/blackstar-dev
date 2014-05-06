package com.blackstar.web.controller;

import java.util.Date;

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
import com.blackstar.model.dto.IssueDTO;
import com.blackstar.services.interfaces.IssueService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/issues")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class IssueController extends AbstractController{
	private IssueService service;

	public void setService(IssueService service) {
		this.service = service;
	}
	
	@RequestMapping(value = "/show.do", method = RequestMethod.GET)
	public String show(ModelMap model, @RequestParam(required = false)Integer issueId) {
			IssueDTO issue;
			
			try {
				// es nuevo o es consulta?
				if(issueId != null && issueId > 0){
					issue = service.getIssueById("I", issueId);
					model.addAttribute("mode", "detail");
				}
				else{
					issue = new IssueDTO();
					issue.setReferenceNumber(service.getNewIssueNumber());
					issue.setReferenceTypeId("I");
					model.addAttribute("mode", "new");
				}
				
				model.addAttribute("issue", issue);
				model.addAttribute("issueStatusList", service.getIssueStatusList());
				model.addAttribute("followUps", issue.getFollowUpList());
				
			} catch (Exception ex) {
				Logger.Log(LogLevel.ERROR,
						Thread.currentThread().getStackTrace()[1].toString(), ex);
				model.addAttribute("errorDetails", ex.getMessage());
				return "error";
			}
			return "issueDetail";
	}

	@RequestMapping(value = "/save.do", method = RequestMethod.POST)
	public String save(ModelMap model, @ModelAttribute("issue") IssueDTO issue, 
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession ) {
		// init
		
		try {
			// Guardar el issue
			if(issue.getReferenceStatusId().equals("R")){
				issue.setReferenceAsignee(issue.getCreatedByUsr());
				service.addFollowUp(issue.getReferenceId(), new Date(), userSession.getUser().getUserEmail(), issue.getCreatedByUsr(), issue.getResolution());
			}
			
			if(issue.getReferenceStatusId().equals("C")){
				issue.setReferenceAsignee(null);
			}
			
			Integer issueId = service.saveIssue(issue, userSession.getUser().getUserEmail(), "IssueController");
			
			if(issueId > 0 && issue.getReferenceAsignee() != null){
				// Logica de asignacion
				AddFollowUpController.AssignIssue(issueId, issue.getReferenceAsignee(), userSession.getUser().getUserEmail());
			}
		} catch (Exception ex) {
			Logger.Log(LogLevel.ERROR,
					Thread.currentThread().getStackTrace()[1].toString(), ex);
			model.addAttribute("errorDetails", ex.getMessage());
			return "error";
		}
		
		return "redirect:/dashboard/show.do";
	}

	@RequestMapping(value = "/getUserIssuesJson.do", method = RequestMethod.GET)
	public @ResponseBody String getUserIssuesJson(@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession ) {
			String retVal;
			try {
				retVal = service.getUserIssues(userSession.getUser().getUserEmail()).toString();
			} catch (Exception ex) {
				Logger.Log(LogLevel.ERROR,
						Thread.currentThread().getStackTrace()[1].toString(), ex);
				ex.printStackTrace();
				return "error";
			}
			return retVal;
	}
	
	@RequestMapping(value = "/getUserWatchingIssuesJson.do", method = RequestMethod.GET)
	public @ResponseBody String getUserWatchingIssuesJson(@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession ) {
			String retVal;
			try {
				retVal = service.getUserWatchingIssues(userSession.getUser().getUserEmail()).toString();
			} catch (Exception ex) {
				Logger.Log(LogLevel.ERROR,
						Thread.currentThread().getStackTrace()[1].toString(), ex);
				ex.printStackTrace();
				return "error";
			}
			return retVal;
	}

}
