package com.bloom.services;

import java.util.List;

import com.blackstar.services.AbstractService;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.db.dao.InternalTicketsDao;

public class InternalTicketsServiceImpl extends AbstractService implements
	InternalTicketsService {

	private InternalTicketsDao internalTicketsDao;

	public void setInternalTicketsDao(InternalTicketsDao dao) {
		this.internalTicketsDao = dao;
	}
	
	
	@Override
	public List<InternalTicketBean> getPendingTickets(){
		List<InternalTicketBean> listaTickets = internalTicketsDao.getPendingTickets();
		return listaTickets;
	}
	

}
