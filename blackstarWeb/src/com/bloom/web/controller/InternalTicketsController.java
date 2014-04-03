package com.bloom.web.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.services.interfaces.UserDomainService;
import com.blackstar.web.AbstractController;
import com.bloom.common.bean.RespuestaJsonBean;
import com.bloom.model.dto.TicketDetailDTO;
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
  private UserDomainService udService = null;
	
  public void setUdService(UserDomainService udService) {
	this.udService = udService;
  }

  public void setInternalTicketsService(
	InternalTicketsService internalTicketsService) {
	this.internalTicketsService = internalTicketsService;
  }

  @RequestMapping(value = "/generarUnidadesCliente.htm", method = RequestMethod.POST, produces = "application/json")
  public @ResponseBody RespuestaJsonBean generarUnidadesCliente(HttpServletRequest request 
		 , Map<String, Object> model, @RequestParam(value = "idCliente") Long idCliente) {
		return new RespuestaJsonBean();
  }
	
  @RequestMapping(value = "/ticketDetail/show.do", method = RequestMethod.GET)
  public String showDetail(@RequestParam(required = true) Integer ticketId
				                                       , ModelMap model) {
	TicketDetailDTO ticketDetail = null;
	try {
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
	} catch (Exception e) {
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
}
