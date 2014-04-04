package com.bloom.db.dao;

import java.util.List;













import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.model.dto.DeliverableTypeDTO;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;

public interface InternalTicketsDao {
	
  public List<InternalTicketBean> getPendingTickets ();
  public List<TicketDetailDTO> getTicketDetail(Integer ticketId);
  public List<TicketTeamDTO> getTicketTeam(Integer ticketId);
  public void addFollow(Integer ticketId, Integer userId, String comment);
  public void addTicketTeam(Integer ticketId, Integer roleId, Integer userId);
  public List<Followup> getFollowUps(Integer ticketId);
  public List<DeliverableTypeDTO> getDeliverableTypes();
  public void addDeliverableTrace(Integer ticketId, Integer deliverableTypeId);
  public List<User> getAsigneedUser(Integer ticketId);
  public List<User> getResponseUser(Integer ticketId);
  public void closeTicket(Integer ticketId, Integer userId);
}
