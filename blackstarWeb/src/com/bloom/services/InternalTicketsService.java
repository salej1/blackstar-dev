package com.bloom.services;

import java.util.List;

import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.model.dto.DeliverableTypeDTO;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;
import com.bloom.common.exception.ServiceException;


public interface InternalTicketsService {

	public List<InternalTicketBean> getPendingTickets();
	public TicketDetailDTO getTicketDetail(Integer ticketId);
	public List<TicketTeamDTO> getTicketTeam(Integer ticketId);
	public void addFollow(Integer ticketId, Integer userId, String comment);
	public void addTicketTeam(Integer ticketId, Integer roleId, Integer userId);
	public List<Followup> getFollowUps(Integer ticketId);
	public List<DeliverableTypeDTO> getDeliverableTypes();
	public void addDeliverableTrace(Integer ticketId, Integer deliverableTypeId);
	public User getAsigneed(Integer ticketId);
	public User getResponseUser(Integer ticketId);
	public void sendNotification(Integer fromUserId, Integer toUserId , Integer ticketId, String detail);
	public void closeTicket(Integer ticketId, Integer userId);
	public List<InternalTicketBean> getPendingTickets(Long userId) throws ServiceException;	

	public List<InternalTicketBean> getTickets(Long userId) throws ServiceException;

	public void registrarNuevoTicket(InternalTicketBean ticket) throws ServiceException;

	public String generarTicketNumber() throws ServiceException;

	public void validarNuevoTicket(InternalTicketBean ticket) throws ServiceException;
	public Integer getTicketId(String ticketNumber);
	public List<InternalTicketBean> getHistoricalTickets(String fechaIni, String fechaFin, Integer idStatusTicket, Long idResponsable) throws ServiceException;
	

}