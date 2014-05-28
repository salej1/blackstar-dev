package com.bloom.web.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
import com.blackstar.services.interfaces.UserDomainService;
import com.blackstar.web.AbstractController;
import com.bloom.common.bean.DeliverableTraceBean;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.bean.RespuestaJsonBean;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.common.exception.ServiceException;
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
  private UserDomainService udService = null;

  public void setUdService(UserDomainService udService) {
	this.udService = udService;
  }

	/**
	 * @return the internalTicketsService
	 */
	public InternalTicketsService getInternalTicketsService() {
		return internalTicketsService;
	}

  @RequestMapping(value = "/generarUnidadesCliente.htm", method = RequestMethod.POST, produces = "application/json")
  public @ResponseBody RespuestaJsonBean generarUnidadesCliente(HttpServletRequest request 
		 , Map<String, Object> model, @RequestParam(value = "idCliente") Long idCliente) {
		return new RespuestaJsonBean();
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

		Long userId = Long.valueOf(userSession.getUser().getBlackstarUserId());

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
				System.out.println("Registros => " + registros.size());
			}

		} catch (ServiceException e) {
			System.out.println("Error => " + e);
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			respuesta.setEstatus("error");
			respuesta.setMensaje(e.getMessage());
		} catch (Exception e) {
            System.out.println("Error => " + e);
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

		Long userId = Long.valueOf(userSession.getUser().getBlackstarUserId());

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

  @RequestMapping(value = "/ticketDetail/show.do", method = RequestMethod.GET)
  public String showDetail(@RequestParam(required = true) String ticketNumber
				                                       , ModelMap model) {
	TicketDetailDTO ticketDetail = null;
	Integer ticketId = null;
	try {
		 ticketId = internalTicketsService.getTicketId(ticketNumber);
		 if(ticketId != null && ticketId > 0){
		   ticketDetail = internalTicketsService.getTicketDetail(ticketId);
		   model.addAttribute("ticketTeam", internalTicketsService
				                        .getTicketTeam(ticketId));
		   model.addAttribute("ticketDetail", ticketDetail);
		   model.addAttribute("osAttachmentFolder", gdService
				        .getAttachmentFolderId(ticketDetail.getTicketNumber()));
		   model.addAttribute("accessToken", gdService.getAccessToken());
		   model.addAttribute("staff", udService.getStaff());
		   model.addAttribute("followUps", internalTicketsService
				                        .getFollowUps(ticketId));
		   model.addAttribute("deliverableTypes", internalTicketsService
				                                .getDeliverableTypes());
		   model.addAttribute("deliverables", internalTicketsService
                                   .getTicketDeliverable(ticketId));
		 }
	} catch (Exception e) {
		System.out.println("Error => " + e);
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/ticketDetail";
  }
  
  @RequestMapping(value = "/ticketDetail/addFollow.do", method = RequestMethod.GET)
  public String addFollow(@RequestParam(required = true) Integer ticketId
		                , @RequestParam(required = true) Integer userId
		                , @RequestParam(required = true) String comment
		                , @RequestParam(required = true) Integer userToAssign
				                                    , ModelMap model) {
	boolean sendNotification = true;
	try {
		//Comment
		if(userToAssign == -2){
			userToAssign = internalTicketsService.getAsigneed(ticketId)
				                                 .getBlackstarUserId();
			sendNotification = false;
		} else if (userToAssign == -3){ //Response
			userToAssign = internalTicketsService.getResponseUser(ticketId)
                                                    .getBlackstarUserId();
		}
		internalTicketsService.addFollow(ticketId, userId, comment);
		internalTicketsService.addTicketTeam(ticketId, 1, userToAssign);
		if(sendNotification){
		  internalTicketsService.sendNotification(userId, userToAssign, ticketId
				                                                     , comment);
		}
		model.addAttribute("followUps", internalTicketsService.getFollowUps(ticketId));
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/_ticketFollow";
  }
  
  @RequestMapping(value = "/ticketDetail/addDeliverableTrace.do", method = RequestMethod.GET)
  public ResponseEntity<HttpStatus> addDeliverableTrace(@RequestParam(required = true) Integer ticketId
		                        , @RequestParam(required = true) Integer deliverableTypeId
				                                                       , ModelMap model) {
	try {
		 if(deliverableTypeId > 0){
		   internalTicketsService.addDeliverableTrace(ticketId, deliverableTypeId);
		 }
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return new ResponseEntity<HttpStatus>(HttpStatus.BAD_REQUEST);
	}
	return new ResponseEntity<HttpStatus>(HttpStatus.OK);
  }
  
  @RequestMapping(value = "/ticketDetail/close.do", method = RequestMethod.GET)
  public String closeTicket(@RequestParam(required = true) Integer ticketId
		                , @RequestParam(required = true) Integer userId
				                                    , ModelMap model) {
	try {
		internalTicketsService.closeTicket(ticketId, userId);
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "dashboard";
  }
  
	/**
	 * Vista en el dashboard del dominio de tickets de un perfil coordinador. 
	 * @param model
	 * @param userSession
	 * @return
	 */
	@RequestMapping(value = "/getHistoricalInternalTickets.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	RespuestaJsonBean getHistoricalInternalTickets(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession,
			@RequestParam(value = "startCreationDateTicket", required = true) String startCreationDateTicket,
			@RequestParam(value = "endCreationDateTicket", required = true) String endCreationDateTicket,
			@RequestParam(value = "idStatusTicket", required = true) Integer idStatusTicket) {

		RespuestaJsonBean response = new RespuestaJsonBean();

		Long userId = (long)userSession.getUser().getBlackstarUserId();

		try {

			List<InternalTicketBean> registros = internalTicketsService
					.getHistoricalTickets(startCreationDateTicket, endCreationDateTicket, idStatusTicket);

			if (registros == null || registros.isEmpty()) {
				response.setEstatus("preventivo");
				response.setMensaje("No se encontro Historico de Tickets");
				response.setLista(registros);
			} else {
				String resumen = "Se encontraron " + registros.size()
						+ " del Historico Tickets";
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
					.setMensaje("Error al obtener historico tickets internos pendientes. Por favor intente m\u00e1s tarde.");
		}

		return response;
	}
	

	@RequestMapping(value = "/newInternalTicket.do", method = RequestMethod.GET)
	public String newInternalTicket(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		 
		TimeZone tz =TimeZone.getTimeZone("America/Mexico_City");
		Calendar calendar = Calendar.getInstance(tz);
		SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
	    
		try {
			df.setTimeZone(tz);
			String folio = internalTicketsService.generarTicketNumber();
			String email = userSession.getUser().getUserEmail();
			model.addAttribute("folioTicket", folio);
			model.addAttribute("emailTicket", email);
			model.addAttribute("horaTicket", df.format(calendar.getTime()));

		} catch (ServiceException se) {
			Logger.Log(LogLevel.ERROR, se.getMessage(), se);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);
		}

		return "bloom/bloomNewInternalTicket";
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
			ticket.setApplicantUserId(Long.valueOf(userSession.getUser().getBlackstarUserId()));
			ticket.setCreatedUserId(Long.valueOf(userSession.getUser().getBlackstarUserId()));
			ticket.setCreatedUserName(userSession.getUser().getUserName());//email
			ticket.setCreatedUserEmail(userSession.getUser().getUserEmail());

			ticket.setPetitionerArea(slAreaSolicitanteLabel);
			ticket.setServiceTypeDescr(slTipoServicioLabel);
			ticket.setOfficeName(slOficinaLabel);


			internalTicketsService.validarNuevoTicket(ticket);

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

	@RequestMapping(value = "/sendPendingAppointments.do", method = RequestMethod.GET)
	public void sendMeetingRequest(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
	  try {
		   internalTicketsService.sendPendingAppointments();
	  } catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);
	  }
	}
	
	@RequestMapping(value = "/sendPendingSurveys.do", method = RequestMethod.GET)
	public void sendSurveyRequest(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
	  try {
		   internalTicketsService.sendPendingSurveys();
	  } catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);
	  }
	}

}