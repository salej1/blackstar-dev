package com.blackstar.web.controller;

import java.text.SimpleDateFormat;
import java.util.Date;

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
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/serviceOrders")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class ServiceOrdersController extends AbstractController{
	
	private ServiceOrderService service;
	private SimpleDateFormat sdf = new SimpleDateFormat(Globals.DATE_FORMAT_PATTERN);

	public void setService(ServiceOrderService service) {
		this.service = service;
	}
	
	// Listado de ordenes de servicio por perfil
	@RequestMapping(value = "/show.do", method = RequestMethod.GET)
	public String show(ModelMap model, HttpServletRequest req,
			HttpServletResponse resp) {
		
		// Solo se invoca serviceOrders.jsp
		// La pagina contiene llamadas ajax que cargan el contenido segun el usuario
		return "serviceOrders";
	}
	
	//================================================================================
    //  CALL CENTER Y COORDINADORAS
    //================================================================================

	// Invocan metodos del DashboardController
	
	//================================================================================
    //  INGENIEROS DE SERVICIO
    //================================================================================

	@RequestMapping(value = "/serviceOrdersHistoryJson.do", method = RequestMethod.GET)
	public @ResponseBody String ServiceOrdersHistoryJson(@RequestParam(required = true) Date startDate, @RequestParam(required = true) Date endDate, ModelMap model) {
		String retVal;
		
		try {
			retVal = service.getServiceOrderHistory(startDate, endDate);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
	
	@RequestMapping(value = "/getEquipmentByTypeJson.do", method = RequestMethod.GET)
	public @ResponseBody String getEquipmentByType(
		@RequestParam(required = true) String type,
		ModelMap model) {
			String retVal;
			try {
				retVal = service.getEquipmentByType(type);
			} catch (Exception e) {
				Logger.Log(LogLevel.ERROR,
						e.getStackTrace()[0].toString(), e);
				e.printStackTrace();
				return "error";
			}
			return retVal;
	}

	@RequestMapping(value = "/limitedServiceOrdersHistoryJson.do", method = RequestMethod.GET)
	public @ResponseBody String limitedServiceOrdersHistoryJson(@RequestParam(required = true) Date startDate, @RequestParam(required = true) Date endDate, 
			ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {
		String retVal;
		
		try {
			retVal = service.getLimitedServiceOrdersHistoryJson(startDate, endDate, userSession.getUser().getUserEmail());
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
	

	@RequestMapping(value = "/checkSoExistance.do", method = RequestMethod.GET)
	public @ResponseBody String checkSoExistance(ModelMap model, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession, @RequestParam(required = true) String soNumber) {
		String retVal;
		try {
			OrderserviceDTO checkSo = service.getServiceOrderByIdOrNumber(0, soNumber);
			if(checkSo == null){
				retVal = "{\"exists\":\"false\"}";
			}
			else{
				retVal = "{\"exists\":\"true\"}";
			}
		} catch (Exception e) {
			retVal = "{\"exists\":\"false\"}";
		}
		return retVal;
	}
	
	@RequestMapping(value = "/getServiceOrderListJson.do", method = RequestMethod.GET)
	public @ResponseBody String ServiceOrdersHistoryJson(ModelMap model, @RequestParam(required = true) Date startDate) {
		String retVal;
		try {
			retVal = service.getServiceOrdersByDate(startDate);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR,
					e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			return "error";
		}
		return retVal;
	}
}
