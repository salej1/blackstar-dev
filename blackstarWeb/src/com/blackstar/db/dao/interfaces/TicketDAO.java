package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Ticket;

public interface TicketDAO {

	public Ticket findTicket();
	public List<Ticket> selectAllTicket();
	public Ticket getTicketById(int id);
	public int insertTicket();
	public boolean updateTicket();
}
