package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.blackstar.db.dao.interfaces.TicketStatusDAO;
import com.blackstar.model.Ticketstatus;

public class MySQLTicketStatusDAO implements TicketStatusDAO, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3237282808671068081L;

	@Override
	public Ticketstatus findTicketStatus() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Ticketstatus> selectAllTicketStatus() {
		List<Ticketstatus> lstTicketStatus = new ArrayList<Ticketstatus>();
		Ticketstatus ticketStatus = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from ticketStatus");
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				ticketStatus = new Ticketstatus(rs.getString("ticketStatusId").charAt(0), rs.getString("ticketStatus"));
				lstTicketStatus.add(ticketStatus);
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// TODO Auto-generated method stub
		return lstTicketStatus;
	}

	@Override
	public int insertTicketStatus() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean updateTicketStatus() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public Ticketstatus getTicketStatusById(int id) {
		Ticketstatus ticketStatus = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from ticketStatus where ticketStatusId = ?");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				ticketStatus = new Ticketstatus(rs.getString("ticketStatusId").charAt(0), rs.getString("ticketStatus"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// TODO Auto-generated method stub
		return ticketStatus;
	}

}
