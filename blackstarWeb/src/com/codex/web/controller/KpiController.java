package com.codex.web.controller;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.model.User;
import com.blackstar.model.UserSession;
import com.blackstar.web.AbstractController;
import com.codex.service.ClientService;
import com.codex.service.CstService;
import com.codex.service.KpiService;

@Controller
@RequestMapping("/codex/kpi")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class KpiController extends AbstractController{
	KpiService service;
	CstService cstService;
	ClientService clService;

	public void setService(KpiService service) {
		this.service = service;
	}

	public void setCstService(CstService cstService) {
		this.cstService = cstService;
	}

	public void setClService(ClientService clService) {
		this.clService = clService;
	}

	// KPI Page
	@RequestMapping(value = "/show.do")
	public String show(ModelMap model,HttpServletRequest request){
		
		try {
			model.addAttribute("cstList", cstService.getAllCst());
			model.addAttribute("originList", clService.getAllOriginTypes());

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			System.out.println("Error =>" + e);
			return "error";
		}
		return "codex/kpi";
	}

	// KPI Jason Objects
	@RequestMapping(value = "/getInvoicingKpi.do", produces="application/json")
	public @ResponseBody String getInvoicingKpi(
			@RequestParam(required=true) Date startDate, @RequestParam(required=true) Date endDate,
			@RequestParam(required=true) String cst, @RequestParam(required=true) Integer clientOriginId) {
		try {
			return service.getInvoicingKpi(startDate, endDate, cst, clientOriginId);
		} catch (Exception e) {
			System.out.println("getLocationsByZipCodeError=>" + e);
		}
		return null;
	}
	
	@RequestMapping(value = "/getEffectiveness.do", produces="application/json")
	public @ResponseBody String getEffectiveness(
			@RequestParam(required=true) Date startDate, @RequestParam(required=true) Date endDate,
			@RequestParam(required=true) String cst, @RequestParam(required=true) Integer clientOriginId) {
		try {
			return service.getEffectiveness(startDate, endDate, cst, clientOriginId);
		} catch (Exception e) {
			System.out.println("getEffectiveness=>" + e);
		}
		return null;
	}
	
	@RequestMapping(value = "/getProposals.do", produces="application/json")
	public @ResponseBody String getProposals(
			@RequestParam(required=true) Date startDate, @RequestParam(required=true) Date endDate,
			@RequestParam(required=true) String cst, @RequestParam(required=true) Integer clientOriginId) {
		try {
			return service.getProposals(startDate, endDate, cst, clientOriginId);
		} catch (Exception e) {
			System.out.println("getProposals=>" + e);
		}
		return null;
	}
	
	@RequestMapping(value = "/getProjectsByStatus.do", produces="application/json")
	public @ResponseBody String getProjectsByStatus(
			@RequestParam(required=true) Date startDate, @RequestParam(required=true) Date endDate,
			@RequestParam(required=true) String cst, @RequestParam(required=true) Integer clientOriginId) {
		try {
			return service.getProjectsByStatus(startDate, endDate, cst, clientOriginId);
		} catch (Exception e) {
			System.out.println("getProjectsByStatus=>" + e);
		}
		return null;
	}
	
	@RequestMapping(value = "/getProjectsByOrigin.do", produces="application/json")
	public @ResponseBody String getProjectsByOrigin(
			@RequestParam(required=true) Date startDate, @RequestParam(required=true) Date endDate,
			@RequestParam(required=true) String cst, @RequestParam(required=true) Integer clientOriginId) {
		try {
			return service.getProjectsByOrigin(startDate, endDate, cst, clientOriginId);
		} catch (Exception e) {
			System.out.println("getProjectsByOrigin=>" + e);
		}
		return null;
	}
	
	
	@RequestMapping(value = "/getClientVisits.do", produces="application/json")
	public @ResponseBody String getClientVisits(
			@RequestParam(required=true) Date startDate, @RequestParam(required=true) Date endDate,
			@RequestParam(required=true) String cst, @RequestParam(required=true) Integer clientOriginId) {
		try {
			return service.getClientVisits(startDate, endDate, cst, clientOriginId);
		} catch (Exception e) {
			System.out.println("getClientVisits=>" + e);
		}
		return null;
	}
	
	@RequestMapping(value = "/getNewCustomers.do", produces="application/json")
	public @ResponseBody String getNewCustomers(
			@RequestParam(required=true) Date startDate, @RequestParam(required=true) Date endDate,
			@RequestParam(required=true) String cst) {
		try {
			return service.getNewCustomers(startDate, endDate, cst);
		} catch (Exception e) {
			System.out.println("getNewCustomers=>" + e);
		}
		return null;
	}
	
	@RequestMapping(value = "/getProductFamilies.do", produces="application/json")
	public @ResponseBody String getProductFamilies(
			@RequestParam(required=true) Date startDate, @RequestParam(required=true) Date endDate,
			@RequestParam(required=true) String cst) {
		try {
			return service.getProductFamilies(startDate, endDate);
		} catch (Exception e) {
			System.out.println("getProductFamilies=>" + e);
		}
		return null;
	}
	
	@RequestMapping(value = "/getComerceCodes.do", produces="application/json")
	public @ResponseBody String getComerceCodes(
			@RequestParam(required=true) Date startDate, @RequestParam(required=true) Date endDate,
			@RequestParam(required=true) String cst) {
		try {
			return service.getComerceCodes(startDate, endDate);
		} catch (Exception e) {
			System.out.println("getComerceCodes=>" + e);
		}
		return null;
	}
	
	@RequestMapping(value = "/getSalesCallsRecords.do", produces="application/json")
	public @ResponseBody String getSalesCallsRecords(
			@RequestParam(required=true) Date startDate, @RequestParam(required=true) Date endDate,
			@RequestParam(required=true) String cst,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
		try {
			if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_SALES_MANAGER) != null){
				return service.getSalesCallsRecords(startDate, endDate, "All");
			}
			else{
				return service.getSalesCallsRecords(startDate, endDate, userSession.getUser().getUserEmail());
			}
			
		} catch (Exception e) {
			System.out.println("getComerceCodes=>" + e);
		}
		return null;
	}
}
