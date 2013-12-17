package com.blackstar.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.logging.Level;

import com.blackstar.common.Globals;
import com.google.appengine.api.utils.SystemProperty;


public class DbConnectionProvider {
	
	private static java.util.logging.Logger log = java.util.logging.Logger.getLogger(DbConnectionProvider
			                                                                           .class.getName());
	public static Connection getConnection(String db){
		Connection conn = null;
		try {
			String url = null;
			if (SystemProperty.environment.value() ==
			    SystemProperty.Environment.Value.Production) {
			  // Load the class that provides the new "jdbc:google:mysql://" prefix.
			  Class.forName(Globals.GOOGLE_DRIVER_CLASS);
			  url = String.format(Globals.CONNECTION_STRING_TEMPLATE, db);
			  conn =  (Connection) DriverManager.getConnection(url);
			} else {
			  // Local MySQL instance to use during development.
			  Class.forName(Globals.DEFAULT_DRIVER_CLASS);
			  url = String.format(Globals.LOCAL_CONNECTION_STRING_TEMPLATE, db);
			  conn =  (Connection) DriverManager.getConnection(url, "root", "admin");
			}
		}
		catch(Exception ex){
			log.info("Fatal error: " + ex.toString());
			log.log(Level.ALL, "log.log: " + ex.toString());
			ex.printStackTrace();
		}
		return conn;
	}
}
