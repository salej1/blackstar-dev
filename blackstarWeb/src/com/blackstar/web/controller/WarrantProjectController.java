package com.blackstar.web.controller;

import java.text.DateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.model.Entry;
import com.blackstar.model.UserSession;
import com.blackstar.model.WarrantProject;
import com.blackstar.model.dto.EntryDTO;
import com.blackstar.model.dto.WarrantProjectDTO;
import com.blackstar.services.interfaces.EntryService;
import com.blackstar.services.interfaces.WarrantProjectService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/warrantProject")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class WarrantProjectController extends AbstractController 
{
	private WarrantProjectService warrantProjectService;
	private EntryService entryService;
	

	public void setEntryService(EntryService entryService) {
		this.entryService = entryService;
	}

	public void setWarrantProjectService(WarrantProjectService warrantProjectService)
	{
		this.warrantProjectService = warrantProjectService;
	}
	
	@RequestMapping(value = "/add.do", method = RequestMethod.GET)
	public String add(@ModelAttribute("warrantProjectDTO") WarrantProjectDTO warrantProjectDTO,@ModelAttribute("entryDTO") EntryDTO entryDTO, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession, ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	{
		model.addAttribute("paymentTermsList", warrantProjectService.getPaymentTermsList());
		model.addAttribute("customerList", warrantProjectService.getCustomerList());
		model.addAttribute("serviceTypeList",warrantProjectService.getServiceTypesList());
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
		int idWarrantProject;
		
		
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
		return "quotations";
	}
	
	@RequestMapping(value = "/saveEntry.do", method = RequestMethod.POST)
	public String saveEntry(@ModelAttribute("entryDTO") EntryDTO entryDTO, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession, ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	{
		Entry entry;
		int idEntry;
		
		
		try
		{
			idEntry = 0;
			if(entryDTO.getEntryId() == null)
			{
				entry=new Entry();
				entry.setType(entryDTO.getType());
				entry.setReference(entryDTO.getReference());
				entry.setDescription(entryDTO.getDescription());
				entry.setAmount(entryDTO.getAmount());
				entry.setUnitPrice(entryDTO.getUnitPrice());
				entry.setDiscount(entryDTO.getDiscount());
				entry.setTotal(entryDTO.getTotal());
				entry.setObservations(entryDTO.getObservations());
				idEntry = entryService.saveEntryt(entry);
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
		return "quotations";
	}
}
