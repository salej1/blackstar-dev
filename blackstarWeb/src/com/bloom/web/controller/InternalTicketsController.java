package com.bloom.web.controller;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

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
import com.bloom.common.utils.DataTypeUtil;
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

  private static final Integer RESOVLED_STATUS = 5;
  private static final Integer CLOSED_STATUS = 6;
  
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

		RespuestaJsonBean response = new RespuestaJsonBean();

		Long userId = Long.valueOf(userSession.getUser().getBlackstarUserId());

		try {

			List<InternalTicketBean> registros = internalTicketsService
					.getPendingTickets(userId);

			if (registros == null || registros.isEmpty()) {
				response.setEstatus("preventivo");
				response.setMensaje("No se encontraron Tickets Pendientes");
			} else {
				String resumen = "Se encontraron " + registros.size()
						+ " Tickets Pendientes";
				response.setEstatus("ok");
				response.setLista(registros);
				response.setMensaje(resumen);
				System.out.println("Registros => " + registros.size());
			}

		} catch (ServiceException e) {
			e.printStackTrace();
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response.setMensaje(e.getMessage());
		} catch (Exception e) {
            e.printStackTrace();
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response
					.setMensaje("Error al obtener tickets internos pendientes. Por favor intente m\u00e1s tarde.");
		}

		return response;
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

		RespuestaJsonBean response = new RespuestaJsonBean();

		Long userId = Long.valueOf(userSession.getUser().getBlackstarUserId());

		try {

			List<InternalTicketBean> registros = internalTicketsService
					.getTickets(userId);

			if (registros == null || registros.isEmpty()) {
				response.setEstatus("preventivo");
				response.setMensaje("No se encontraron Tickets Pendientes");
			} else {
				String resumen = "Se encontraron " + registros.size()
						+ " Tickets Pendientes";
				response.setEstatus("ok");
				response.setLista(registros);
				response.setMensaje(resumen);
			}

		} catch (ServiceException e) {
			e.printStackTrace();
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response.setMensaje(e.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response
					.setMensaje("Error al obtener tickets internos pendientes. Por favor intente m\u00e1s tarde.");
		}

		return response;
	}

  @RequestMapping(value = "/ticketDetail/show.do", method = RequestMethod.GET)
  public String showDetail(@RequestParam(required = true) Integer ticketId,
					ModelMap model,
				    @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
	TicketDetailDTO ticketDetail = null;
	
	try {

		 if(ticketId != null && ticketId > 0){
		   ticketDetail = internalTicketsService.getTicketDetail(ticketId, userSession.getUser().getUserEmail());
		   model.addAttribute("ticketTeam", internalTicketsService.getTicketTeam(ticketId));
		   model.addAttribute("ticketDetail", ticketDetail);
		   model.addAttribute("attachmentFolder", gdService.getAttachmentFolderId(ticketDetail.getTicketNumber()));
		   model.addAttribute("accessToken", gdService.getAccessToken());
		   model.addAttribute("staff", udService.getStaff());
		   model.addAttribute("followUps", internalTicketsService.getFollowUps(ticketId));
		   model.addAttribute("deliverableTypes", internalTicketsService.getDeliverableTypes(ticketDetail.getServiceTypeId()));
		   model.addAttribute("deliverableTrace", internalTicketsService.getTicketDeliverable(ticketDetail.get_id()));
		 }
	} catch (Exception e) {
		
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/internalTicketDetail";
  }
  
  @RequestMapping(value = "/ticketDetail/addFollowUp.do", method = RequestMethod.GET)
  public String addFollow(@RequestParam(required = true) Integer ticketId,
		                @RequestParam(required = true) Integer userId,
		                @RequestParam(required = true) String comment,
		                @RequestParam(required = true) String userToAssign,
				        ModelMap model,
				        @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
	try {
		internalTicketsService.addFollowUp(ticketId, userToAssign, userSession.getUser().getUserEmail(), comment);
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
		                        , @RequestParam(required = false) String prevId
		                        , @RequestParam(required = false) String deliverableName
		                        , @RequestParam(required = false) String ticketNumber
				                , ModelMap model) {
	try {
		
		// copiar el documento
		String docId = "";
		
		if(prevId != null && !prevId.equals("")){		
			docId = gdService.importFile(prevId, deliverableName, gdService.getAttachmentFolderId(ticketNumber));
		}
		 if(deliverableTypeId > 0){
		   internalTicketsService.addDeliverableTrace(ticketId, deliverableTypeId, docId);
		 }
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return new ResponseEntity<HttpStatus>(HttpStatus.BAD_REQUEST);
	}
	return new ResponseEntity<HttpStatus>(HttpStatus.OK);
  }
  
  @RequestMapping(value = "/ticketDetail/resolve.do", method = RequestMethod.GET)
  public String resolveTicket(@RequestParam(required = true) Integer ticketId
		                , @RequestParam(required = true) Integer userId, ModelMap model
		                , @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
	try {
		internalTicketsService.closeTicket(ticketId, userId, RESOVLED_STATUS, userSession.getUser().getUserName());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/bloomTicketPage";
  }

  @RequestMapping(value = "/ticketDetail/close.do", method = RequestMethod.GET)
  public String closeTicket(@RequestParam(required = true) Integer ticketId
		                , @RequestParam(required = true) Integer userId, ModelMap model
		                , @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
	try {
		internalTicketsService.closeTicket(ticketId, userId, CLOSED_STATUS, userSession.getUser().getUserName());
	} catch (Exception e) {
		Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
		e.printStackTrace();
		model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
		return "error";
	}
	return "bloom/bloomTicketPage";
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
		
		// Ocultamiento de tickets de RH
		Integer showHidden = 0;
		if((userSession.getUser().getBelongsToGroup().get(Globals.GROUP_HR) != null && userSession.getUser().getBelongsToGroup().get(Globals.GROUP_HR) == true) ||
			(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CEO) != null && userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CEO) == true)){
			showHidden = 1;
		}
		
		try {

			List<InternalTicketBean> registros = internalTicketsService
					.getHistoricalTickets(startCreationDateTicket, endCreationDateTicket, idStatusTicket, showHidden, userSession.getUser().getUserEmail());

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
			e.printStackTrace();
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);

			response.setEstatus("error");
			response.setMensaje(e.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
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

		try {

			String folio = internalTicketsService.generarTicketNumber();

			String email = userSession.getUser().getUserEmail();
			
			String horaTicket = Globals.getLocalTimeString();

			model.addAttribute("folioTicket", folio);
			model.addAttribute("emailTicket", email);
			model.addAttribute("horaTicket", horaTicket);

		} catch (Exception e) {
			e.printStackTrace();
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
	@RequestMapping(value = "/saveTicket.do", method = RequestMethod.POST, produces = "application/json")
	public @ResponseBody
	RespuestaJsonBean guardarAtencion(
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession,
			@RequestParam(value = "fldFolio", required = true) String fldFolio,
			@RequestParam(value = "fldFechaRegsitro", required = true) Date fldFechaRegsitro,
			@RequestParam(value = "fldEmail", required = true) String fldEmail,
			@RequestParam(value = "slAreaSolicitante", required = true) Integer slAreaSolicitante,
			@RequestParam(value = "slTipoServicio", required = true) Integer slTipoServicio,
			@RequestParam(value = "fldLimite", required = true) Date fldLimite,
			@RequestParam(value = "fldDesiredDate", required = true) Date fldDesiredDate,
			@RequestParam(value = "slProyecto", required = true) String slProyecto,
			@RequestParam(value = "slOficina", required = true) String slOficina,
			@RequestParam(value = "slDocumento", required = true) Long slDocumento,
			@RequestParam(value = "fldDescripcion", required = true) String fldDescripcion,
			@RequestParam(value = "fldDiasRespuesta", required = true) Integer fldDiasRespuesta,
			@RequestParam(value = "slAreaSolicitanteLabel", required = true) String slAreaSolicitanteLabel,
			@RequestParam(value = "slTipoServicioLabel", required = true) String slTipoServicioLabel,
			@RequestParam(value = "slOficinaLabel", required = true) String slOficinaLabel,
			@RequestParam(value = "purposeVisitVL", required = true) String purposeVisitVL,
			@RequestParam(value = "purposeVisitVISAS", required = true) String purposeVisitVISAS,
			@RequestParam(value = "draftCopyDiagramVED", required = true) String draftCopyDiagramVED,
			@RequestParam(value = "formProjectVED", required = true) String formProjectVED,
			@RequestParam(value = "observationsVEPI", required = true) String observationsVEPI,
			@RequestParam(value = "draftCopyPlanVEPI", required = true) String draftCopyPlanVEPI,
			@RequestParam(value = "formProjectVEPI", required = true) String formProjectVEPI,
			@RequestParam(value = "observationsVRCC", required = true) String observationsVRCC,
			@RequestParam(value = "checkListVRCC", required = true) String checkListVRCC,
			@RequestParam(value = "formProjectVRCC", required = true) String formProjectVRCC,
			@RequestParam(value = "questionVPT", required = true) String questionVPT,
			@RequestParam(value = "observationsVSA", required = true) String observationsVSA,
			@RequestParam(value = "formProjectVSA", required = true) String formProjectVSA,
			@RequestParam(value = "productInformationVSP", required = true) String productInformationVSP,
			@RequestParam(value = "observationsISED", required = true) String observationsISED,
			@RequestParam(value = "draftCopyPlanISED", required = true) String draftCopyPlanISED,
			@RequestParam(value = "observationsISRC", required = true) String observationsISRC,
			@RequestParam(value = "attachmentsISRC", required = true) String attachmentsISRC,
			@RequestParam(value = "apparatusTraceISSM", required = true) String apparatusTraceISSM,
			@RequestParam(value = "observationsISSM", required = true) String observationsISSM,
			@RequestParam(value = "questionISPT", required = true) String questionISPT,
			@RequestParam(value = "ticketISRPR", required = true) String ticketISRPR,
			@RequestParam(value = "modelPartISRPR", required = true) String modelPartISRPR,
			@RequestParam(value = "observationsISRPR", required = true) String observationsISRPR,
			@RequestParam(value = "productInformationISSPC", required = true) String productInformationISSPC,
			@RequestParam(value = "positionPGCAS", required = true) String positionPGCAS,
			@RequestParam(value = "collaboratorPGCAS", required = true) String collaboratorPGCAS,
			@RequestParam(value = "justificationPGCAS", required = true) String justificationPGCAS,
			@RequestParam(value = "salaryPGCAS", required = true) String salaryPGCAS,
			@RequestParam(value = "positionPGCCP", required = true) String positionPGCCP,
			@RequestParam(value = "commentsPGCCP", required = true) String commentsPGCCP,
			@RequestParam(value = "developmentPlanPGCCP", required = true) String developmentPlanPGCCP,
			@RequestParam(value = "targetPGCCP", required = true) String targetPGCCP,
			@RequestParam(value = "salaryPGCCP", required = true) String salaryPGCCP,
			@RequestParam(value = "positionPGCNC", required = true) String positionPGCNC,
			@RequestParam(value = "developmentPlanPGCNC", required = true) String developmentPlanPGCNC,
			@RequestParam(value = "targetPGCNC", required = true) String targetPGCNC,
			@RequestParam(value = "salaryPGCNC", required = true) String salaryPGCNC,
			@RequestParam(value = "justificationPGCNC", required = true) String justificationPGCNC,
			@RequestParam(value = "positionPGCF", required = true) String positionPGCF,
			@RequestParam(value = "collaboratorPGCF", required = true) String collaboratorPGCF,
			@RequestParam(value = "justificationPGCF", required = true) String justificationPGCF,
			@RequestParam(value = "positionPGCAA", required = true) String positionPGCAA,
			@RequestParam(value = "collaboratorPGCAA", required = true) String collaboratorPGCAA,
			@RequestParam(value = "justificationPGCAA", required = true) String justificationPGCAA,
			@RequestParam(value = "requisitionFormatGRC", required = true) String requisitionFormatGRC,
			@RequestParam(value = "linkDocumentGM", required = true) String linkDocumentGM,
			@RequestParam(value = "suggestionGSM", required = true) String suggestionGSM,
			@RequestParam(value = "documentCodeGSM", required = true) String documentCodeGSM,
			@RequestParam(value = "justificationGSM", required = true) String justificationGSM,
			@RequestParam(value = "problemDescriptionGPTR", required = true) String problemDescriptionGPTR	
			
			) {


		RespuestaJsonBean response = new RespuestaJsonBean();

		try {

			InternalTicketBean ticket = new InternalTicketBean();

			DeliverableTraceBean deliverableTrace = new DeliverableTraceBean();
			deliverableTrace.setDeliverableId(slDocumento);

			ticket.setTicketNumber(fldFolio); 
			ticket.setCreated(fldFechaRegsitro);
			ticket.setApplicantAreaId(slAreaSolicitante);
			ticket.setServiceTypeId(slTipoServicio); 
			ticket.setDescription(fldDescripcion);
			ticket.setReponseInTime(fldDiasRespuesta);
			ticket.setDueDate(fldLimite);
			ticket.setDesiredDate(fldDesiredDate);
			ticket.setProject(slProyecto);
			ticket.setOfficeId(slOficina);
			ticket.setDeliverableTrace(deliverableTrace);
			ticket.setApplicantUserId(Long.valueOf(userSession.getUser().getBlackstarUserId()));
			ticket.setCreatedUserId(Long.valueOf(userSession.getUser().getBlackstarUserId()));
			ticket.setCreatedUserName(userSession.getUser().getUserName());
			ticket.setCreatedUserEmail(userSession.getUser().getUserEmail());

			ticket.setPetitionerArea(slAreaSolicitanteLabel);
			ticket.setServiceTypeDescr(slTipoServicioLabel);
			ticket.setOfficeName(slOficinaLabel);

			ticket.setPurposeVisitVL(purposeVisitVL);
			ticket.setPurposeVisitVISAS(purposeVisitVISAS);
			ticket.setDraftCopyDiagramVED(draftCopyDiagramVED);
			ticket.setFormProjectVED(formProjectVED);
			ticket.setObservationsVEPI(observationsVEPI);
			ticket.setDraftCopyPlanVEPI(draftCopyPlanVEPI);
			ticket.setFormProjectVEPI(formProjectVEPI);
			ticket.setObservationsVRCC(observationsVRCC);
			ticket.setCheckListVRCC(checkListVRCC);
			ticket.setFormProjectVRCC(formProjectVRCC);
			ticket.setQuestionVPT(questionVPT);
			ticket.setObservationsVSA(observationsVSA);
			ticket.setFormProjectVSA(formProjectVSA);
			ticket.setProductInformationVSP(productInformationVSP);
			ticket.setObservationsISED(observationsISED);
			ticket.setDraftCopyPlanISED(draftCopyPlanISED);
			ticket.setObservationsISRC(observationsISRC);
			ticket.setAttachmentsISRC(attachmentsISRC);
			ticket.setApparatusTraceISSM(apparatusTraceISSM);
			ticket.setObservationsISSM(observationsISSM);
			ticket.setQuestionISPT(questionISPT);
			ticket.setTicketISRPR(ticketISRPR);
			ticket.setModelPartISRPR(modelPartISRPR);
			ticket.setObservationsISRPR(observationsISRPR);
			ticket.setProductInformationISSPC(productInformationISSPC);
			ticket.setPositionPGCAS(positionPGCAS);
			ticket.setCollaboratorPGCAS(collaboratorPGCAS);
			ticket.setJustificationPGCAS(justificationPGCAS);
			ticket.setSalaryPGCAS(salaryPGCAS);
			ticket.setPositionPGCCP(positionPGCCP);
			ticket.setCommentsPGCCP(commentsPGCCP);
			ticket.setDevelopmentPlanPGCCP(developmentPlanPGCCP);
			ticket.setTargetPGCCP(targetPGCCP);
			ticket.setSalaryPGCCP(salaryPGCCP);
			ticket.setPositionPGCNC(positionPGCNC);
			ticket.setDevelopmentPlanPGCNC(developmentPlanPGCNC);
			ticket.setTargetPGCNC(targetPGCNC);
			ticket.setSalaryPGCNC(salaryPGCNC);
			ticket.setJustificationPGCNC(justificationPGCNC);
			ticket.setPositionPGCF(positionPGCF);
			ticket.setCollaboratorPGCF(collaboratorPGCF);
			ticket.setJustificationPGCF(justificationPGCF);
			ticket.setPositionPGCAA(positionPGCAA);
			ticket.setCollaboratorPGCAA(collaboratorPGCAA);
			ticket.setJustificationPGCAA(justificationPGCAA);
			ticket.setRequisitionFormatGRC(requisitionFormatGRC);
			ticket.setLinkDocumentGM(linkDocumentGM);
			ticket.setSuggestionGSM(suggestionGSM);
			ticket.setDocumentCodeGSM(documentCodeGSM);
			ticket.setJustificationGSM(justificationGSM);
			ticket.setProblemDescriptionGPTR(problemDescriptionGPTR);

			internalTicketsService.validarNuevoTicket(ticket);

			internalTicketsService.registrarNuevoTicket(ticket);

			response.setEstatus("ok");
			response.setMensaje("La requisici&oacute;n se guard&oacute; con &eacute;xito");

		} catch (ServiceException se) {
			response.setEstatus("error");
			response.setMensaje(se.getMessage());
			Logger.Log(LogLevel.ERROR, se.getMessage(), se);
		} catch (Exception e) {
			response.setEstatus("error");
			response.setMensaje("Error al guardar atenci&oacute;n");
			Logger.Log(LogLevel.ERROR, e.getMessage(), e);
		}

		return response;

	}
	

	@RequestMapping(value = "/bloomTicketPage/show.do", method = RequestMethod.GET)
	public String bloomTicketPage(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {


		return "bloom/bloomTicketPage";
	}


}