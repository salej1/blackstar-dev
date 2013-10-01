package com.blackstar.db.dao.interfaces;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.blackstar.db.DAOFactory;

public class MySQLDAOFactory extends DAOFactory {

	public static final String DRIVER="com.mysql.jdbc.Driver";
	public static final String DBURL="jdbc:mysql://localhost:3306/test";
	
	public static Connection createConnection() throws ClassNotFoundException, SQLException {
		Class.forName(DRIVER);
		Connection conn=DriverManager.getConnection(DBURL,"root","5gdVai.q");
		return conn;
	}
	
	public TicketDAO getTicketDAO() {
		TicketDAO dao = null;
		 
		return dao;
	}
	
	public static void main(String args[]) {
		try {
			Connection conn = createConnection();
			System.out.println(conn.toString());
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
