package com.blackstar.services.impl;

import com.blackstar.db.dao.interfaces.TicketDAO;
import com.blackstar.model.dto.TicketDTO;
import com.blackstar.services.interfaces.TicketService;

public class TicketServiceImpl implements TicketService {

	TicketDAO dao;

	public void setDao(TicketDAO dao) {
		this.dao = dao;
	}

	
	@Override
	public String getEquipmentList(String customerEmail) {
		return dao.getEquipmentList(customerEmail).toString();
	}

	@Override
	public String getEquipmentList() {
		String data =  dao.getEquipmentList().toString();
		data.replace("\"", "\\\"");
		return data;
	}


	@Override
	public String getPolicyData(Integer policyId) {
		String data = dao.getPolicyData(policyId).toString();
		data.replace("\"", "\\\"");
		return data;
	}


	@Override
	public Integer saveTicket(TicketDTO ticket, String user, String process) throws Exception {
		ticket.setCreatedBy(process);
		ticket.setCreatedByUsr(user);
		ticket.setUser(user);
		ticket.setTicketStatusId("A");
		
		return dao.saveTicket(ticket);
	}


	@Override
	public TicketDTO getTicketById(Integer ticketId) {
		return dao.getTicketDTOById(ticketId);
	}

}
