package com.bloom.db.dao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;


import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.bloom.common.bean.CatalogoBean;
import com.bloom.common.exception.DAOException;
import com.bloom.db.dao.mapper.CatalogoMapper;

public class CatalogInternalTicketsDaoImpl extends AbstractDAO implements CatalogInternalTicketsDao {

	
	private static final String QUERY_PROYECTOS = "CALL getBloomProjects()";
	
	private static final String QUERY_AREAS = "CALL getBloomApplicantArea()";
	
	private static final String QUERY_SERVICIOS = "CALL getBloomServiceType()";
	
	private static final String QUERY_OFICINAS = "CALL getBloomOffice()";
	
    private static final String ERROR_CONSULTA_CAT =
            "Error al consultar el cat�logo";
    
    private static final String EMPTY_CONSULTA_CAT =
            "No se encontraron registros";
    
	
    @Override
    public List<CatalogoBean<String>> consultarProjectos() throws DAOException {

        List<CatalogoBean<String>> listaProyectos = new ArrayList<CatalogoBean<String>>();

        try {
        	
        	listaProyectos.addAll(getJdbcTemplate().query(QUERY_PROYECTOS,
                    new CatalogoMapper<String>("id", "label")));

            return listaProyectos;

        } catch (EmptyResultDataAccessException e) {
        	Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA_CAT, e);
            return Collections.emptyList();
        } catch (DataAccessException e) {
        	Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
            throw new DAOException(ERROR_CONSULTA_CAT, e);
        }
    }
	

    @Override
    public List<CatalogoBean<Integer>> consultarAreaSolicitante() throws DAOException {

        List<CatalogoBean<Integer>> listaAreas = new ArrayList<CatalogoBean<Integer>>();

        try {
        	
        	listaAreas.addAll(getJdbcTemplate().query(QUERY_AREAS,
                    new CatalogoMapper<Integer>("id", "label")));

            return listaAreas;

        } catch (EmptyResultDataAccessException e) {
        	Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA_CAT, e);
            return Collections.emptyList();
        } catch (DataAccessException e) {
        	Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
            throw new DAOException(ERROR_CONSULTA_CAT, e);
        }
    }
    
    
    
    @Override
    public List<CatalogoBean<Integer>> consultarTipoServicio() throws DAOException {

        List<CatalogoBean<Integer>> listaServicios = new ArrayList<CatalogoBean<Integer>>();

        try {
        	
        	listaServicios.addAll(getJdbcTemplate().query(QUERY_SERVICIOS,
                    new CatalogoMapper<Integer>("id", "label","responseTime")));

            return listaServicios;

        } catch (EmptyResultDataAccessException e) {
        	Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA_CAT, e);
            return Collections.emptyList();
        } catch (DataAccessException e) {
        	Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
            throw new DAOException(ERROR_CONSULTA_CAT, e);
        }
    }
    

    @Override
    public List<CatalogoBean<Integer>> consultarOficinas() throws DAOException {

        List<CatalogoBean<Integer>> listaOficinas = new ArrayList<CatalogoBean<Integer>>();

        try {
        	
        	listaOficinas.addAll(getJdbcTemplate().query(QUERY_OFICINAS,
                    new CatalogoMapper<Integer>("id", "label")));

            return listaOficinas;

        } catch (EmptyResultDataAccessException e) {
        	Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA_CAT, e);
            return Collections.emptyList();
        } catch (DataAccessException e) {
        	Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
            throw new DAOException(ERROR_CONSULTA_CAT, e);
        }
    }
    
    

}
