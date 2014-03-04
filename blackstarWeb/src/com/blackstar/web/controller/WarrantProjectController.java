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
import com.blackstar.model.UserSession;
import com.blackstar.model.WarrantProject;
import com.blackstar.model.dto.WarrantProjectDTO;
import com.blackstar.services.interfaces.WarrantProjectService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/warrantProject")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class WarrantProjectController extends AbstractController 
{
	private WarrantProjectService warrantProjectService;

	public void setWarrantProjectService(WarrantProjectService warrantProjectService)
	{
		this.warrantProjectService = warrantProjectService;
	}
	
	@RequestMapping(value = "/add.do", method = RequestMethod.GET)
	public String add(@ModelAttribute("warrantProjectDTO") WarrantProjectDTO warrantProjectDTO, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession, ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	{
		model.addAttribute("paymentTermsList", warrantProjectService.getPaymentTermsList());
		model.addAttribute("customerList", warrantProjectService.getCustomerList());
		return "warrantProject";
	}
	
	@RequestMapping(value = "/show.do", method = RequestMethod.GET)
	public String show(ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	{
		model.addAttribute("warrantProjectList", warrantProjectService.getWarrantProjectList());
		return "quotations";
	}
	
	@RequestMapping(value = "/save.do", method = RequestMethod.POST)
	public String save(@ModelAttribute("warrantProjectDTO") WarrantProjectDTO warrantProjectDTO, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession, ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	{
		WarrantProject warrantProject;
		Integer idWarrantProject;

		try
		{
			idWarrantProject = 0;
			if(warrantProjectDTO.getWarrantProjectId() == null)
			{
				warrantProject = new WarrantProject();
				warrantProject.setStatus(warrantProjectDTO.getStatus());
				warrantProject.setCustomerId(warrantProjectDTO.getCustomerId());
				warrantProject.setCostCenter(warrantProjectDTO.getCostCenter());
				warrantProject.setExchangeRate(warrantProjectDTO.getExchangeRate());
				warrantProject.setUpdateDate(warrantProjectDTO.getUpdateDate());
				warrantProject.setContactName(warrantProjectDTO.getContactName());
				warrantProject.setUbicationProject(warrantProjectDTO.getUbicationProject());
				warrantProject.setPaymentTermsId(warrantProjectDTO.getPaymentTermsId());
				warrantProject.setDeliveryTime(warrantProjectDTO.getDeliveryTime());
				warrantProject.setIntercom(warrantProjectDTO.getIntercom());
				warrantProject.setTotalProject(warrantProjectDTO.getTotalProject());
				warrantProject.setBonds(warrantProjectDTO.getBonds());
				warrantProject.setTotalProductsServices(warrantProjectDTO.getTotalProductsServices());
				warrantProject.setEntryId(warrantProjectDTO.getEntryId());
				idWarrantProject = warrantProjectService.saveWarrantProject(warrantProject);
}
		}
		catch(Exception e)
		{
			StringBuilder details = new StringBuilder(e.toString() + "\n");
			for(StackTraceElement element : e.getStackTrace())
			{
				details.append(element.toString() + "\n");
			}
			model.addAttribute("errorDetails", details.toString());
			e.printStackTrace();
			return "error";
		}
		return "customers";
	}
}
