package com.bloom.web.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.UserSession;
import com.blackstar.web.AbstractController;
import com.bloom.common.bean.CatalogoBean;
import com.bloom.common.bean.RespuestaJsonBean;
import com.bloom.common.exception.ServiceException;
import com.bloom.services.CatalogService;
import com.bloom.services.InternalTicketsService;

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

	private InternalTicketsService internalTicketsService;
	
	private CatalogService catalogService;

	
	@RequestMapping(value = "/reporteTiempoRespuestaAreaApoyo.do", method = RequestMethod.GET)
	public String reporteTiempoRespuestaAreaApoyo(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		return "bloom/bloomReporteTiempoRespAreaApoyo";
	}	
	

	@RequestMapping(value = "/reporteTiempoRespuestaMesaAyuda.do", method = RequestMethod.GET)
	public String reporteTiempoRespuestaMesaAyuda(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		return "bloom/bloomReporteTiempoRespMesaAyuda";
	}	

	
	@RequestMapping(value = "/reporteTicketsNoSatisfactorios.do", method = RequestMethod.GET)
	public String reporteTicketsNoSatisfactorios(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		return "bloom/bloomReporteTicketsNoSatisfactorios";
	}	

	
	@RequestMapping(value = "/reporteTicketsEvaluacion.do", method = RequestMethod.GET)
	public String reporteTicketsEvaluacion(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		return "bloom/bloomReporteTicketsEvaluacion";
	}	
	
	@RequestMapping(value = "/reporteTicketsCerrados.do", method = RequestMethod.GET)
	public String reporteTicketsCerrados(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		return "bloom/bloomReporteTicketsCerrados";
	}	

	@RequestMapping(value = "/reporteTicketsAreaApoyo.do", method = RequestMethod.GET)
	public String reporteTicketsAreaApoyo(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		return "bloom/bloomReporteTicketsAreaApoyo";
	}	
	
	
	
	@RequestMapping(value = "/getDatosReporteAreaApoyo.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	RespuestaJsonBean getDatosReporteAreaApoyo(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		RespuestaJsonBean respuesta = new RespuestaJsonBean();

		List<CatalogoBean<Integer>> listaEstatusTickets;
		List<CatalogoBean<Integer>> listaAreasApoyo;
		
		List<CatalogoBean<Integer>> inilistaEstatusTickets = new ArrayList<CatalogoBean<Integer>>();
		List<CatalogoBean<Integer>> inilistaAreasApoyo = new ArrayList<CatalogoBean<Integer>>();

		
		CatalogoBean<Integer> todos = new CatalogoBean<Integer>(-1, "Todos");
		inilistaEstatusTickets.add(todos);
		inilistaAreasApoyo.add(todos);
		
		
		HashMap<String, List<CatalogoBean<Integer>>> listaResponse = new HashMap<String, List<CatalogoBean<Integer>>>();

		try {
			
			listaEstatusTickets = catalogService.consultarEstatusTicket();
			listaAreasApoyo=catalogService.consultarAreaSolicitante();
			
			inilistaEstatusTickets.addAll(listaEstatusTickets);
			inilistaAreasApoyo.addAll(listaAreasApoyo);

			listaResponse.put("listaEstatusTickets", inilistaEstatusTickets);
			listaResponse.put("listaAreasApoyo", inilistaAreasApoyo);

			respuesta.setListaMap(listaResponse);
			respuesta.setEstatus("ok");

		} catch (ServiceException se) {
			Logger.Log(LogLevel.ERROR, se.getMessage(), se);
			respuesta.setEstatus("error");
			respuesta.setMensaje(se.getMessage());
		}

		return respuesta;
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
	 * @return the catalogService
	 */
	public CatalogService getCatalogService() {
		return catalogService;
	}


	/**
	 * @param catalogService the catalogService to set
	 */
	public void setCatalogService(CatalogService catalogService) {
		this.catalogService = catalogService;
	}


}
