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
			  url = String.format("jdbc:google:rdbms://salej1-blackstar-dev:salej1-blackstar-dev/%s", db);
			  conn =  (Connection) DriverManager.getConnection(url);
			} else {
			  // Local MySQL instance to use during development.
			  Class.forName("com.mysql.jdbc.Driver");
			  url = String.format("jdbc:mysql://localhost:3306/%s", db);
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
