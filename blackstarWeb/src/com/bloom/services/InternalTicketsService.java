package com.bloom.services;

import java.util.List;

import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.model.dto.DeliverableFileDTO;
import com.bloom.model.dto.DeliverableTypeDTO;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;
import com.bloom.common.exception.ServiceException;


public interface InternalTicketsService {

	public TicketDetailDTO getTicketDetail(Integer ticketId);
	public TicketDetailDTO getTicketDetail(Integer ticketId, String user);
	public List<TicketTeamDTO> getTicketTeam(Integer ticketId);
	public void addFollowUp(Integer ticketId, String asignee, String sender, String comment);
	public void addTicketTeam(Integer ticketId, Integer roleId, String userId, String userGroup);
	public List<Followup> getFollowUps(Integer ticketId);
	public List<DeliverableTypeDTO> getDeliverableTypes(Integer ticketTypeId);
	public void addDeliverableTrace(Integer ticketId, Integer deliverableTypeId, String docId, String name);
	public User getAsigneed(Integer ticketId);
	public User getResponseUser(Integer ticketId);
	public void sendNotification(String from, String to , Integer ticketId, String detail, String fromName);
	public void closeTicket(Integer ticketId, Integer userId, Integer statusId, String sender);
	public List<InternalTicketBean> getPendingTickets(Long userId) throws ServiceException;	
	public List<DeliverableFileDTO> getTicketDeliverable(Integer ticketId);
	
	public List<InternalTicketBean> getTickets(Long userId) throws ServiceException;

	public void registrarNuevoTicket(InternalTicketBean ticket) throws ServiceException;

	public String generarTicketNumber() throws ServiceException;

	public void validarNuevoTicket(InternalTicketBean ticket) throws ServiceException;
	public Integer getTicketId(String ticketNumber);
	public void sendPendingAppointments();
	public List<InternalTicketBean> getHistoricalTickets(String startCreationDateTicket, String endCreationDateTicket, Integer idStatusTicket, Integer showHidden, String user) throws ServiceException;
	public void sendPendingSurveys();

}