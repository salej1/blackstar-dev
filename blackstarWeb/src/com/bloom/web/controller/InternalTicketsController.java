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
import com.blackstar.services.interfaces.UserDomainService;
import com.blackstar.web.AbstractController;
import com.bloom.common.bean.RespuestaJsonBean;
import com.bloom.model.dto.TicketDetailDTO;
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
	StringBuilder ticketTeamStr = new StringBuilder();
	List<TicketTeamDTO> ticketTeam = null;
	TicketDetailDTO ticketDetail = null;
	try {
		 ticketTeam = internalTicketsService.getTicketTeam(ticketId);
		 ticketDetail = internalTicketsService.getTicketDetail(ticketId);
		 for(int i = 0; i< ticketTeam.size() ; i++){
			ticketTeamStr.append(ticketTeam.get(i).getBlackstarUserName());
			if(i < (ticketTeam.size() - 1)){
			   ticketTeamStr.append(" / ");
			}
	     }
		 model.addAttribute("ticketDetail", ticketDetail);
		 model.addAttribute("osAttachmentFolder", gdService
				        .getAttachmentFolderId(ticketDetail.getTicketNumber()));
		 model.addAttribute("accessToken", gdService.getAccessToken());
		 model.addAttribute("ticketTeam", ticketTeamStr);
		 model.addAttribute("staff", udService.getStaff());
		 model.addAttribute("followUps", internalTicketsService.getFollowUps(ticketId));
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
				                                    , ModelMap model) {
	try {
		internalTicketsService.addFollow(ticketId, userId, comment);
		internalTicketsService.addTicketTeam(ticketId, 1, userId);
		model.addAttribute("followUps", internalTicketsService.getFollowUps(ticketId));
	} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			model.addAttribute("errorDetails", e.getStackTrace()[0].toString());
			return "error";
	}
	return "bloom/_ticketFollow";
  }
	

}
