package com.blackstar.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.blackstar.common.Globals;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.google.appengine.api.utils.SystemProperty;


public class DbConnectionProvider {
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
			  conn =  (Connection) DriverManager.getConnection(url, "root", "");
			}
		}
		catch(SQLException ex){
			Logger.Log(LogLevel.CRITICAL, Thread.currentThread().getStackTrace()[0].toString(), ex);
		}
		catch(ClassNotFoundException ex2){
			Logger.Log(LogLevel.CRITICAL, Thread.currentThread().getStackTrace()[0].toString(), ex2);
		}
		
		return conn;
	}
}
