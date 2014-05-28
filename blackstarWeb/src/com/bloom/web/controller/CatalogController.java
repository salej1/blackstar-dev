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
import org.springframework.web.bind.annotation.RequestParam;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.UserSession;
import com.blackstar.web.AbstractController;
import com.bloom.common.bean.CatalogoBean;
import com.bloom.common.bean.RespuestaJsonBean;
import com.bloom.common.exception.ServiceException;
import com.bloom.services.CatalogService;

import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Controller principal para el paquete bloom
 * 
 * @author Oscar.Martinez
 */
@Controller
@RequestMapping("/bloomCatalog")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class CatalogController extends AbstractController {

	private CatalogService catalogService;

	@RequestMapping(value = "/getData.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	RespuestaJsonBean getData(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		RespuestaJsonBean respuesta = new RespuestaJsonBean();

		Long userId = (long)userSession.getUser().getBlackstarUserId();
		
		List<CatalogoBean<String>> listaProyectos;

		List<CatalogoBean<Integer>> listaAreas;
		List<CatalogoBean<Integer>> listaServicios;
		List<CatalogoBean<Integer>> listaOficinas;

		HashMap<String, List<CatalogoBean<String>>> listaResponse = new HashMap<String, List<CatalogoBean<String>>>();
		HashMap<String, List<CatalogoBean<Integer>>> listaResponse2 = new HashMap<String, List<CatalogoBean<Integer>>>();

		try {

			listaProyectos = catalogService.consultarProyectos();
			listaAreas = catalogService.consultarAreaSolicitante();
			listaServicios = catalogService.consultarTipoServicio();
			listaOficinas = catalogService.consultarOficinas();

			listaResponse.put("listaProyectos", listaProyectos);

			listaResponse2.put("listaAreas", listaAreas);
			listaResponse2.put("listaServicios", listaServicios);
			listaResponse2.put("listaOficinas", listaOficinas);

			respuesta.setListaMap(listaResponse);
			respuesta.setListaMap2(listaResponse2);
			respuesta.setEstatus("ok");

		} catch (ServiceException se) {
			Logger.Log(LogLevel.ERROR, se.getMessage(), se);
			respuesta.setEstatus("error");
			respuesta.setMensaje(se.getMessage());
		}

		return respuesta;
	}




	@RequestMapping(value = "/getDocumentos.do", method = RequestMethod.POST, produces = "application/json")
	@ResponseBody
	RespuestaJsonBean getDocumentos(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession,
			@RequestParam(value = "idTipoServicio", required = true) final Integer idTipoServicio) {

		RespuestaJsonBean respuesta = new RespuestaJsonBean();


		List<CatalogoBean<Integer>> listaDocumentos;



		try {


			listaDocumentos = catalogService.consultarDocumentosPorServicio(idTipoServicio);
			respuesta.setLista(listaDocumentos);


			respuesta.setEstatus("ok");

		} catch (ServiceException se) {
			Logger.Log(LogLevel.ERROR, se.getMessage(), se);
			respuesta.setEstatus("error");
			respuesta.setMensaje(se.getMessage());
		}

		return respuesta;
	}
	
	@RequestMapping(value = "/getDataHistorico.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	RespuestaJsonBean getDataHistorical(ModelMap model,
			@ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession) {

		RespuestaJsonBean respuesta = new RespuestaJsonBean();

		List<CatalogoBean<Integer>> listaEstatusTickets;
		List<CatalogoBean<Integer>> listaUsuariosMesaAyuda;
		
		List<CatalogoBean<Integer>> inilistaEstatusTickets = new ArrayList<CatalogoBean<Integer>>();
		List<CatalogoBean<Integer>> inilistaUsuariosMesaAyuda = new ArrayList<CatalogoBean<Integer>>();

		
		CatalogoBean<Integer> todos = new CatalogoBean<Integer>(-1, "Todos");
		inilistaEstatusTickets.add(todos);
		inilistaUsuariosMesaAyuda.add(todos);
		
		
		HashMap<String, List<CatalogoBean<Integer>>> listaResponse = new HashMap<String, List<CatalogoBean<Integer>>>();

		try {
			
			listaEstatusTickets = catalogService.consultarEstatusTicket();
			listaUsuariosMesaAyuda=catalogService.empleadosPorGrupo("sysHelpDesk");
			
			inilistaEstatusTickets.addAll(listaEstatusTickets);
			inilistaUsuariosMesaAyuda.addAll(listaUsuariosMesaAyuda);

			listaResponse.put("listaEstatusTickets", inilistaEstatusTickets);
			listaResponse.put("listaUsuariosMesaAyuda", inilistaUsuariosMesaAyuda);

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