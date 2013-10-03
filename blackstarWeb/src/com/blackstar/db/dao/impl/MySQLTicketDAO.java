package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.blackstar.db.dao.interfaces.MySQLDAOFactory;
import com.blackstar.db.dao.interfaces.TicketDAO;
import com.blackstar.model.Ticket;

public class MySQLTicketDAO implements TicketDAO, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1744749073530016060L;

	@Override
	public Ticket findTicket() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Ticket> selectAllTicket() {
		List<Ticket> lstTickets = new ArrayList<Ticket>();
		Ticket ticket = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from ticket");
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				ticket = new Ticket(rs.getInt("ticketId"),rs.getInt("policyId"), rs.getShort("serviceId"), rs.getString("user"),
						rs.getString("observations"), new Character(rs.getString("ticketStatusId").charAt(0)),
						rs.getShort("realResponseTime"), rs.getDate("arrival"), rs.getLong("employee"),
						rs.getString("asignee"), rs.getDate("closed"), rs.getDate("solutionTime"),
						rs.getShort("solutionTimeDeviationHr"), rs.getDate("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"),rs.getString("ticketNumber"));
				lstTickets.add(ticket);
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// TODO Auto-generated method stub
		return lstTickets;
	}

	@Override
	public int insertTicket() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean updateTicket() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public Ticket getTicketById(int id) {
		Ticket ticket = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from ticket where ticketId = ?");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				ticket = new Ticket(rs.getInt("ticketId"),rs.getInt("policyId"), rs.getShort("serviceId"), rs.getString("user"),
						rs.getString("observations"), new Character(rs.getString("ticketStatusId").charAt(0)),
						rs.getShort("realResponseTime"), rs.getDate("arrival"), rs.getLong("employee"),
						rs.getString("asignee"), rs.getDate("closed"), rs.getDate("solutionTime"),
						rs.getShort("solutionTimeDeviationHr"), rs.getDate("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"), rs.getString("ticketNumber"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// TODO Auto-generated method stub
		return ticket;
	}

}
