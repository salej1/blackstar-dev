/*
 * 
 * and open the template in the editor.
 */
package com.bloom.services;

import java.util.List;
import org.springframework.stereotype.Service;

import com.bloom.common.bean.CatalogoBean;
import com.bloom.common.exception.DAOException;
import com.bloom.common.exception.ServiceException;
import com.bloom.db.dao.CatalogInternalTicketsDao;

/**
 * Implementaci&oacute;n del componente de servicio para los cat&aacute;logos
 * del sistema bloom.
 *
 * @author oscar.martinez
 */
@Service
public class CatalogServiceImpl implements CatalogService {

    private static final String ERROR_CONSULTA_CAT =
            "Error al consultar el catalogo";
    
    
    
    private CatalogInternalTicketsDao catalogInternalTicketsDao;



	@Override
    public List<CatalogoBean<String>> consultarProyectos()
            throws ServiceException {
        try {
            
        	return getCatalogInternalTicketsDao().consultarProjectos();
            
        } catch (DAOException e) {
            
            throw new ServiceException(ERROR_CONSULTA_CAT, e);
        }
    }
	

	
	@Override
    public List<CatalogoBean<Integer>> consultarOficinas()
            throws ServiceException {
        try {
            
        	return getCatalogInternalTicketsDao().consultarOficinas();
            
        } catch (DAOException e) {
            
            throw new ServiceException(ERROR_CONSULTA_CAT, e);
        }
    }
	

	
	@Override
    public List<CatalogoBean<Integer>> consultarAreaSolicitante()
            throws ServiceException {
        try {
            
        	return getCatalogInternalTicketsDao().consultarAreaSolicitante();
            
        } catch (DAOException e) {
            
            throw new ServiceException(ERROR_CONSULTA_CAT, e);
        }
    }

	
	
	@Override
    public List<CatalogoBean<Integer>> consultarTipoServicio()
            throws ServiceException {
        try {
            
        	return getCatalogInternalTicketsDao().consultarTipoServicio();
            
        } catch (DAOException e) {
            
            throw new ServiceException(ERROR_CONSULTA_CAT, e);
        }
    }


	@Override
    public List<CatalogoBean<Integer>> consultarDocumentosPorServicio(int idTipoServicio)
            throws ServiceException {
        try {
            
        	return getCatalogInternalTicketsDao().consultarDocumentosPorServicio(idTipoServicio);
            
        } catch (DAOException e) {
            
            throw new ServiceException(ERROR_CONSULTA_CAT, e);
        }
    }
	
	
	@Override
    public List<CatalogoBean<Integer>> empleadosPorGrupo(String grupo)
            throws ServiceException {
        try {
            
        	return getCatalogInternalTicketsDao().getEmployeesByGroup(grupo);
            
        } catch (DAOException e) {
            
            throw new ServiceException(ERROR_CONSULTA_CAT, e);
        }
    }
	
	
    /**
	 * @return the catalogInternalTicketsDao
	 */
	public CatalogInternalTicketsDao getCatalogInternalTicketsDao() {
		return catalogInternalTicketsDao;
	}




	/**
	 * @param catalogInternalTicketsDao the catalogInternalTicketsDao to set
	 */
	public void setCatalogInternalTicketsDao(
			CatalogInternalTicketsDao catalogInternalTicketsDao) {
		this.catalogInternalTicketsDao = catalogInternalTicketsDao;
	}	

}
