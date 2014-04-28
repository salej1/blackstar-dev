package com.bloom.services;

import java.util.List;

import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.exception.ServiceException;

public interface InternalTicketsService {
	
	public List<InternalTicketBean> getPendingTickets(Long userId) throws ServiceException;	
	
	public List<InternalTicketBean> getTickets(Long userId) throws ServiceException;
	
	public void registrarNuevoTicket(InternalTicketBean ticket) throws ServiceException;
	
	public String generarTicketNumber() throws ServiceException;
	
	public void validarNuevoTicket(InternalTicketBean ticket) throws ServiceException;
	
	public List<InternalTicketBean> getHistoricalTickets(String fechaIni, String fechaFin, Integer idStatusTicket, Long idResponsable) throws ServiceException;
	
}
