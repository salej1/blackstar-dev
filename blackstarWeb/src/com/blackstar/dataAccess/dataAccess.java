package com.blackstar.dataAccess;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.google.cloud.sql.jdbc.*;

public class dataAccess {

	public static ResultSet executeQuery(String sql) throws SQLException {
			
		try {
			Class.forName("com.mysql.jdbc.GoogleDriver");
		} catch (ClassNotFoundException e) {
			Logger.Log(LogLevel.Error, e);
			throw new SQLException("Can't create class com.mysql.jdbc.GoogleDriver");
		}
		String url = "jdbc:google:mysql://your-project-id:your-instance-name/guestbook?user=root";
		String statement = "Select * from serviceOrder Where ";
		Connection conn = (Connection) DriverManager.getConnection(url);
		PreparedStatement stmt = conn.prepareStatement(statement);
		
		ResultSet res = stmt.executeQuery();

		conn.close();
		
		return res;
	}
}
