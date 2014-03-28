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
public interface CatalogoService {
    
	/**
	 * Consulta proyectos para la pantalla
	 * @return
	 * @throws ServiceException
	 */
	public List<CatalogoBean<String>> consultarProjectos()
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

}
