package com.bloom.db.dao;

import java.util.List;



import com.bloom.common.bean.InternalTicketBean;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;

public interface InternalTicketsDao {
	
  public List<InternalTicketBean> getPendingTickets ();
  public List<TicketDetailDTO> getTicketDetail(Integer ticketId);
  public List<TicketTeamDTO> getTicketTeam(Integer ticketId);
}
