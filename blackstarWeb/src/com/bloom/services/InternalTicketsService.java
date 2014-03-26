package com.bloom.services;

import java.util.List;

import com.bloom.common.bean.InternalTicketBean;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;

public interface InternalTicketsService {
	
	public List<InternalTicketBean> getPendingTickets();
	public TicketDetailDTO getTicketDetail(Integer ticketId);
	public List<TicketTeamDTO> getTicketTeam(Integer ticketId);
	
}
