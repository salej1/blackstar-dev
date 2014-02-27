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
import com.blackstar.model.Entry;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.EntryDTO;
import com.blackstar.services.interfaces.EntryService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/entry")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class EntryController extends AbstractController
{
	private EntryService entryService;

	public void setEntryService(EntryService entryService) {
		this.entryService = entryService;
	}

	@RequestMapping(value = "/show.do", method = RequestMethod.GET)
	public String show(ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	{
		model.addAttribute("entryList", entryService.getEntryList());
		return "entrys";
	}
	
	@RequestMapping(value = "/save.do", method = RequestMethod.POST)
	public String save(@ModelAttribute("entryDTO") EntryDTO entryDTO, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession, ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	{
		Entry entry;
		Integer idEntry;

		try
		{
			idEntry = 0;
			if(entryDTO.getEntryId() == null)
			{
				entry = new Entry();
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
		return "entrys";
	}
}
