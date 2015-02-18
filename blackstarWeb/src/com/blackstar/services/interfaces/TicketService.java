package com.blackstar.services.interfaces;

import com.blackstar.model.dto.TicketDTO;

public interface TicketService {
	public String getEquipmentList(String customerEmail);
	public String getEquipmentList();
	public String getPolicyData(Integer policyId);
	public Integer saveTicket(TicketDTO ticket, String user, String process) throws Exception;
	public TicketDTO getTicketById(Integer ticketId);
}
