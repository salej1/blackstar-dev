package com.bloom.db.dao;

import java.util.List;

import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.exception.DAOException;

public interface InternalTicketsDao {
	
	/**
	 * Obtener tickets pendientes
	 * @param userId
	 * @return
	 * @throws DAOException
	 */
	public List<InternalTicketBean> getPendingTickets(Long userId) throws DAOException;
	
	
	/**
	 * registrar nuevo ticket
	 * @param ticket
	 * @return
	 * @throws DAOException
	 */
	public Long registrarNuevoTicket(InternalTicketBean ticket) throws DAOException;
}
