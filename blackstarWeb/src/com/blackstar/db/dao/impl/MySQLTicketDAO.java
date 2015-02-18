package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.TicketDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Ticket;
import com.blackstar.model.dto.TicketDTO;

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
		Connection conn = null;
		try {
			conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from ticket tk order by tk.created desc");
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				ticket = new Ticket(rs.getInt("ticketId"),rs.getInt("policyId"), rs.getShort("serviceOrderId"), rs.getString("user"),
						rs.getString("observations"), new Character(rs.getString("ticketStatusId").charAt(0)),
						rs.getShort("realResponseTime"), rs.getTimestamp("arrival"), rs.getString("employee"),
						rs.getString("asignee"), rs.getTimestamp("closed"), rs.getInt("solutionTime"),
						rs.getShort("solutionTimeDeviationHr"), rs.getTimestamp("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getTimestamp("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"),rs.getString("ticketNumber"), rs.getBoolean("phoneResolved"), rs.getInt("responseTimeDeviationHr"),
						rs.getString("serviceOrderNumber"), rs.getString("contact"), rs.getString("contactPhone"), rs.getString("contactEmail"));
				lstTickets.add(ticket);
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
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
		Connection conn = null;
		try {
			conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from ticket where ticketId = ?");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				ticket = new Ticket(rs.getInt("ticketId"),rs.getInt("policyId"), rs.getShort("serviceOrderId"), rs.getString("user"),
						rs.getString("observations"), new Character(rs.getString("ticketStatusId").charAt(0)),
						rs.getShort("realResponseTime"), rs.getTimestamp("arrival"), rs.getString("employee"),
						rs.getString("asignee"), rs.getTimestamp("closed"), rs.getInt("solutionTime"),
						rs.getShort("solutionTimeDeviationHr"), rs.getTimestamp("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getTimestamp("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"), rs.getString("ticketNumber"),rs.getBoolean("phoneResolved"), rs.getInt("responseTimeDeviationHr"),
						rs.getString("serviceOrderNumber"), rs.getString("contact"), rs.getString("contactPhone"), rs.getString("contactEmail"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		// TODO Auto-generated method stub
		return ticket;
	}
	
	@Override
	public Ticket getTicketByNumber(String number) {
		Ticket ticket = null;
		Connection conn = null;
		try {
			conn = MySQLDAOFactory.createConnection();
			ResultSet rs = conn.createStatement().executeQuery(String.format("Select * from ticket where ticketNumber = '%s'", number));
			
			while(rs.next()) {
				ticket = new Ticket(rs.getInt("ticketId"),rs.getInt("policyId"), rs.getShort("serviceOrderId"), rs.getString("user"),
						rs.getString("observations"), new Character(rs.getString("ticketStatusId").charAt(0)),
						rs.getShort("realResponseTime"), rs.getTimestamp("arrival"), rs.getString("employee"),
						rs.getString("asignee"), rs.getTimestamp("closed"), rs.getInt("solutionTime"),
						rs.getShort("solutionTimeDeviationHr"), rs.getTimestamp("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getTimestamp("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"), rs.getString("ticketNumber"), rs.getBoolean("phoneResolved"), rs.getInt("responseTimeDeviationHr"),
						rs.getString("serviceOrderNumber"), rs.getString("contact"), rs.getString("contactPhone"), rs.getString("contactEmail"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		// TODO Auto-generated method stub
		return ticket;
	}

	@Override
	public List<JSONObject> getEquipmentList(String customerEmail) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<JSONObject> getEquipmentList() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<JSONObject> getPolicyData(Integer policyId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Integer saveTicket(TicketDTO ticket) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public TicketDTO getTicketDTOById(Integer ticketId) {
		// TODO Auto-generated method stub
		return null;
	}

}
