package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.blackstar.db.dao.interfaces.TicketDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
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
				ticket = new Ticket(rs.getInt("ticketId"),rs.getInt("policyId"), rs.getShort("serviceOrderId"), rs.getString("user"),
						rs.getString("observations"), new Character(rs.getString("ticketStatusId").charAt(0)),
						rs.getShort("realResponseTime"), rs.getDate("arrival"), rs.getString("employee"),
						rs.getString("asignee"), rs.getDate("closed"), rs.getInt("solutionTime"),
						rs.getShort("solutionTimeDeviationHr"), rs.getDate("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"),rs.getString("ticketNumber"), rs.getBoolean("phoneResolved"));
				lstTickets.add(ticket);
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
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
				ticket = new Ticket(rs.getInt("ticketId"),rs.getInt("policyId"), rs.getShort("serviceOrderId"), rs.getString("user"),
						rs.getString("observations"), new Character(rs.getString("ticketStatusId").charAt(0)),
						rs.getShort("realResponseTime"), rs.getDate("arrival"), rs.getString("employee"),
						rs.getString("asignee"), rs.getDate("closed"), rs.getInt("solutionTime"),
						rs.getShort("solutionTimeDeviationHr"), rs.getDate("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"), rs.getString("ticketNumber"),rs.getBoolean("phoneResolved"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		// TODO Auto-generated method stub
		return ticket;
	}
	
	@Override
	public Ticket getTicketByNumber(String number) {
		Ticket ticket = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			ResultSet rs = conn.createStatement().executeQuery(String.format("Select * from ticket where ticketNumber = '%s'", number));
			
			while(rs.next()) {
				ticket = new Ticket(rs.getInt("ticketId"),rs.getInt("policyId"), rs.getShort("serviceId"), rs.getString("user"),
						rs.getString("observations"), new Character(rs.getString("ticketStatusId").charAt(0)),
						rs.getShort("realResponseTime"), rs.getTimestamp("arrival"), rs.getString("employee"),
						rs.getString("asignee"), rs.getTimestamp("closed"), rs.getInt("solutionTime"),
						rs.getShort("solutionTimeDeviationHr"), rs.getTimestamp("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"), rs.getString("ticketNumber"), rs.getBoolean("phoneResolved"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		// TODO Auto-generated method stub
		return ticket;
	}

}
