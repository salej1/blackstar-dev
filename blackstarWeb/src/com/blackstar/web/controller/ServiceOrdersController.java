package com.blackstar.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/serviceOrders")
@SessionAttributes({Globals.SESSION_KEY_PARAM})
public class ServiceOrdersController extends AbstractController{
	
	private ServiceOrderService service;

	public void setService(ServiceOrderService service) {
		this.service = service;
	}
	
	// Listado de ordenes de servicio por perfil
	@RequestMapping(value = "/show.do", method = RequestMethod.GET)
	public String show(ModelMap model, HttpServletRequest req,
			HttpServletResponse resp) {
		
		// Solo se invoca dashboard.jsp
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
	public @ResponseBody String ServiceOrdersHistoryJson(ModelMap model) {
		String retVal;
		try {
			retVal = service.getServiceOrderHistory();
		} catch (Exception ex) {
			Logger.Log(LogLevel.ERROR,
					Thread.currentThread().getStackTrace()[1].toString(), ex);
			ex.printStackTrace();
			return "error";
		}
		return retVal;
	}
}
