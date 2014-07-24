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
	public TicketDetailDTO getTicketDetail(Integer ticketId, Integer userId);
	public List<TicketTeamDTO> getTicketTeam(Integer ticketId);
	public void addFollow(Integer ticketId, Integer userId, String comment);
	public void addTicketTeam(Integer ticketId, Integer roleId, Integer userId);
	public List<Followup> getFollowUps(Integer ticketId);
	public List<DeliverableTypeDTO> getDeliverableTypes(Integer ticketTypeId);
	public void addDeliverableTrace(Integer ticketId, Integer deliverableTypeId, String docId);
	public User getAsigneed(Integer ticketId);
	public User getResponseUser(Integer ticketId);
	public void sendNotification(Integer fromUserId, Integer toUserId , Integer ticketId, String detail);
	public void closeTicket(Integer ticketId, Integer userId, Integer statusId);
	public List<InternalTicketBean> getPendingTickets(Long userId) throws ServiceException;	
	public List<DeliverableFileDTO> getTicketDeliverable(Integer ticketId);
	
	public List<InternalTicketBean> getTickets(Long userId) throws ServiceException;

	public void registrarNuevoTicket(InternalTicketBean ticket) throws ServiceException;

	public String generarTicketNumber() throws ServiceException;

	public void validarNuevoTicket(InternalTicketBean ticket) throws ServiceException;
	public Integer getTicketId(String ticketNumber);
	public void sendPendingAppointments();
	public List<InternalTicketBean> getHistoricalTickets(String startCreationDateTicket, String endCreationDateTicket, Integer idStatusTicket, Integer showHidden) throws ServiceException;
	public void sendPendingSurveys();

}