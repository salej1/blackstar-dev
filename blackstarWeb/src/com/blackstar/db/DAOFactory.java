package com.blackstar.db;

import com.blackstar.db.dao.interfaces.MySQLDAOFactory;
import com.blackstar.db.dao.interfaces.OracleDAOFactory;
import com.blackstar.db.dao.interfaces.SQLiteDAOFactory;

public abstract class DAOFactory {
	
	// List of DAO types supported by the factory
	  public static final int MYSQL = 1;
	  public static final int ORACLE = 2;
	  public static final int SQLITE = 3;

	  // There will be a method for each DAO that can be 
	  // created. The concrete factories will have to 
	  // implement these methods.
//	  public abstract CustomerDAO getCustomerDAO();
//	  public abstract AccountDAO getAccountDAO();
//	  public abstract OrderDAO getOrderDAO();

	  public static DAOFactory getDAOFactory(int whichFactory) {
	  
	    switch (whichFactory) {
	      case MYSQL: 
	          return new MySQLDAOFactory();
	      case ORACLE    : 
	          return new OracleDAOFactory();      
	      case SQLITE    : 
	          return new SQLiteDAOFactory();
	      default           : 
	          return null;
	    }
	  }

}
