package com.bloom.web.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

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
import com.blackstar.web.AbstractController;
import com.bloom.common.bean.ReportTicketBean;
import com.bloom.common.bean.RespuestaJsonBean;
import com.bloom.common.exception.ServiceException;
import com.bloom.services.ReportsTicketsService;

import org.springframework.web.bind.annotation.RequestMethod;





/**
 * Controller principal para el paquete bloom
 * 
 * @author Oscar.Martinez
 */
@Controller
@RequestMapping("/bloomReports")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class ReportsInternalTicketsController extends AbstractController {

	private ReportsTicketsService reportsTicketsService;
	
	
	
	

	@RequestMapping(value = "/reportStatisticsByHelpDesk.do", method = RequestMethod.GET)
	public String reportStatisticsByHelpDesk(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		return "bloom/reportStatisticsByHelpDesk";
	}	

	
	@RequestMapping(value = "/reportPercentageTimeClosedTickets.do", method = RequestMethod.GET)
	public String reportPercentageTimeClosedTickets(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		return "bloom/reportPercentageTimeClosedTickets";
	}	

	
	@RequestMapping(value = "/reportPercentageEvaluationTickets.do", method = RequestMethod.GET)
	public String reportPercentageEvaluationTickets(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		return "bloom/reportPercentageEvaluationTickets";
	}	
	
	@RequestMapping(value = "/reportNumberTicketsByArea.do", method = RequestMethod.GET)
	public String reportNumberTicketsByArea(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		return "bloom/reportNumberTicketsByArea";
	}	

	/**
	 * @return the reportsTicketsService
	 */
	public ReportsTicketsService getReportsTicketsService() {
		return reportsTicketsService;
	}


	/**
	 * @param reportsTicketsService the reportsTicketsService to set
	 */
	public void setReportsTicketsService(ReportsTicketsService reportsTicketsService) {
		this.reportsTicketsService = reportsTicketsService;
	}	
	
	
	/**
	 * lista de registros del reporte.
	 * @param startCreationDateTicket
	 * @param endCreationDateTicket
	 * @return
	 */
	@RequestMapping(value = "/getStatisticsByHelpDesk.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	RespuestaJsonBean getStatisticsByHelpDesk(
			@RequestParam(value = "startCreationDateTicket", required = true) String startCreationDateTicket,
			@RequestParam(value = "endCreationDateTicket", required = true) String endCreationDateTicket) {

		RespuestaJsonBean response = new RespuestaJsonBean();

		try {

			List<ReportTicketBean> registros = reportsTicketsService.getStatisticsByHelpDesk(startCreationDateTicket, endCreationDateTicket);
					

			if (registros == null || registros.isEmpty()) {
				response.setEstatus("preventivo");
				response.setMensaje("No se encontro datos del reporte tiempo de respuesta de mesa de ayuda");
				response.setLista(registros);

			} else {
				String resumen = "Se encontraron " + registros.size()
						+ " del reporte";
				response.setEstatus("ok");
				response.setLista(registros);
				response.setMensaje(resumen);
			}

		} catch (ServiceException e) {

			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response.setMensaje(e.getMessage());
		} catch (Exception e) {

			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response
			.setMensaje("Error al obtener datos del reporte. Por favor intente m\u00e1s tarde.");
		}

		return response;
	}
	

	
	/**
	 * lista de registros del reporte.
	 * @param startCreationDateTicket
	 * @param endCreationDateTicket
	 * @return
	 */
	@RequestMapping(value = "/getPercentageTimeClosedTickets.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	RespuestaJsonBean getPercentageTimeClosedTickets(
			@RequestParam(value = "startCreationDateTicket", required = true) String startCreationDateTicket,
			@RequestParam(value = "endCreationDateTicket", required = true) String endCreationDateTicket) {

		RespuestaJsonBean response = new RespuestaJsonBean();

		try {

			List<ReportTicketBean> registros = reportsTicketsService.getPercentageTimeClosedTickets(startCreationDateTicket, endCreationDateTicket);
					

			if (registros == null || registros.isEmpty()) {
				response.setEstatus("preventivo");
				response.setMensaje("No se encontro datos del reporte tickets cerrados a tiempo");
				response.setLista(registros);

			} else {
				String resumen = "Se encontraron " + registros.size()
						+ " del reporte";
				response.setEstatus("ok");
				response.setLista(registros);
				response.setMensaje(resumen);
			}

		} catch (ServiceException e) {

			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response.setMensaje(e.getMessage());
		} catch (Exception e) {

			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response
			.setMensaje("Error al obtener datos del reporte. Por favor intente m\u00e1s tarde.");
		}

		return response;
	}
	

	
	/**
	 * lista de registros del reporte.
	 * @param startCreationDateTicket
	 * @param endCreationDateTicket
	 * @return
	 */
	@RequestMapping(value = "/getPercentageEvaluationTickets.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	RespuestaJsonBean getPercentageEvaluationTickets(
			@RequestParam(value = "startCreationDateTicket", required = true) String startCreationDateTicket,
			@RequestParam(value = "endCreationDateTicket", required = true) String endCreationDateTicket) {

		RespuestaJsonBean response = new RespuestaJsonBean();

		try {

			List<ReportTicketBean> registros = reportsTicketsService.getPercentageEvaluationTickets(startCreationDateTicket, endCreationDateTicket);
					

			if (registros == null || registros.isEmpty()) {
				response.setEstatus("preventivo");
				response.setMensaje("No se encontro datos del reporte tickets por evaluacion");
				response.setLista(registros);

			} else {
				String resumen = "Se encontraron " + registros.size()
						+ " del reporte";
				response.setEstatus("ok");
				response.setLista(registros);
				response.setMensaje(resumen);
			}

		} catch (ServiceException e) {

			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response.setMensaje(e.getMessage());
		} catch (Exception e) {

			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response
			.setMensaje("Error al obtener datos del reporte. Por favor intente m\u00e1s tarde.");
		}

		return response;
	}
	
	
	
	/**
	 * lista de registros del reporte.
	 * @param startCreationDateTicket
	 * @param endCreationDateTicket
	 * @return
	 */
	@RequestMapping(value = "/getNumberTicketsByArea.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	RespuestaJsonBean getNumberTicketsByArea(
			@RequestParam(value = "startCreationDateTicket", required = true) String startCreationDateTicket,
			@RequestParam(value = "endCreationDateTicket", required = true) String endCreationDateTicket) {

		RespuestaJsonBean response = new RespuestaJsonBean();

		try {

			List<ReportTicketBean> registros = reportsTicketsService.getNumberTicketsByArea(startCreationDateTicket, endCreationDateTicket);
					

			if (registros == null || registros.isEmpty()) {
				response.setEstatus("preventivo");
				response.setMensaje("No se encontro datos del reporte numero de tickets por area de apoyo");
				response.setLista(registros);

			} else {
				String resumen = "Se encontraron " + registros.size()
						+ " del reporte";
				response.setEstatus("ok");
				response.setLista(registros);
				response.setMensaje(resumen);
			}

		} catch (ServiceException e) {

			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response.setMensaje(e.getMessage());
		} catch (Exception e) {

			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response
			.setMensaje("Error al obtener datos del reporte. Por favor intente m\u00e1s tarde.");
		}

		return response;
	}
		
}
