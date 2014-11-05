package com.blackstar.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.services.SupportService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/support")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class ServiceKitController extends AbstractController{
	SupportService service;


	public void setService(SupportService service) {
		this.service = service;
	}

	@RequestMapping(value= "/show.do", method = RequestMethod.GET)
	public String show(@RequestParam(required = false) String code, ModelMap model){
		try{
			if(service.isGuidValid(code)){
				return "serviceKit";
			}else
			{
				service.newGuid();
				return "serviceKitCodeSent";
			}
		}
		catch (Exception e) 
		{
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[0].toString(), e);
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
			return "error";
		}
	}

	@RequestMapping(value="getServiceOrderDetails.do")
	public @ResponseBody String getServiceOrderDetails(@RequestParam(required = true) String serviceOrderNumber, ModelMap model) {
		String retVal;
		try {
			retVal = service.getServiceOrderDetail(serviceOrderNumber);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}

	@RequestMapping(value="getServiceOrderComments.do")
	public @ResponseBody String getServiceOrderComments(@RequestParam(required = true) String serviceOrderNumber, ModelMap model) {
		String retVal;
		try {
			retVal = service.getServiceOrderComments(serviceOrderNumber);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}

	@RequestMapping(value="getTicketDetail.do")
	public @ResponseBody String getTicketDetail(@RequestParam(required = true) String ticketNumber, ModelMap model) {
		String retVal;
		try {
			retVal = service.getTicketDetails(ticketNumber);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}

	@RequestMapping(value="getTicketComments.do")
	public @ResponseBody String getTicketComments(@RequestParam(required = true) String ticketNumber, ModelMap model) {
		String retVal;
		try {
			retVal = service.getTicketComments(ticketNumber);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}

	@RequestMapping(value="getBloomTicketDetails.do")
	public @ResponseBody String getBloomTicketDetails(@RequestParam(required = true) String ticketNumber, ModelMap model) {
		String retVal;
		try {
			retVal = service.getBloomTicketDetails(ticketNumber);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}

	@RequestMapping(value="getBloomTicketComments.do")
	public @ResponseBody String getBloomTicketComments(@RequestParam(required = true) String ticketNumber, ModelMap model) {
		String retVal;
		try {
			retVal = service.getBloomTicketComments(ticketNumber);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
	
	@RequestMapping(value="deleteComment.do")
	public @ResponseBody String deleteComment(@RequestParam(required = true) Integer followUpId, ModelMap model) {
		String retVal;
		try {
			retVal = service.deleteFollowUp(followUpId);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
	
	@RequestMapping(value="deleteServiceOrder.do")
	public @ResponseBody String deleteServiceOrder(@RequestParam(required = true) String serviceOrderNumber, ModelMap model) {
		String retVal;
		try {
			retVal = service.deleteServiceOrder(serviceOrderNumber);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
	
	@RequestMapping(value="deleteServiceOrderPDF.do")
	public @ResponseBody String deleteServiceOrderPDF(@RequestParam(required = true) String serviceOrderNumber, ModelMap model) {
		String retVal;
		try {
			retVal = service.deleteServiceOrderPDF(serviceOrderNumber);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
	
	@RequestMapping(value="deleteTicket.do")
	public @ResponseBody String deleteTicket(@RequestParam(required = true) String ticketNumber, ModelMap model) {
		String retVal;
		try {
			retVal = service.deleteTicket(ticketNumber);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
	
	@RequestMapping(value="deleteBloomTicket.do")
	public @ResponseBody String deleteBloomTicket(@RequestParam(required = true) String ticketNumber, ModelMap model) {
		String retVal;
		try {
			retVal = service.deleteBloomTicket(ticketNumber);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
}
