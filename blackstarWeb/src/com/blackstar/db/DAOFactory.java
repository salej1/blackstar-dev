package com.blackstar.db;

import java.io.Serializable;

import com.blackstar.db.dao.impl.MySQLDAOFactory;
import com.blackstar.db.dao.interfaces.*;

public abstract class DAOFactory implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7335055667441106926L;
	public static final int MYSQL = 1;
  	public static final int ORACLE = 2;
  	public static final int SQLITE = 3;

	public abstract TicketDAO getTicketDAO();
	public abstract PolicyDAO getPolicyDAO();
	public abstract PolicyContactDAO getPolicyContactDAO();
	public abstract TicketStatusDAO getTicketStatusDAO();
	public abstract EquipmentTypeDAO getEquipmentTypeDAO();
	public abstract ServiceCenterDAO getServiceCenterDAO();
	public abstract OfficeDAO getOfficeDAO();
	public abstract ServiceOrderDAO getServiceOrderDAO();
	public abstract FollowUpDAO getFollowUpDAO();

	  public static DAOFactory getDAOFactory(int whichFactory) {
	  
	    switch (whichFactory) {
	      case MYSQL: 
	          return new MySQLDAOFactory();
	      case ORACLE    : 
	          return new OracleDAOFactory();      
	      default           : 
	          return null;
	    }
	  }

}