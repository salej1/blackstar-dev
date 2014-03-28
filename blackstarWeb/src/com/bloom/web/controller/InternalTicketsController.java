package com.bloom.web.controller;

import java.util.List;
import java.util.Map;

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
import com.blackstar.model.Equipmenttype;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.Ticket;
import com.blackstar.model.TicketController;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.PlainServicePolicyDTO;
import com.blackstar.services.interfaces.DashboardService;
import com.blackstar.web.AbstractController;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.bean.RespuestaJsonBean;
import com.bloom.common.exception.ServiceException;
import com.bloom.services.InternalTicketsService;

import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Controller principal para el paquete bloom 
 * @author Oscar.Martinez
  */
@Controller
@RequestMapping("/bloom")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class InternalTicketsController extends AbstractController {


	private InternalTicketsService internalTicketsService;
	

	
	/**
	 * @return the internalTicketsService
	 */
	public InternalTicketsService getInternalTicketsService() {
		return internalTicketsService;
	}



	/**
	 * @param internalTicketsService the internalTicketsService to set
	 */
	public void setInternalTicketsService(
			InternalTicketsService internalTicketsService) {
		this.internalTicketsService = internalTicketsService;
	}



	@RequestMapping(value = "/getPendingTickets.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
    RespuestaJsonBean generarUnidadesCliente(ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
		
		RespuestaJsonBean respuesta = new RespuestaJsonBean();
		
		Long userId= userSession.getUser().getUserId();
		
		try{
			
	        List<InternalTicketBean> registros = internalTicketsService.getPendingTickets(userId);
	        
	        if (registros == null || registros.isEmpty()) {
	            respuesta.setEstatus("preventivo");
	            respuesta.setMensaje("No se encontraron Tickets Pendientes");
	            //log.info("No se encontraron registros de Emisiones Generadas");
	        } else {
	            String resumen = "Se encontraron " + registros.size() + " Tickets Pendientes";
	            //log.info("Se encontraron " + registros.size() + " Emisiones Generadas");
	            respuesta.setEstatus("ok");
	            respuesta.setLista(registros);
	            respuesta.setMensaje(resumen);
	        }		

			
		} catch (ServiceException e) {
            
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);
            
            respuesta.setEstatus("error");
            respuesta.setMensaje(e.getMessage());
        } catch (Exception e) {
        	
        	Logger.Log(LogLevel.ERROR, e.getMessage(), e);
            
            respuesta.setEstatus("error");
            respuesta.setMensaje("Error al obtener tickets internos pendientes. Por favor intente m\u00e1s tarde.");
        }
		
        
        return respuesta;
	}


	
	  @RequestMapping(value= "/newInternalTicket.do", method = RequestMethod.GET)
	  public String  newInternalTicket(ModelMap model)
	  {
		  
		  System.out.println("");
		  
		  
//		  try
//		  {
//			 
//	  		 
//		  } 
//		  catch (Exception e) 
//		  {
//				 Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
//				 model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
//				 return "error";
//		  }
		  
		  return "bloomNewInternalTicket";
	  }
	  
	
	
	
	
	
	

	// Ordenes de servicio nuevas
//	@RequestMapping(value = "/newServiceOrdersJson.do", method = RequestMethod.GET)
//	public @ResponseBody String newServiceOrdersJson(ModelMap model) {
//		String retVal;
//		try {
//			retVal = service.getServiceOrders("NUEVO");
//		} catch (Exception e) {
//			Logger.Log(LogLevel.ERROR,
//					e.getStackTrace()[0].toString(), e);
//			e.printStackTrace();
//			return "error";
//		}
//		return retVal;
//	}

	// Ordenes de servicio con pendientes
//	@RequestMapping(value = "/pendingServiceOrdersJson.do", method = RequestMethod.GET)
//	public @ResponseBody String pendingServiceOrdersJson(ModelMap model) {
//		String retVal;
//		try {
//			retVal = service.getServiceOrders("PENDIENTE");
//		} catch (Exception e) {
//			Logger.Log(LogLevel.ERROR,
//					e.getStackTrace()[0].toString(), e);
//			e.printStackTrace();
//			return "error";
//		}
//		return retVal;
//	}

	// Asignacion de tickets - POST handler
//	@RequestMapping(value = "/asignTicket.do", method = RequestMethod.POST)
//	public String asignTicket(@RequestParam(required = true) Integer ticketId,
//			@RequestParam(required = true) String employee,
//			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession,
//			ModelMap model, HttpServletRequest req, HttpServletResponse resp, HttpSession session) {
//		String who = userSession == null ? "portal-servicios@gposac.com.mx"
//				: userSession.getUser().getUserEmail();
//		try {
//			TicketController.AssignTicket(ticketId, employee, who, null);
//		} catch (Exception e) {
//			Logger.Log(LogLevel.ERROR,
//					e.getStackTrace()[0].toString(), e);
//			e.printStackTrace();
//			return "error";
//		}
//		return "redirect:/dashboard/show.do";
//	}


}
