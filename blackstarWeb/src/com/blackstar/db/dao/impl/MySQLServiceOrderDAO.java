package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Employee;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.BatteryCellServiceDTO;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.ServiceStatusDTO;
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
			PreparedStatement ps = conn
					.prepareStatement("Select * from serviceOrder ");
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				serviceOrder = new Serviceorder(rs.getString("serviceTypeId")
						.charAt(0), rs.getInt("ticketId"),
						rs.getInt("policyId"), rs.getString("serviceUnit"),
						rs.getDate("serviceDate"), rs.getString("responsible"),
						rs.getString("receivedBy"),
						rs.getString("serviceComments"),
						rs.getString("servicestatusId"), rs.getDate("closed"),
						rs.getString("consultant"),
						rs.getString("coordinator"), rs.getString("asignee"),
						rs.getDate("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"),
						rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"),
						rs.getString("signCreated"),
						rs.getString("signReceivedBy"),
						rs.getString("receivedByPosition"),
						rs.getString("serviceOrderNumber"),
						rs.getInt("serviceOrderId"), rs.getInt("isWrong"),
						rs.getString("receivedByEmail"),
						rs.getInt("openCustomerId"), rs.getTimestamp("serviceEndDate"));
				lstServiceOrder.add(serviceOrder);

			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		} finally {
			if (conn != null) {
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
			PreparedStatement ps = conn
					.prepareStatement("CALL GetServiceOrderById(?)");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				serviceOrder = new Serviceorder(rs.getString("serviceTypeId")
						.charAt(0), rs.getInt("ticketId"),
						rs.getInt("policyId"), rs.getString("serviceUnit"),
						rs.getTimestamp("serviceDate"), rs.getString("responsible"),
						rs.getString("receivedBy"),
						rs.getString("serviceComments"),
						rs.getString("servicestatusId"), rs.getTimestamp("closed"),
						rs.getString("consultant"),
						rs.getString("coordinator"), rs.getString("asignee"),
						rs.getTimestamp("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"),
						rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"),
						rs.getString("signCreated"),
						rs.getString("signReceivedBy"),
						rs.getString("receivedByPosition"),
						rs.getString("serviceOrderNumber"),
						rs.getInt("serviceOrderId"), rs.getInt("isWrong"),
						rs.getString("receivedByEmail"),
						rs.getInt("openCustomerId"), rs.getTimestamp("serviceEndDate"));

			}
			
			ps = conn.prepareStatement("CALL GetServiceOrderEmployeeList(?)");
			ps.setInt(1, id);
			rs = ps.executeQuery();
			
			serviceOrder.setEmployeeList(new ArrayList<Employee>());
			while (rs.next()){
				Employee emp = new Employee();
				emp.setEmail(rs.getString("email"));
				emp.setName(rs.getString("name"));
				serviceOrder.getEmployeeList().add(emp);
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(),
							e);
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
	public boolean updateServiceOrder(Serviceorder so) {
		StringBuilder sql = new StringBuilder("Update serviceOrder set ");
		Boolean retVal = false;

		sql.append(String.format("isWrong = %s", so.getIsWrong()));

		sql.append(String.format(" Where serviceOrderId = %s;",
				so.getServiceOrderId()));

		Connection conn = null;

		try {
			conn = MySQLDAOFactory.createConnection();
			conn.createStatement().executeUpdate(sql.toString());
			retVal = true;
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(),
							e);
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
			PreparedStatement ps = conn
					.prepareStatement("CALL GetServiceOrderByNumber(?)");
			ps.setString(1, num);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				serviceOrder = new Serviceorder(rs.getString("serviceTypeId")
						.charAt(0), rs.getInt("ticketId"),
						rs.getInt("policyId"), rs.getString("serviceUnit"),
						rs.getDate("serviceDate"), rs.getString("responsible"),
						rs.getString("receivedBy"),
						rs.getString("serviceComments"),
						rs.getString("servicestatusId"), rs.getDate("closed"),
						rs.getString("consultant"),
						rs.getString("coordinator"), rs.getString("asignee"),
						rs.getDate("created"), rs.getString("createdBy"),
						rs.getString("createdByUsr"), rs.getDate("modified"),
						rs.getString("modifiedBy"),
						rs.getString("modifiedByUsr"),
						rs.getString("signCreated"),
						rs.getString("signReceivedBy"),
						rs.getString("receivedByPosition"),
						rs.getString("serviceOrderNumber"),
						rs.getInt("serviceOrderId"), rs.getInt("IsWrong"),
						rs.getString("receivedByEmail"),
						rs.getInt("openCustomerId"), rs.getTimestamp("serviceEndDate"));

			}
			
			ps = conn.prepareStatement("CALL GetServiceOrderEmployeeList(?)");
			ps.setInt(1, serviceOrder.getServiceOrderId());
			rs = ps.executeQuery();
			
			serviceOrder.setEmployeeList(new ArrayList<Employee>());
			while (rs.next()){
				Employee emp = new Employee();
				emp.setEmail(rs.getString("email"));
				emp.setName(rs.getString("name"));
				serviceOrder.getEmployeeList().add(emp);
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		} finally {
			if (conn != null) {
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
	public List<FollowUpDTO> getFollows(Integer serviceOrderId) {
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
	public int saveAirCoService(AirCoServiceDTO service, Date created,
			String createdBy, String createdByUsr) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int saveBateryService(BatteryServiceDTO service, Date created,
			String createdBy, String createdByUsr) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int saveEmergencyPlantService(EmergencyPlantServiceDTO service,
			Date created, String createdBy, String createdByUsr) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int savePlainService(PlainServiceDTO service, Date created,
			String createdBy, String createdByUsr) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int saveUpsService(UpsServiceDTO service, Date created,
			String createdBy, String createdByUsr) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getNewServiceNumber(Integer policyId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<JSONObject> getServiceOrdersByStatus(String status) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<JSONObject> getServiceOrderHistory() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<JSONObject> getEquipmentByType(String type) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getServiceOrderTypeBySOId(Integer serviceOrderId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ServiceStatusDTO> getServiceStatusList() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<FollowUpDTO> getServiceFollowUps(Integer serviceOrderId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getNewServiceNumber() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<JSONObject> getLimitedServiceOrdersHistory(String user) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<JSONObject> getServiceOrderDetails(String orderNumber) {
		// TODO Auto-generated method stub
		return null;
	}

}
