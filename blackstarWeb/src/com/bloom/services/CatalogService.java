/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.bloom.services;

import com.bloom.common.bean.CatalogoBean;
import com.bloom.common.exception.ServiceException;

import java.util.List;

/**
 * Capa de servicio de catalogos.
 *
 * @author oscar.martinez
 */
public interface CatalogService {
    
	/**
	 * Consulta proyectos para la pantalla
	 * @return
	 * @throws ServiceException
	 */
	public List<CatalogoBean<String>> consultarProyectos()
            throws ServiceException;
	
	
	/**
	 * Consulta oficinas
	 * @return
	 * @throws ServiceException
	 */
    public List<CatalogoBean<Integer>> consultarOficinas()
            throws ServiceException;
    
    
    /**
     * Consulta tipo de servicios
     * @return
     * @throws ServiceException
     */
    public List<CatalogoBean<Integer>> consultarTipoServicio()
            throws ServiceException;
    
    
    /***
     * Consulta area solicitante.
     * @return
     * @throws ServiceException
     */
    public List<CatalogoBean<Integer>> consultarAreaSolicitante()
            throws ServiceException;    
    
    
    /**
     * Consultar documentos por id tipo de servicio
     * @param idTipoServicio
     * @return
     * @throws ServiceException
     */
    public List<CatalogoBean<Integer>> consultarDocumentosPorServicio(int idTipoServicio)
            throws ServiceException;    
    
    
    
	/**
	 * usuarios por grupo
	 * @param grupo
	 * @return
	 * @throws ServiceException
	 */
    public List<CatalogoBean<Integer>> empleadosPorGrupo(String grupo)
            throws ServiceException;
    
    
    /**
     * Estatus tickets internos
     * @return
     * @throws ServiceException
     */
    public List<CatalogoBean<Integer>> consultarEstatusTicket()
            throws ServiceException;


}
