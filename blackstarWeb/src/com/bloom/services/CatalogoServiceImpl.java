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
public class CatalogoServiceImpl implements CatalogoService {

    private static final String ERROR_CONSULTA_CAT =
            "Error al consultar el catalogo";
    
    
    
    private CatalogInternalTicketsDao catalogInternalTicketsDao;



	@Override
    public List<CatalogoBean<String>> consultarProjectos()
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
