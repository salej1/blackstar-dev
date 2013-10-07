package com.blackstar.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

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
			  Class.forName("com.mysql.jdbc.GoogleDriver");
			  url = "jdbc:google:rdbms://salej1-blackstar-dev:salej1-blackstar-dev/blackstarDb";
			  conn =  (Connection) DriverManager.getConnection(url);
			} else {
			  // Local MySQL instance to use during development.
			  Class.forName("com.mysql.jdbc.Driver");
			  url = "jdbc:mysql://localhost:3306/blackstarDb";
			  conn =  (Connection) DriverManager.getConnection(url, "root", "");
			}
		}
		catch(SQLException ex){
			Logger.Log(LogLevel.ERROR, ex);
		}
		catch(ClassNotFoundException ex2){
			Logger.Log(LogLevel.FATAL, ex2);
		}
		
		return conn;
	}
}
