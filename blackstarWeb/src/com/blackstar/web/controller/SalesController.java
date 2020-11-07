package com.blackstar.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.interfaces.IUserService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.TicketController;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.WarrantProjectDTO;
import com.blackstar.services.interfaces.SalesService;
import com.blackstar.web.AbstractController;

import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/ventas")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class SalesController extends AbstractController {

	private SalesService service;

	public void setService(SalesService service) {
		this.service = service;
	}

	// sales principal
	@RequestMapping(value = "/show.do", method = RequestMethod.GET)
	public String show(ModelMap model, HttpServletRequest req,HttpServletResponse resp ) {
		try {
			//
			model.addAttribute("NewSaleslist", service.getNewSales());
			model.addAttribute("autSaleslist", service.getAuthorizedSales());
			model.addAttribute("pendingSaleslist", service.getPendingSales());
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			return "error";
		}
		return "sales";
	}

	//================================================================================
    //  
    //================================================================================
	
//	// Nuevas Ventas
//	@RequestMapping(value="/newSalesJson.do", method=RequestMethod.GET)
//	public @ResponseBody String newSalesJson(ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
//		List<WarrantProjectDTO> retVal;
//		try{
//			retVal = service.getNewSales();
//		}
//		catch(Exception e){
//			Logger.Log(LogLevel.ERROR,
//					e.getStackTrace()[0].toString(), e);
//			e.printStackTrace();
//			return "error";
//		}
//		return retVal;
//	}
//	// ventas autorizadas
//	@RequestMapping(value = "/AuthorizedSalesJson.do", method = RequestMethod.GET)
//	public @ResponseBody String AuthorizedSalesJson(ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
//		List<WarrantProjectDTO> retVal;
//		try {
//			retVal = service.getAuthorizedSales();
//		} catch (Exception e) {
//			Logger.Log(LogLevel.ERROR,
//					e.getStackTrace()[0].toString(), e);
//			e.printStackTrace();
//			return "error";
//		}
//		return retVal;
//	}
//	
//	// proyecto de ventas
//	@RequestMapping(value = "/pendingSales.do", method = RequestMethod.GET)
//	public @ResponseBody String pendingSales(ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
//		List<WarrantProjectDTO> retVal;
//		try {
//			retVal = service.getPendingSales();
//		} catch (Exception e) {
//			Logger.Log(LogLevel.ERROR,
//					e.getStackTrace()[0].toString(), e);
//			e.printStackTrace();
//			return "error";
//		}
//		return retVal;
//	}
	
	//================================================================================
    //  FIN 
    //================================================================================

}