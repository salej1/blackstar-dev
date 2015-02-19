package com.blackstar.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.common.Utils;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.TicketDTO;
import com.blackstar.services.EmailServiceFactory;
import com.blackstar.services.interfaces.TicketService;
import com.blackstar.web.AbstractController;
import com.blackstar.web.controller.AddFollowUpController.AssignType;

@Controller
@RequestMapping("/ticketCapture")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class TicketController extends AbstractController {
	TicketService service;
	
	public void setService(TicketService service) {
		this.service = service;
	}

	@RequestMapping(value = "/show.do", method = RequestMethod.GET)
	public String show(@ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession,
			ModelMap model, HttpServletRequest req, HttpServletResponse resp) throws Exception{	
		try{
			if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CUSTOMER) != null && userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CUSTOMER) == true){
				model.addAttribute("equipmentList", service.getEquipmentList(userSession.getUser().getUserEmail()));				
			}
			else if(userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CALL_CENTER) != null && userSession.getUser().getBelongsToGroup().get(Globals.GROUP_CALL_CENTER) == true){
				model.addAttribute("equipmentList", service.getEquipmentList());
			}
			else{
				throw new Exception("El usuario no tiene permisos para esta funcion del portal");
			}
			
			TicketDTO ticket = new TicketDTO();
			ticket.setCreated(Globals.getLocalTime());
			ticket.setUser(userSession.getUser().getUserEmail());
			
			model.addAttribute("ticket", ticket);
			return "ticketCapture";
		}
		catch(Exception e){
			 e.printStackTrace();
			 Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			 model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
			 return "error";
		}
		
	}
	
	@RequestMapping(value = "/getSupportInfo.do", method = RequestMethod.GET)
	public @ResponseBody String getSupportInfo(@RequestParam(required = true) Integer policyId,
			@ModelAttribute(Globals.SESSION_KEY_PARAM)  UserSession userSession,
			ModelMap model, HttpServletRequest req, HttpServletResponse resp) throws Exception{
		
		try{
			String policyData = service.getPolicyData(policyId);
			return policyData;
			
		}
		catch(Exception e){
			 e.printStackTrace();
			 Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			 model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
			 return "error";
		}
	}
	
	@RequestMapping(value = "/save.do", method = RequestMethod.POST)
	public @ResponseBody String save(@ModelAttribute("ticket") TicketDTO ticket,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession,
			ModelMap model, HttpServletRequest req, HttpServletResponse resp) throws Exception{
		
		try{
			Integer tickId = service.saveTicket(ticket, userSession.getUser().getUserEmail(), "TicketController");
			
			// Refresh
			TicketDTO tickrefresh = service.getTicketById(tickId);
			
			// send email
			SendNotificationEmail(tickrefresh);
			return tickrefresh.getTicketNumber();
		}
		catch(Exception e){
			 e.printStackTrace();
			 Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			 model.addAttribute("errorDetails", e.getMessage() + " - " + e.getStackTrace()[0].toString());
			 resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			 return "error";
		}
	}
	
	private void SendNotificationEmail(TicketDTO ticket){
		String link = "Link no disponible";
		StringBuilder bodySb = new StringBuilder();
		
		link = String.format("<a href='" + Globals.GOOGLE_CONTEXT_URL + "/ticketDetail?ticketId=%s'>%s</a>", ticket.getTicketId(), ticket.getTicketNumber());
				
		String subject = "Reporte de Emergencia " + ticket.getTicketNumber();
		
		bodySb.append("<style>.what{font-weight:bold; width:250px; display: inline-block;}div{margin:5px;}</style>");
		bodySb.append("<img src='" + Globals.GPOSAC_LOGO_DEFAULT_URL + "'>");
		bodySb.append("<div style='font-family:sans-serif;margin-left:50px;font-size:0.8em'>");
		bodySb.append("<h3 >Reporte de emergencia " + ticket.getTicketNumber() + "</h3>");
		bodySb.append("<div><span class='what'>Usuario: </span>" + ticket.getUser() + "</div>");
		bodySb.append("<div><span class='what'>Fecha y hora recepci�n: </span>" + Utils.getDateString(ticket.getCreated()) + "</div>");
		bodySb.append("<div><span class='what'>Contacto: </span>" + ticket.getContact() + "</div>");
		bodySb.append("<div><span class='what'>Proyecto: </span>" + ticket.getProject() + "</div>");
		bodySb.append("<div><span class='what'>Empresa: </span>" + ticket.getcustomer() + "</div>");
		bodySb.append("<div><span class='what'>Ubicacion del servicio: </span>" + ticket.getEquipmentLocation() + "</div>");
		bodySb.append("<div><span class='what'>Telefono: </span>" + ticket.getContactPhone() + "</div>");
		bodySb.append("<div><span class='what'>Email: </span>" + ticket.getContactEmail() + "</div>");
		bodySb.append("<div><span class='what'>Equipo: </span>" + ticket.getEquipmentType() + "</div>");
		bodySb.append("<div><span class='what'>Modelo: </span>" + ticket.getModel() + "</div>");
		bodySb.append("<div><span class='what'>Capacidad: </span>" + ticket.getCapacity() + "</div>");
		bodySb.append("<div><span class='what'>Marca: </span>" + ticket.getBrand() + "</div>");
		bodySb.append("<div><span class='what'>Numero de Serie: </span>" + ticket.getSerialNumber() + "</div>");
		bodySb.append("<div><span class='what'>Tiempo m�ximo de Respuesta: </span>" + ticket.getResponseTimeHR() + "</div>");
		bodySb.append("<div><span class='what'>Tiempo m�ximo de Soluci�n: </span>" + ticket.getSolutionTimeHR() + "</div>");
		if(ticket.getIncludesParts() > 0){
			bodySb.append("<div><span class='what'>Incluye Partes: </span>SI</div>");
		}
		else{
			bodySb.append("<div><span class='what'>Incluye Partes: </span>NO</div>");
		}
		bodySb.append("<div><span class='what'>Excepci�n de partes: </span>" + ticket.getExceptionParts() + "</div>");
		bodySb.append("<div><span class='what'>Observaciones: </span>" + ticket.getObservations() + "</div>");
		bodySb.append("<div><span class='what'>Centro de Servicio: </span>" + ticket.getServiceCenter() + "</div>");
		bodySb.append("<div><span class='what'>Estado del Contrato: </span>" + ticket.getContractState() + "</div>");
		bodySb.append("<div><span class='what'>Fecha de Vencimiento de Contrato: </span>" + Utils.getDateString(ticket.getEndDate()) + "</div>");
		bodySb.append("<br>");
		bodySb.append("<p><strong>En el siguiente Link podra dar el seguimiento correspondiente</p>");
		bodySb.append(link);
		bodySb.append("</div>");
		bodySb.append("<hr>");
		bodySb.append("<small>Favor de no responder a este email. En caso de duda p�ngase en contacto con su CST</small>");
		// Enviar el email
		
		IEmailService mail = EmailServiceFactory.getEmailService();
		StringBuilder to = new StringBuilder();
		to.append(ticket.getContactEmail());
		to.append(",");
		to.append(Globals.GPOSAC_CALL_CENTER_GROUP);
		to.append(",");
		to.append(ticket.getOfficeEmail());
		if(ticket.getOfficeEmail().compareTo(ticket.getServiceCenterEmail()) != 0){
			to.append(",");
			to.append(ticket.getServiceCenterEmail());
		}
		mail.sendEmail(Globals.GPOSAC_DEFAULT_SENDER, to.toString(), subject, bodySb.toString());
	}
}
