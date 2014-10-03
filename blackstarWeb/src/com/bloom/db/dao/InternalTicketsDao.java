package com.bloom.db.dao;

import java.util.List;

import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.model.dto.DeliverableFileDTO;
import com.bloom.model.dto.DeliverableTypeDTO;
import com.bloom.model.dto.PendingAppointmentsDTO;
import com.bloom.model.dto.PendingSurveysDTO;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;
import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.bloom.common.bean.DeliverableTraceBean;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.model.dto.DeliverableTypeDTO;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;
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

  public List<TicketDetailDTO> getTicketDetail(Integer ticketId);
  public List<TicketTeamDTO> getTicketTeam(Integer ticketId);
  public void addFollowUp(Integer ticketId, String asignee, String sender, String comment);
  public void addTicketTeam(Integer ticketId, Integer roleId, String userId, String userGroup);
  public List<Followup> getFollowUps(Integer ticketId);
  public List<DeliverableTypeDTO> getDeliverableTypes(Integer ticketTypeId);
  public void addDeliverableTrace(Integer ticketId, Integer deliverableTypeId, String docId, String name);
  public List<User> getAsigneedUser(Integer ticketId);
  public List<User> getResponseUser(Integer ticketId);
  public void closeTicket(Integer ticketId, Integer userId, Integer statusId);
  public Integer getTicketId(String ticketNumber);
  public List<DeliverableFileDTO> getTicketDeliverable(Integer ticketId);
  public List<PendingAppointmentsDTO> getPendingAppointments();
  public List<PendingSurveysDTO> getPendingSurveys();

	/**
	 * guardar deliverable  trace
	 * @param document
	 * @return
	 * @throws DAOException
	 */
	public Long registrarDocumentTrace(DeliverableTraceBean document) throws DAOException;

	
	/**
	 * Historico de tickets para la vista de  "Mesa de Ayuda"
	 * @param fechaIni
	 * @param fechaFin
	 * @param idStatusTicket
	 * @return
	 * @throws DAOException
	 */
	public List<InternalTicketBean> getHistoricalTickets(String startCreationDate, String endCreationDate, Integer idStatusTicket, Integer showHidden, String user) throws DAOException;	

	public Integer userCanAssign(Integer ticketId, String currentUser);
}
