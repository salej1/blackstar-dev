package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Ticketstatus;

public interface TicketStatusDAO {

	public Ticketstatus findTicketStatus();
	public List<Ticketstatus> selectAllTicketStatus();
	public Ticketstatus getTicketStatusById(int id);
	public int insertTicketStatus();
	public boolean updateTicketStatus();
}
