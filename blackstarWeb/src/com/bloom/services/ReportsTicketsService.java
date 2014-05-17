package com.bloom.services;

import java.util.List;

import com.bloom.common.bean.ReportTicketBean;
import com.bloom.common.exception.ServiceException;

public interface ReportsTicketsService {

	/**
	 * Estadisticas por areas.
	 * @param startCreationDateTicket
	 * @param endCreationDateTicket
	 * @return
	 * @throws ServiceException
	 */
	public List<ReportTicketBean> getStatisticsByAreaSupport(String startCreationDateTicket, String endCreationDateTicket) throws ServiceException;
	
	/**
	 * Estadisticas de mesa de ayuda.
	 * @param startCreationDateTicket
	 * @param endCreationDateTicket
	 * @return
	 * @throws ServiceException
	 */
	public List<ReportTicketBean> getStatisticsByHelpDesk(String startCreationDateTicket, String endCreationDateTicket) throws ServiceException;	
	
	
	/**
	 * Porcentaje de tickets cerrados en tiempo.
	 * @param startCreationDateTicket
	 * @param endCreationDateTicket
	 * @return
	 * @throws ServiceException
	 */
	public List<ReportTicketBean> getPercentageTimeClosedTickets(String startCreationDateTicket, String endCreationDateTicket) throws ServiceException;
	
	
	/**
	 * porcentaje de tickes evaluados satisfactoriamente.
	 * @param startCreationDateTicket
	 * @param endCreationDateTicket
	 * @return
	 * @throws ServiceException
	 */
	public List<ReportTicketBean> getPercentageEvaluationTickets(String startCreationDateTicket, String endCreationDateTicket) throws ServiceException;
	
	
	/**
	 * numero de tickes por area.
	 * @param startCreationDateTicket
	 * @param endCreationDateTicket
	 * @return
	 * @throws ServiceException
	 */
	public List<ReportTicketBean> getNumberTicketsByArea(String startCreationDateTicket, String endCreationDateTicket) throws ServiceException; 
	
	/**
	 * Tickes insatisfactorios de ingenieria de servicio.
	 * @param startCreationDateTicket
	 * @param endCreationDateTicket
	 * @return
	 * @throws ServiceException
	 */
	public List<ReportTicketBean> getUnsatisfactoryTicketsByUserEngineeringService(String startCreationDateTicket, String endCreationDateTicket) throws ServiceException;	


}