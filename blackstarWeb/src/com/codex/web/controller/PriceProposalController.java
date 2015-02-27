package com.codex.web.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.model.User;
import com.blackstar.model.UserSession;
import com.blackstar.web.AbstractController;
import com.codex.service.PriceProposalService;
import com.codex.service.impl.DashboardServiceImpl;

@Controller
@RequestMapping("/codex/priceProposal")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class PriceProposalController extends AbstractController{

	private PriceProposalService service;
	private DashboardServiceImpl dService;

	public void setService(PriceProposalService service) {
		this.service = service;
	}

	public DashboardServiceImpl getdService() {
		return dService;
	}

	public void setdService(DashboardServiceImpl dService) {
		this.dService = dService;
	}

	@RequestMapping(value = "/showProposals.do") 
	public String showList(ModelMap model, HttpServletRequest request ){
		User user = null;
		try {

			model.addAttribute("cotProjects", dService.getProjectsByStatusJson(4));

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			System.out.println("Error =>" + e);
			return "error";
		}

		return "codex/proposals";
	}
	
	@RequestMapping(value = "/showSold.do") 
	public String showSold(ModelMap model, HttpServletRequest request ){
		User user = null;
		try {

			model.addAttribute("soldProjects", dService.getProjectsByStatusJson(5));

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			System.out.println("Error =>" + e);
			return "error";
		}

		return "codex/sold";
	}

}
