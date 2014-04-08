package com.bloom.db.dao;

import java.util.List;

import com.bloom.common.bean.DeliverableTraceBean;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.bean.TicketTeamBean;
import com.bloom.common.exception.DAOException;

public interface InternalTicketsDao {

	/**
	 * Obtener tickets pendientes
	 * 
	 * @param userId
	 * @return
	 * @throws DAOException
	 */
	public List<InternalTicketBean> getPendingTickets(Long userId)
			throws DAOException;

	/**
	 * registrar nuevo ticket
	 * 
	 * @param ticket
	 * @return
	 * @throws DAOException
	 */
	public Long registrarNuevoTicket(InternalTicketBean ticket)
			throws DAOException;

	/**
	 * generar numero de ticket
	 * 
	 * @return
	 * @throws DAOException
	 */
	public String generarTicketNumber() throws DAOException;

	/**
	 * Vista de los tickes que puede ver un coordiandor.
	 * 
	 * @param userId
	 * @return
	 * @throws DAOException
	 */
	public List<InternalTicketBean> getTickets(Long userId) throws DAOException;
	
	
	
	/**
	 * Guardar miembro del tickets
	 * @param teamMember
	 * @return
	 * @throws DAOException
	 */
	public Long registrarMiembroTicket(TicketTeamBean teamMember) throws DAOException;
	
	
	/**
	 * guardar deliverable  trace
	 * @param document
	 * @return
	 * @throws DAOException
	 */
	public Long registrarDocumentTrace(DeliverableTraceBean document) throws DAOException;


}
