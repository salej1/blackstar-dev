package com.bloom.services;

import java.util.List;

import com.blackstar.services.AbstractService;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.db.dao.InternalTicketsDao;

public class InternalTicketsServiceImpl extends AbstractService implements
	InternalTicketsService {

	private InternalTicketsDao internalTicketsDao;


	@Override
	public List<InternalTicketBean> getPendingTickets(){
		List<InternalTicketBean> listaTickets = internalTicketsDao.getPendingTickets();
		return listaTickets;
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
