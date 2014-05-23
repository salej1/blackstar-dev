package com.blackstar.web.controller;

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
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
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
			HttpServletResponse resp ) {
		try {
			HttpSession session = req.getSession();
			// se carga la lista de oficinas si no existe
			if(session.getAttribute("offices") == null){
				session.setAttribute("offices", service.getOfficesList());
			}
			// se carga la lista de empleados si no existe
			if(session.getAttribute("staff") == null){
				session.setAttribute("staff", udService.getStaff());
			}
		} catch (final Throwable e) {
			String error = "";
			for(StackTraceElement trace : e.getStackTrace()){
				error = error + " at " + trace.toString();
			}
			Logger.Log(LogLevel.ERROR,
					error, e);
			e.printStackTrace();
			model.addAttribute("errorDetails", error);
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
			ModelMap model, HttpServletRequest req, HttpServletResponse resp, HttpSession session) {
		String who = userSession == null ? "portal-servicios@gposac.com.mx"
				: userSession.getUser().getUserEmail();
		try {
			AddFollowUpController.AssignTicket(ticketId, employee, who, null);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return "redirect:/dashboard/show.do";
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
			retVal = service.getPersonalServiceOrders(userSession.getUser().getUserEmail());
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

    //================================================================================
    //  CLIENTES
    //================================================================================
	
	// Tickets abiertos de cliente
	@RequestMapping(value = "/openLimitedTicketsJson.do", method = RequestMethod.GET)
	public @ResponseBody String openLimitedTicketsJson(ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
		String retVal;
		try {
			retVal = service.getOpenLimitedTicketsJson(userSession.getUser().getUserEmail());
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}

	// Ordenes en proceso de clientes
	@RequestMapping(value = "/pendingLimitedServiceOrdersJson.do", method = RequestMethod.GET)
	public @ResponseBody String pendingLimitedServiceOrdersJson(ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
		String retVal;
		try {
			retVal = service.getLimitedServiceOrdersJson(userSession.getUser().getUserEmail(), "PENDIENTE");
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
	
    //================================================================================
    //  FIN CLIENTES
    //================================================================================


}
