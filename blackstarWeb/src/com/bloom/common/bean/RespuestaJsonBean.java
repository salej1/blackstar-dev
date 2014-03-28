package com.bloom.common.bean;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Bean que representa una respuesta Json.
 *
 * @author Oscar.Martinez
 * @version 1.0.0, 12/03/2014
 */
public class RespuestaJsonBean {

    private String estatus = "";
    private String mensaje = "";
    private String mensajeAlterno = "";
    private String json = "";
    private List<?> lista = null;
    private HashMap<?, ?> listaMap = null;
    private HashMap<?, ?> listaMap2 = null;
    private Object dto;
    private Map<String, Object> datos = null;

    public String getEstatus() {
        return estatus;
    }

    public void setEstatus(String estatus) {
        this.estatus = estatus;
    }

    public String getJson() {
        return json;
    }

    public void setJson(String json) {
        this.json = json;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<?> getLista() {
        return lista;
    }

    public void setLista(List<?> lista) {
        this.lista = lista;
    }

    /**
     * @return the dto
     */
    public Object getDto() {
        return dto;
    }

    /**
     * @param dto the dto to set
     */
    public void setDto(Object dto) {
        this.dto = dto;
    }

    /**
     * @return the mensajeAlterno
     */
    public String getMensajeAlterno() {
        return mensajeAlterno;
    }

    /**
     * @param mensajeAlterno the mensajeAlterno to set
     */
    public void setMensajeAlterno(String mensajeAlterno) {
        this.mensajeAlterno = mensajeAlterno;
    }

    /**
     * @return the datos
     */
    public Map<String, Object> getDatos() {
        return datos;
    }

    /**
     * @param datos the datos to set
     */
    public void setDatos(Map<String, Object> datos) {
        this.datos = datos;
    }

	/**
	 * @return the listaMap
	 */
	public HashMap<?, ?> getListaMap() {
		return listaMap;
	}

	/**
	 * @param listaMap the listaMap to set
	 */
	public void setListaMap(HashMap<?, ?> listaMap) {
		this.listaMap = listaMap;
	}

	/**
	 * @return the listaMap2
	 */
	public HashMap<?, ?> getListaMap2() {
		return listaMap2;
	}

	/**
	 * @param listaMap2 the listaMap2 to set
	 */
	public void setListaMap2(HashMap<?, ?> listaMap2) {
		this.listaMap2 = listaMap2;
	}
}
