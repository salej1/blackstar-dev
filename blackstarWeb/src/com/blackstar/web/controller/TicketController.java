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
			 return "{error}";
		}
	}
	
	private void SendNotificationEmail(TicketDTO ticket){
		String link = "Link no disponible";
		StringBuilder bodySb = new StringBuilder();
		
		link = String.format("<a href='" + Globals.GOOGLE_CONTEXT_URL + "/ticketDetail?ticketId=%s'>%s</a>", ticket.getTicketId(), ticket.getTicketNumber());
				
		String subject = "Reporte de Emergencia " + ticket.getTicketNumber();
		
		bodySb.append("<p>Proyecto: " + ticket.getProject() + "</p>");
		bodySb.append("<p>Empresa: " + ticket.getcustomer() + "</p>");
		bodySb.append("<p>Ubicacion del servicio: " + ticket.getEquipmentLocation() + "</p>");
		bodySb.append("<p>Contacto: " + ticket.getContact() + "</p>");
		bodySb.append("<p>Telefono: " + ticket.getContactPhone() + "</p>");
		bodySb.append("<p>Email: " + ticket.getContactEmail() + "</p>");
		bodySb.append("<p>Equipo: " + ticket.getEquipmentType() + "</p>");
		bodySb.append("<p>Modelo: " + ticket.getModel() + "</p>");
		bodySb.append("<p>Capacidad: " + ticket.getCapacity() + "</p>");
		bodySb.append("<p>Marca: " + ticket.getBrand() + "</p>");
		bodySb.append("<p>Numero de Serie: " + ticket.getSerialNumber() + "</p>");
		bodySb.append("<p>Tiempo máxima de Respuesta: " + ticket.getResponseTimeHR() + "</p>");
		bodySb.append("<p>Tiempo máxima de Solución: " + ticket.getSolutionTimeHR() + "</p>");
		if(ticket.getIncludesParts() > 0){
			bodySb.append("<p>Incluye Partes: SI</p>");
		}
		else{
			bodySb.append("<p>Incluye Partes: NO</p>");
		}
		bodySb.append("<p>Observaciones:" + ticket.getObservations() + "</p>");
		bodySb.append("<p>Centro de Servicio:" + ticket.getServiceCenter() + "</p>");
		bodySb.append("<p>Estado del Contrato:" + ticket.getContractState() + "</p>");
		bodySb.append("<p>Fecha de Vencimiento de Contrato:" + ticket.getEndDate() + "</p>");
		bodySb.append("<br>");
		bodySb.append("<p>En el siguiente Link podra dar el seguimiento correspondiente</p>");
		bodySb.append(link);
		bodySb.append("</div>");
		bodySb.append("<hr>");
		bodySb.append("<small>Favor de no responder a este email. En caso de duda póngase en contacto con su CST</small>");
		// Enviar el email
		
		IEmailService mail = EmailServiceFactory.getEmailService();
		String to = ticket.getContactEmail() + "," + Globals.GPOSAC_CALL_CENTER_GROUP;
		mail.sendEmail(Globals.GPOSAC_DEFAULT_SENDER, to, subject, bodySb.toString());
	}
}
