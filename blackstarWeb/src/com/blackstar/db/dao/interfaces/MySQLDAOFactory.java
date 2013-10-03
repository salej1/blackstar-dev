package com.blackstar.db.dao.interfaces;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.blackstar.db.DAOFactory;
import com.blackstar.db.dao.impl.MySQLEquipmentTypeDAO;
import com.blackstar.db.dao.impl.MySQLFollowUpDAO;
import com.blackstar.db.dao.impl.MySQLOfficeDAO;
import com.blackstar.db.dao.impl.MySQLPolicyContactDAO;
import com.blackstar.db.dao.impl.MySQLPolicyDAO;
import com.blackstar.db.dao.impl.MySQLServiceCenterDAO;
import com.blackstar.db.dao.impl.MySQLServiceOrderDAO;
import com.blackstar.db.dao.impl.MySQLTicketDAO;
import com.blackstar.db.dao.impl.MySQLTicketStatusDAO;

public class MySQLDAOFactory extends DAOFactory {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4050710525058420896L;
	public static final String DRIVER="com.mysql.jdbc.Driver";
	public static final String DBURL="jdbc:mysql://localhost:3306/test";
	
	public static Connection createConnection() throws ClassNotFoundException, SQLException {
		Class.forName(DRIVER);
		Connection conn=DriverManager.getConnection(DBURL,"root","5gdVai.q");
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
