package com.bloom.web.controller;

import java.util.Date;
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
import com.blackstar.services.interfaces.UserDomainService;
import com.blackstar.web.AbstractController;
import com.bloom.common.bean.DeliverableTraceBean;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.bean.RespuestaJsonBean;
import com.bloom.common.exception.ServiceException;
import com.bloom.common.utils.DataTypeUtil;
import com.bloom.common.utils.FolioTicketUtil;
import com.bloom.services.InternalTicketsService;

import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Controller principal para el paquete bloom
 * 
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
	 * @param internalTicketsService
	 *            the internalTicketsService to set
	 */
	public void setInternalTicketsService(
			InternalTicketsService internalTicketsService) {
		this.internalTicketsService = internalTicketsService;
	}

	/**
	 * Vista en el dashboard de los tickets que tiene asignado algun perfil como responsable
	 * @param model
	 * @param userSession
	 * @return
	 */
	@RequestMapping(value = "/getPendingInternalTickets.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	RespuestaJsonBean getPendingInternalTickets(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		RespuestaJsonBean respuesta = new RespuestaJsonBean();

		Long userId = userSession.getUser().getUserId();

		try {

			List<InternalTicketBean> registros = internalTicketsService
					.getPendingTickets(userId);

			if (registros == null || registros.isEmpty()) {
				respuesta.setEstatus("preventivo");
				respuesta.setMensaje("No se encontraron Tickets Pendientes");
				// log.info("No se encontraron registros de Emisiones Generadas");
			} else {
				String resumen = "Se encontraron " + registros.size()
						+ " Tickets Pendientes";
				// log.info("Se encontraron " + registros.size() +
				// " Emisiones Generadas");
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
			respuesta
					.setMensaje("Error al obtener tickets internos pendientes. Por favor intente m\u00e1s tarde.");
		}

		return respuesta;
	}
	
	
	
	/**
	 * Vista en el dashboard del dominio de tickets de un perfil coordinador. 
	 * @param model
	 * @param userSession
	 * @return
	 */
	@RequestMapping(value = "/getInternalTickets.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	RespuestaJsonBean getInternalTickets(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		RespuestaJsonBean respuesta = new RespuestaJsonBean();

		Long userId = userSession.getUser().getUserId();

		try {

			List<InternalTicketBean> registros = internalTicketsService
					.getTickets(userId);

			if (registros == null || registros.isEmpty()) {
				respuesta.setEstatus("preventivo");
				respuesta.setMensaje("No se encontraron Tickets Pendientes");
				// log.info("No se encontraron registros de Emisiones Generadas");
			} else {
				String resumen = "Se encontraron " + registros.size()
						+ " Tickets Pendientes";
				// log.info("Se encontraron " + registros.size() +
				// " Emisiones Generadas");
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
			respuesta
					.setMensaje("Error al obtener tickets internos pendientes. Por favor intente m\u00e1s tarde.");
		}

		return respuesta;
	}
	
	
	

	@RequestMapping(value = "/newInternalTicket.do", method = RequestMethod.GET)
	public String newInternalTicket(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		Date tiempoActual = new Date();

		try {

			String folio = internalTicketsService.generarTicketNumber();

			String email = userSession.getUser().getUserEmail();
			String horaTicket = DataTypeUtil.formatearFecha(tiempoActual,
					"MM/dd/yyyy HH:mm:ss");

			model.addAttribute("folioTicket", folio);
			model.addAttribute("emailTicket", email);
			model.addAttribute("horaTicket", horaTicket);

		} catch (ServiceException se) {
			Logger.Log(LogLevel.ERROR, se.getMessage(), se);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);
		}

		return "bloomNewInternalTicket";
	}

	/**
	 * Controller para atender la petición para guardar la atencion
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/guardarTicket.do", method = RequestMethod.POST, produces = "application/json")
	public @ResponseBody
	RespuestaJsonBean guardarAtencion(
			final HttpServletRequest request,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession,
			@RequestParam(value = "fldFolio", required = true) String fldFolio,
			@RequestParam(value = "fldFechaRegsitro", required = true) String fldFechaRegsitro,
			@RequestParam(value = "fldEmail", required = true) String fldEmail,
			@RequestParam(value = "slAreaSolicitante", required = true) Integer slAreaSolicitante,
			@RequestParam(value = "slTipoServicio", required = true) Integer slTipoServicio,
			@RequestParam(value = "fldLimite", required = true) String fldLimite,
			@RequestParam(value = "slProyecto", required = true) String slProyecto,
			@RequestParam(value = "slOficina", required = true) String slOficina,
			@RequestParam(value = "slDocumento", required = true) Long slDocumento,
			@RequestParam(value = "fldDescripcion", required = true) String fldDescripcion,
			@RequestParam(value = "fldDiasRespuesta", required = true) Integer fldDiasRespuesta,
			@RequestParam(value = "slAreaSolicitanteLabel", required = true) String slAreaSolicitanteLabel,
			@RequestParam(value = "slTipoServicioLabel", required = true) String slTipoServicioLabel,
			@RequestParam(value = "slOficinaLabel", required = true) String slOficinaLabel) {
		
		
		RespuestaJsonBean respuesta = new RespuestaJsonBean();

		try {

			InternalTicketBean ticket = new InternalTicketBean();

			DeliverableTraceBean deliverableTrace = new DeliverableTraceBean();
			deliverableTrace.setDeliverableId(slDocumento);

			ticket.setTicketNumber(fldFolio); //email
			ticket.setCreatedStr(fldFechaRegsitro);//email
			ticket.setApplicantAreaId(slAreaSolicitante);//email -par
			ticket.setServiceTypeId(slTipoServicio); //email - par
			ticket.setDescription(fldDescripcion);
			ticket.setReponseInTime(fldDiasRespuesta);
			ticket.setDeadlineStr(fldLimite);
			ticket.setProject(slProyecto);//email
			ticket.setOfficeId(slOficina);//email - par
			ticket.setDeliverableTrace(deliverableTrace);
			ticket.setApplicantUserId(userSession.getUser().getUserId());
			ticket.setCreatedUserId(userSession.getUser().getUserId());
			ticket.setCreatedUserName(userSession.getUser().getUserName());//email
			ticket.setCreatedUserEmail(userSession.getUser().getUserEmail());
			
			ticket.setPetitionerArea(slAreaSolicitanteLabel);
			ticket.setServiceTypeDescr(slTipoServicioLabel);
			ticket.setOfficeName(slOficinaLabel);
			

			internalTicketsService.registrarNuevoTicket(ticket);

			respuesta.setEstatus("ok");
			respuesta
					.setMensaje("La solicitud de ticket se guard&oacute; con &eacute;xito");

		} catch (ServiceException se) {
			respuesta.setEstatus("error");
			respuesta.setMensaje(se.getMessage());
			Logger.Log(LogLevel.ERROR, se.getMessage(), se);
		} catch (Exception e) {
			respuesta.setEstatus("error");
			respuesta.setMensaje("Error al guardar atenci&oacute;n");
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);
		}

		return respuesta;

	}

}
