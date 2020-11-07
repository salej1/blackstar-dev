package com.blackstar.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.model.Customer;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.CustomerDTO;
import com.blackstar.services.interfaces.CustomerService;
import com.blackstar.services.interfaces.WarrantProjectService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/requsition")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class RequisitionController extends AbstractController {
	
	private WarrantProjectService warrantProjectService;
	
	public void setWarrantProjectService(WarrantProjectService warrantProjectService)
	{
		this.warrantProjectService = warrantProjectService;
	}
	
	@RequestMapping(value = "/show.do", method = RequestMethod.GET)
	public String show(ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	{
		model.addAttribute("warrantProjectList", warrantProjectService.getWarrantProjectList());
		return "requisitions";
	}
}
