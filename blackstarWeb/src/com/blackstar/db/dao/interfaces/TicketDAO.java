package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Ticket;
import com.blackstar.model.dto.TicketDTO;

public interface TicketDAO {

	public Ticket findTicket();
	public List<Ticket> selectAllTicket();
	public Ticket getTicketById(int id);
	public Ticket getTicketByNumber(String number);
	public int insertTicket();
	public boolean updateTicket();
	
	// A prtir de aqui se implementan en TicketDAOImpl
	public List<JSONObject> getEquipmentList(String customerEmail);
	public List<JSONObject> getEquipmentList();
	public List<JSONObject> getPolicyData(Integer policyId);
	public Integer saveTicket(TicketDTO ticket)  throws Exception ;
	public TicketDTO getTicketDTOById(Integer ticketId);
}
