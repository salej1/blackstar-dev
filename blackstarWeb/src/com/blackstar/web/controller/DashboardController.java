package com.blackstar.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.blackstar.services.interfaces.DashboardService;
import com.blackstar.web.AbstractController;

import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/dashboard")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class DashboardController extends AbstractController {

	private DashboardService service;

	public void setService(DashboardService service) {
		this.service = service;
	}

	// Dashboard principal
	@RequestMapping(value = "/show.do", method = RequestMethod.GET)
	public String show(ModelMap model, HttpServletRequest req,
			HttpServletResponse resp) {
		try {
			// se carga la lista de oficinas
			if(!model.containsAttribute("offices")){
				model.addAttribute("offices", service.getOfficesList());
			}
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return "dashboard";
	}

	//================================================================================
    //  CALL CENTER Y COORDINADORAS
    //================================================================================

	// Tickets por asignar
	@RequestMapping(value = "/unassignedTicketsJson.do", method = RequestMethod.GET)
	public @ResponseBody String unnasignedTicketsJson(ModelMap model) {
		String retVal;
		try {
			model.addAttribute("employees", udService.getStaff());
			retVal = service.getUnassignedTickets();
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}

	// Ordenes de servicio nuevas
	@RequestMapping(value = "/newServiceOrdersJson.do", method = RequestMethod.GET)
	public @ResponseBody String newServiceOrdersJson(ModelMap model) {
		String retVal;
		try {
			retVal = service.getServiceOrders("NUEVO");
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}

	// Ordenes de servicio con pendientes
	@RequestMapping(value = "/pendingServiceOrdersJson.do", method = RequestMethod.GET)
	public @ResponseBody String pendingServiceOrdersJson(ModelMap model) {
		String retVal;
		try {
			retVal = service.getServiceOrders("PENDIENTE");
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}

	// Asignacion de tickets - POST handler
	@RequestMapping(value = "/asignTicket.do", method = RequestMethod.POST)
	public String asignTicket(@RequestParam(required = true) Integer ticketId,
			@RequestParam(required = true) String employee,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession,
			ModelMap model, HttpServletRequest req, HttpServletResponse resp) {
		String who = userSession == null ? "portal-servicios@gposac.com.mx"
				: userSession.getUser().getUserEmail();
		try {
			TicketController.AssignTicket(ticketId, employee, who, null);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return show(model, req, resp);
	}

	//================================================================================
    //  FIN CALL CENTER Y COORDINADORAS
    //================================================================================

	//================================================================================
    //  INGENIEROS DE SERVICIO
    //================================================================================
	
	// Tickets asignados
	@RequestMapping(value="/assignedTicketsJson.do", method=RequestMethod.GET)
	public @ResponseBody String assignedTicketsJson(ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
		String retVal;
		try{
			retVal = service.getAssignedTickets(userSession.getUser().getUserEmail());
		}
		catch(Exception e){
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
	// Servicios programados
	@RequestMapping(value = "/scheduledPersonalServicesJson.do", method = RequestMethod.GET)
	public @ResponseBody String scheduledPersonalServicesJson(ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
		String retVal;
		try {
			retVal = service.getScheduledServices(userSession.getUser().getUserEmail());
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
	
	// Ordenes de servicio personales con pendientes
	@RequestMapping(value = "/pendingPersonalServiceOrders.do", method = RequestMethod.GET)
	public @ResponseBody String pendingPersonalServiceOrders(ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
		String retVal;
		try {
			retVal = service.getPersonalServiceOrders(userSession.getUser().getUserEmail(), "PENDIENTE");
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
	
	// Handler para creacion de nueva orden de servicio
	@RequestMapping(value = "/createServiceOrder.do", method = RequestMethod.GET)
	public String createServiceOrder(
			@RequestParam(required = true) String equipmentType,
			@RequestParam(required = false) Integer ticketId,
			ModelMap model) {
		String retVal;
		try {
			model.addAttribute("employees", udService.getStaff());
			retVal = service.getUnassignedTickets();
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}

	
	//================================================================================
    //  FIN INGENIEROS DE SERVICIO
    //================================================================================

}
