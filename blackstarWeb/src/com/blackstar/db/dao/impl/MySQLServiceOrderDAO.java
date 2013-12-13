package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.BatteryCellServiceDTO;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.UpsServiceDTO;

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
						rs.getString("modifiedByUsr"), rs.getString("signCreated"), rs.getString("signReceivedBy"),rs.getString("receivedByPosition"),rs.getString("serviceOrderNumber"), rs.getInt("serviceOrderId"));
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
						rs.getString("modifiedByUsr"), rs.getString("signCreated"), rs.getString("signReceivedBy"),rs.getString("receivedByPosition"),rs.getString("serviceOrderNumber"),rs.getInt("serviceOrderId"));
						
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

	@Override
	public int insertServiceOrder(Serviceorder orderService) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean updateServiceOrder(Serviceorder orderService) {
		// TODO Auto-generated method stub
		return false;
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
						rs.getString("modifiedByUsr"), rs.getString("signCreated"), rs.getString("signReceivedBy"),rs.getString("receivedByPosition"),rs.getString("serviceOrderNumber"),rs.getInt("serviceOrderId"));
						
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

	@Override
	public OrderserviceDTO getServiceOrderByIdOrNumber(Integer serviceOrderId,
			String orderNumber) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<FollowUpDTO> getFollows (Integer serviceOrderId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public AirCoServiceDTO getAirCoService(Integer aaServiceId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public BatteryServiceDTO getBateryService(Integer bbServiceId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<BatteryCellServiceDTO> getBatteryCells(Integer bbServiceId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public EmergencyPlantServiceDTO getEmergencyPlantService(Integer epServiceId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public PlainServiceDTO getPlainService(Integer plainServiceId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public UpsServiceDTO getUpsService(Integer upsServiceId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int saveAirCoService(AirCoServiceDTO service, Date created ,String createdBy,String createdByUsr) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int saveBateryService(BatteryServiceDTO service, Date created ,String createdBy,String createdByUsr) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int saveEmergencyPlantService(EmergencyPlantServiceDTO service, Date created ,String createdBy,String createdByUsr) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int savePlainService(PlainServiceDTO service, Date created ,String createdBy,String createdByUsr) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int saveUpsService(UpsServiceDTO service, Date created ,String createdBy,String createdByUsr) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getNewServiceNumber(Integer policyId) {
		// TODO Auto-generated method stub
		return null;
	}

}
