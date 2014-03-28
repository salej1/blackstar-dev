package com.bloom.services;

import java.util.List;

import com.blackstar.services.AbstractService;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.exception.DAOException;
import com.bloom.common.exception.ServiceException;
import com.bloom.db.dao.InternalTicketsDao;

public class InternalTicketsServiceImpl extends AbstractService implements
	InternalTicketsService {

	private InternalTicketsDao internalTicketsDao;
	
	
    @Override
    public List<InternalTicketBean> getPendingTickets(Long userId) throws ServiceException {
    	
        try {
        	return getInternalTicketsDao().getPendingTickets(userId);
            
        } catch (DAOException e) {
            
        	//LOGGER.error(ERROR_CONSULTA_CAT, e);
            
            throw new ServiceException("Error al obtener tickets", e);
        }
    }
	
	
	
	
	/**
	 * @return the internalTicketsDao
	 */
	public InternalTicketsDao getInternalTicketsDao() {
		return internalTicketsDao;
	}



	/**
	 * @param internalTicketsDao the internalTicketsDao to set
	 */
	public void setInternalTicketsDao(InternalTicketsDao internalTicketsDao) {
		this.internalTicketsDao = internalTicketsDao;
	}




	
	

}
