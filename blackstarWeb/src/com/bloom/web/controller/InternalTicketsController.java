package com.bloom.web.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.web.AbstractController;
import com.bloom.common.bean.RespuestaJsonBean;
import com.bloom.model.dto.TicketTeamDTO;
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



	@RequestMapping(value = "/generarUnidadesCliente.htm", method = RequestMethod.POST, produces = "application/json")
    public @ResponseBody
    RespuestaJsonBean generarUnidadesCliente(HttpServletRequest request, Map<String, Object> model,
            @RequestParam(value = "idCliente") Long idCliente) {
		
		return new RespuestaJsonBean();
	}
	
  @RequestMapping(value = "/ticketDetail/show.do", method = RequestMethod.GET)
  public String show(@RequestParam(required = true) Integer ticketId
				                                 , ModelMap model) {
	StringBuilder ticketTeamStr = new StringBuilder();
	List<TicketTeamDTO> ticketTeam = null;
	try {
		 ticketTeam = internalTicketsService.getTicketTeam(ticketId);
		 model.addAttribute("ticketDetail", internalTicketsService
				                       .getTicketDetail(ticketId));
		 for(int i = 0; i< ticketTeam.size() ; i++){
		   ticketTeamStr.append(ticketTeam.get(i).getBlackstarUserName());
		   if(i < (ticketTeam.size() - 1)){
			   ticketTeamStr.append(" / ");
		   }
		 }
		 model.addAttribute("ticketTeam", ticketTeamStr);
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/ticketDetail";
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
