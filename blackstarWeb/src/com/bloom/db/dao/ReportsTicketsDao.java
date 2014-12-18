package com.bloom.db.dao;

import java.util.Date;
import java.util.List;




import org.json.JSONObject;

import com.bloom.common.bean.ReportTicketBean;
import com.bloom.common.exception.DAOException;


public interface ReportsTicketsDao {

	/**
	 * Obtener areas de apoyo con tickes para estadisticas
	 * @param startCreation
	 * @param endCreation
	 * @return
	 * @throws DAOException
	 */
	public List<JSONObject> getStatisticsByAreaSupport(Date startCreation, Date endCreation) throws DAOException;

	/**
	 * estadisticas de tickes en tiempo de atencion
	 * @param startCreation
	 * @param endCreation
	 * @return
	 * @throws DAOException
	 */
	public List<ReportTicketBean> getStatisticsByHelpDesk(String startCreation, String endCreation) throws DAOException;

	/**
	 * porcentaje tickets cerrados en tiempo
	 * @param startCreation
	 * @param endCreation
	 * @return
	 * @throws DAOException
	 */
	public List<ReportTicketBean> getPercentageTimeClosedTickets(String startCreation, String endCreation)
			throws DAOException;

	/**
	 * porcentaje de tickes evaluados
	 * @param startCreation
	 * @param endCreation
	 * @return
	 * @throws DAOException
	 */
	public List<ReportTicketBean> getPercentageEvaluationTickets(String startCreation, String endCreation)
			throws DAOException;

	/**
	 * numero de tickets por area
	 * @param startCreation
	 * @param endCreation
	 * @return
	 * @throws DAOException
	 */
	public List<ReportTicketBean> getNumberTicketsByArea(String startCreation, String endCreation) throws DAOException;

	/**
	 * Tickets insatisfactorios de ingenieria de servicio
	 * @param startCreation
	 * @param endCreation
	 * @return
	 * @throws DAOException
	 */
	public List<JSONObject> getUnsatisfactoryTicketsByUserEngineeringService(Date startDate, Date endDate)
			throws DAOException;
	
	
}
