package com.blackstar.db.dao.impl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.blackstar.db.DAOFactory;
import com.blackstar.db.DBConnectionString;
import com.blackstar.db.dao.interfaces.EquipmentTypeDAO;
import com.blackstar.db.dao.interfaces.FollowUpDAO;
import com.blackstar.db.dao.interfaces.OfficeDAO;
import com.blackstar.db.dao.interfaces.PolicyContactDAO;
import com.blackstar.db.dao.interfaces.PolicyDAO;
import com.blackstar.db.dao.interfaces.ServiceCenterDAO;
import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.db.dao.interfaces.TicketDAO;
import com.blackstar.db.dao.interfaces.TicketStatusDAO;

public class MySQLDAOFactory extends DAOFactory {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4050710525058420896L;
	private static final String DRIVER = "com.mysql.jdbc.Driver";
	public static final String DBURL = DBConnectionString.getConnectionString();
	
	public static Connection createConnection() throws ClassNotFoundException, SQLException {
		Class.forName(DRIVER);
		Connection conn = DriverManager.getConnection(DBURL);
		return conn;
	}

	@Override
	public TicketDAO getTicketDAO() {
		// TODO Auto-generated method stub
		return new MySQLTicketDAO();
	}

	@Override
	public PolicyDAO getPolicyDAO() {
		// TODO Auto-generated method stub
		return new MySQLPolicyDAO();
	}

	@Override
	public PolicyContactDAO getPolicyContactDAO() {
		// TODO Auto-generated method stub
		return new MySQLPolicyContactDAO();
	}

	@Override
	public TicketStatusDAO getTicketStatusDAO() {
		// TODO Auto-generated method stub
		return new MySQLTicketStatusDAO();
	}

	@Override
	public EquipmentTypeDAO getEquipmentTypeDAO() {
		// TODO Auto-generated method stub
		return new MySQLEquipmentTypeDAO();
	}

	@Override
	public ServiceCenterDAO getServiceCenterDAO() {
		// TODO Auto-generated method stub
		return new MySQLServiceCenterDAO();
	}

	@Override
	public OfficeDAO getOfficeDAO() {
		// TODO Auto-generated method stub
		return new MySQLOfficeDAO();
	}

	@Override
	public ServiceOrderDAO getServiceOrderDAO() {
		// TODO Auto-generated method stub
		return new MySQLServiceOrderDAO();
	}

	@Override
	public FollowUpDAO getFollowUpDAO() {
		// TODO Auto-generated method stub
		return new MySQLFollowUpDAO();
	}
}
