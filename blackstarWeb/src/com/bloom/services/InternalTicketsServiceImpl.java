package com.bloom.services;

import java.util.List;

import com.blackstar.db.dao.interfaces.UserDAO;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.blackstar.services.AbstractService;
import com.blackstar.services.EmailServiceFactory;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.db.dao.InternalTicketsDao;
import com.bloom.model.dto.DeliverableTypeDTO;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;

public class InternalTicketsServiceImpl extends AbstractService 
                                        implements InternalTicketsService {

  private InternalTicketsDao internalTicketsDao = null;
  private UserDAO uDAO = null;
  
  public void setInternalTicketsDao(InternalTicketsDao internalTicketsDao) {
	this.internalTicketsDao = internalTicketsDao;
  }
  
  public void setuDAO(UserDAO uDAO) {
	this.uDAO = uDAO;
  }
  
  @Override
  public List<InternalTicketBean> getPendingTickets(){
	List<InternalTicketBean> listaTickets = internalTicketsDao.getPendingTickets();
	return listaTickets;
  }
	
  public TicketDetailDTO getTicketDetail(Integer ticketId){
	List<TicketDetailDTO> details = internalTicketsDao.getTicketDetail(ticketId);
	if(details.size() > 0){
		return details.get(0);
	}
	return null;
  }
  
  public List<TicketTeamDTO> getTicketTeam(Integer ticketId){
	return internalTicketsDao.getTicketTeam(ticketId);
  }
  
  public void addFollow(Integer ticketId, Integer userId, String comment){
	internalTicketsDao.addFollow(ticketId, userId, comment);
  }
  
  public void addTicketTeam(Integer ticketId, Integer roleId, Integer userId){
	internalTicketsDao.addTicketTeam(ticketId, roleId, userId);
  }
  
  public List<Followup> getFollowUps(Integer ticketId){
	return internalTicketsDao.getFollowUps(ticketId);
  }
  
  public List<DeliverableTypeDTO> getDeliverableTypes(){
	 return internalTicketsDao.getDeliverableTypes();
  }
  
  public void addDeliverableTrace(Integer ticketId, Integer deliverableTypeId){
	internalTicketsDao.addDeliverableTrace(ticketId, deliverableTypeId);
  }
  
  public User getAsigneed(Integer ticketId){
	List<User> users = internalTicketsDao.getAsigneedUser(ticketId);
	User asigneed = null;
	if(users.size() > 0){
	  asigneed = users.get(0);
	}
	return asigneed;
  }
  
  public User getResponseUser(Integer ticketId){
	List<User> users = internalTicketsDao.getResponseUser(ticketId);
	User toResponse = null;
	if(users.size() > 0){
	  toResponse = users.get(0);
	}
	return toResponse;
  }
  
  public void sendNotification(Integer fromUserId, Integer toUserId , Integer ticketId, String detail){
	StringBuilder message = new StringBuilder();
	User to = uDAO.getUserById(toUserId);
	User from = uDAO.getUserById(toUserId);
	TicketDetailDTO ticket = getTicketDetail(ticketId);
	IEmailService mail = EmailServiceFactory.getEmailService();
	message.append(String.format("El ticket %s le ha sido asignada para dar seguimiento. Por favor revise a continuación los detalles: ", ticket.getTicketNumber()));
	message.append(String.format("\r\n\r\n Solicitante: %s", ticket.getApplicantUserName() + " - " + ticket.getApplicantAreaName()));
	message.append(String.format("\r\n\r\n Oficina: %s", ticket.getApplicantUserName() + " - " + ticket.getOfficeName()));
	message.append(String.format("\r\n\r\n Tipo de Servicio: %s", ticket.getServiceTypeName()));
	message.append(String.format("\r\n\r\n Proyecto: %s", ticket.getProject()));
	message.append(String.format("\r\n\r\n Descripción: %s", ticket.getDescription()));
	message.append(String.format("\r\n\r\n"));
	message.append(String.format("\r\n\r\n Usuario que asignó: %s", from.getUserName()));
	message.append(String.format("\r\n\r\n Mensaje: %s", detail));
	mail.sendEmail(from.getUserEmail(), to.getUserEmail(), "Asignación de Ticket Interno " + ticket.getTicketNumber(), message.toString());
  }

  public void closeTicket(Integer ticketId, Integer userId){
	 internalTicketsDao.closeTicket(ticketId, userId);
  }
  

}
