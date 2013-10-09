package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.blackstar.db.dao.interfaces.FollowUpDAO;
import com.blackstar.model.Followup;

public class MySQLFollowUpDAO implements FollowUpDAO, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 475508215010102993L;

	@Override
	public Followup findFollowUp() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Followup> selectAllFollowUp() {
		List<Followup> lstFollowpUp = new ArrayList<Followup>();
		Followup followUp = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from followUp");
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				followUp = new Followup(rs.getInt("ticketId"), rs.getInt("serviceOrderId"), rs.getString("asignee"),
						rs.getString("followup"), rs.getDate("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"));
				
				lstFollowpUp.add(followUp);		
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// TODO Auto-generated method stub
		return lstFollowpUp;
	}

	@Override
	public List<Followup> getFollowUpByTicketId(int id) {
		List<Followup> lstFollowpUp = new ArrayList<Followup>();
		Followup followUp = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from followUp where ticketId=?");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				followUp = new Followup(rs.getInt("ticketId"), rs.getInt("serviceOrderId"), rs.getString("asignee"),
						rs.getString("followup"), rs.getDate("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"));
				
				lstFollowpUp.add(followUp);		
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// TODO Auto-generated method stub
		return lstFollowpUp;
	}

	@Override
	public int insertFollowUp() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean updateFollowUp() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public List<Followup> getFollowUpByServiceOrderId(int id) {
		List<Followup> lstFollowpUp = new ArrayList<Followup>();
		Followup followUp = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from followUp where serviceOrderId=?");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				followUp = new Followup(rs.getInt("ticketId"), rs.getInt("serviceOrderId"), rs.getString("asignee"),
						rs.getString("followup"), rs.getDate("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"));
				
				lstFollowpUp.add(followUp);		
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// TODO Auto-generated method stub
		return lstFollowpUp;
	}
}
