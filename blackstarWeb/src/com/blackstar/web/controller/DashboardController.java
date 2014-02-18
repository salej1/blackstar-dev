package com.blackstar.web.controller;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
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
import com.blackstar.model.TicketController;
import com.blackstar.model.UserSession;
import com.blackstar.services.interfaces.DashboardService;
import com.blackstar.web.AbstractController;
import com.google.api.client.http.HttpResponse;

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
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
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
			TicketController.AssignTicket(ticketId, employee, who, null);
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
			retVal = service.getPersonalServiceOrders(userSession.getUser().getUserEmail(), "PENDIENTE");
			retVal += "," + service.getPersonalServiceOrders(userSession.getUser().getUserEmail(), "NUEVO");
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
    //  GRUPO SAC
    //================================================================================
	
	
	// Ordenes de servicio Asignadas asignados
	@RequestMapping(value="/assignedServiceOrdersJson.do", method=RequestMethod.GET)
	public @ResponseBody String assignedServiceOrdersJson(ModelMap model
		  , @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
		String retVal;
		try{
			retVal = service.getAssignedServiceOrders(userSession.getUser()
					                                       .getUserName());
		}
		catch(Exception e){
			Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
	//================================================================================
    //  FIN GRUPO SAC
    //================================================================================

	//================================================================================
    //  ENCARGADOS DE AREA
    //================================================================================
	
	// Ordenes de servicio asignadas a miembros del equipo
		@RequestMapping(value="/teamServiceOrdersJson.do", method=RequestMethod.GET)
		public @ResponseBody String teamServiceOrdersJson(ModelMap model
			  , @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
			String retVal;
			try{
				retVal = service.getTeamServiceOrders(userSession.getUser()
						                                  .getUserEmail());
			}
			catch(Exception e){
				Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
				e.printStackTrace();
				return "error";
			}
			return retVal;
		}
		
		// Tickets asignados a miembros del equipo
		@RequestMapping(value="/teamTicketsJson.do", method=RequestMethod.GET)
		public @ResponseBody String teamTicketsJson(ModelMap model
			  , @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
			String retVal;
			try{
				retVal = service.getTeamTickets(userSession.getUser()
						                            .getUserEmail());
			}
			catch(Exception e){
				Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
				e.printStackTrace();
				return "error";
			}
			return retVal;
		}		
		
	//================================================================================
	//  FIN ENCARGADOS DE AREA
	//================================================================================		
	
	//================================================================================
	//  GERENTES
	//================================================================================
		
	// Tickets activos
	@RequestMapping(value="/activeTicketsJson.do", method=RequestMethod.GET)
	public @ResponseBody String getActiveTicketsJson(ModelMap model
		  , @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	  String retVal;
	  try {
		   retVal = service.getActiveTickets();
	  } catch(Exception e){
			Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
	  }
	  return retVal;
	}
	
	// Ordenes de servicio activas
	@RequestMapping(value="/activeServiceOrdersJson.do", method=RequestMethod.GET)
	public @ResponseBody String getActiveServiceOrdersJson(ModelMap model
		  , @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession){
	  String retVal;
	  try {
		   retVal = service.getActiveServiceOrders();
	  } catch(Exception e){
			Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
	  }
	  return retVal;
	}	
	
	// Ordenes de servicio activas (Archivo)
	@RequestMapping(value="/getServiceOrdersFile.do", method=RequestMethod.GET)
	public @ResponseBody void getServiceOrdersFile(ModelMap model
		                         , HttpServletResponse response) {
	  List<JSONObject> objList = null;
	  ServletOutputStream out = null;
	  try {
		   response.setContentType("application/json;charset=UTF-8");
		   response.setHeader("Content-Type", "application/json");
		   response.setHeader("Content-Disposition",
		            "attachment;filename=ServiceOrders.json");
		   objList = service.getActiveServiceOrdersObj();
		   out = response.getOutputStream();
		   for(JSONObject obj : objList){
			   out.write((obj.toString() + "\n").getBytes());
		   }
	  } catch(Exception e){
			Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
	  }
	}
	
	// Ordenes de servicio activas (Archivo)
	@RequestMapping(value="/getTicketsFile.do", method=RequestMethod.GET)
	public @ResponseBody void getTicketsFile(ModelMap model
		                         , HttpServletResponse response) {
	  List<JSONObject> objList = null;
	  ServletOutputStream out = null;
	  try {
		   response.setContentType("application/json;charset=UTF-8");
		   response.setHeader("Content-Type", "application/json");
		   response.setHeader("Content-Disposition",
		            "attachment;filename=ServiceOrders.json");
		   objList = service.getActiveTicketsObj();
		   out = response.getOutputStream();
		   for(JSONObject obj : objList){
			   out.write((obj.toString() + "\n").getBytes());
		   }
	  } catch(Exception e){
			Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
	  }
	}	
	//================================================================================
	//  FIN GERENTES
	//================================================================================
		
}
