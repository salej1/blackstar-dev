package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Serviceorder;

public class MySQLServiceOrderDAO implements ServiceOrderDAO, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3907916234503531781L;

	@Override
	public Serviceorder findServiceOrder() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Serviceorder> selectAllServiceOrder() {
		List<Serviceorder> lstServiceOrder = new ArrayList<Serviceorder>();
		Serviceorder serviceOrder = null;
		Connection conn = null;
		try {
			conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from serviceOrder ");
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				serviceOrder = new Serviceorder(rs.getString("serviceTypeId").charAt(0), rs.getInt("ticketId"),
						rs.getShort("policyId"), rs.getString("serviceUnit"), rs.getDate("serviceDate"),
						rs.getString("responsible"), rs.getString("receivedBy"), rs.getString("serviceComments"),
						rs.getString("servicestatusId"), rs.getDate("closed"), rs.getString("consultant"), rs.getString("coordinator"),
						rs.getString("asignee"), rs.getDate("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"), rs.getString("signCreated"), rs.getString("signReceivedBy"),rs.getString("receivedByPosition"),rs.getString("serviceOrderNumber"), rs.getInt("serviceOrderId"),
						rs.getInt("isWrong"));
				lstServiceOrder.add(serviceOrder);
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
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
		return lstServiceOrder;
	}

	@Override
	public Serviceorder getServiceOrderById(int id) {
		Serviceorder serviceOrder = new Serviceorder();
		Connection conn = null;
		try {
			conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from serviceOrder where serviceOrderId = ?");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				serviceOrder = new Serviceorder(rs.getString("serviceTypeId").charAt(0), rs.getInt("ticketId"),
						rs.getShort("policyId"), rs.getString("serviceUnit"), rs.getDate("serviceDate"),
						rs.getString("responsible"), rs.getString("receivedBy"), rs.getString("serviceComments"),
						rs.getString("servicestatusId"), rs.getDate("closed"), rs.getString("consultant"), rs.getString("coordinator"),
						rs.getString("asignee"), rs.getDate("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"), rs.getString("signCreated"), rs.getString("signReceivedBy"),rs.getString("receivedByPosition"),rs.getString("serviceOrderNumber"),rs.getInt("serviceOrderId"),
						rs.getInt("isWrong"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		finally{
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
				}
			}
		}
		// TODO Auto-generated method stub
		return serviceOrder;
	}

	@Override
	public int insertServiceOrder() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean updateServiceOrder(Serviceorder so) {
		StringBuilder sql = new StringBuilder("Update serviceOrder set ");
		Boolean retVal = false;
		
		sql.append(String.format("isWrong = %s", so.getIsWrong()));
		
		sql.append(String.format(" Where serviceOrderId = %s;", so.getServiceOrderId()));
		
		Connection conn = null;
		
		try{
			conn = MySQLDAOFactory.createConnection();
			conn.createStatement().executeUpdate(sql.toString());
			retVal = true;
		}
		catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		finally{
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
				}
			}
		}
		return retVal;
	}

	@Override
	public Serviceorder getServiceOrderByNum(String num) {
		Serviceorder serviceOrder = new Serviceorder();
		Connection conn = null;
		try {
			conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from serviceOrder where serviceOrderNumber = ?");
			ps.setString(1, num);
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				serviceOrder = new Serviceorder(rs.getString("serviceTypeId").charAt(0), rs.getInt("ticketId"),
						rs.getShort("policyId"), rs.getString("serviceUnit"), rs.getDate("serviceDate"),
						rs.getString("responsible"), rs.getString("receivedBy"), rs.getString("serviceComments"),
						rs.getString("servicestatusId"), rs.getDate("closed"), rs.getString("consultant"), rs.getString("coordinator"),
						rs.getString("asignee"), rs.getDate("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"), rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"), rs.getString("signCreated"), rs.getString("signReceivedBy"),rs.getString("receivedByPosition"),rs.getString("serviceOrderNumber"),rs.getInt("serviceOrderId"),
						rs.getInt("IsWrong"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
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
		return serviceOrder;
	}

}
