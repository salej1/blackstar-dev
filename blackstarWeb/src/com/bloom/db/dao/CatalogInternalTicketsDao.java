package com.bloom.db.dao;

import java.util.List;




import com.bloom.common.bean.CatalogoBean;
import com.bloom.common.exception.DAOException;

public interface CatalogInternalTicketsDao {

	/**
	 * Catalogo proyectos.
	 * @return
	 * @throws DAOException
	 */
	public List<CatalogoBean<String>> consultarProjectos() throws DAOException;

	/**
	 * Area solocitante
	 * @return
	 * @throws DAOException
	 */
	public List<CatalogoBean<Integer>> consultarAreaSolicitante() throws DAOException;


	/**
	 * Tipos de servicio
	 * @return
	 * @throws DAOException
	 */
	public List<CatalogoBean<Integer>> consultarTipoServicio() throws DAOException;

	/**
	 * Oficinas
	 * @return
	 * @throws DAOException
	 */
	public List<CatalogoBean<Integer>> consultarOficinas() throws DAOException;	


	/**
	 * Consultar documentos por servicio.
	 * @param tipoServicio
	 * @return
	 * @throws DAOException
	 */
	public List<CatalogoBean<Integer>> consultarDocumentosPorServicio(int tipoServicio) throws DAOException;


	/**
	 * Obtiene usuarios por grupo para bloom
	 * @return
	 * @throws DAOException
	 */
	public List<CatalogoBean<Integer>> getEmployeesByGroup(String group) throws DAOException;

	/**
	 * Estatus de tickets
	 * @return
	 * @throws DAOException
	 */
	public List<CatalogoBean<Integer>> consultarEstatusTicket() throws DAOException;
	
}
