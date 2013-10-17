package com.blackstar.db.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.blackstar.db.dao.interfaces.UserDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Ticket;
import com.blackstar.model.User;

public class MySQLUserDAO implements UserDAO {

	@Override
	public User getUserById(String email) {
		User user = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			ResultSet rs = conn.createStatement().executeQuery(String.format("CALL GetUserData('%s')", email));
			
			while(rs.next()) {
				if(user == null){
					user = new User(
						rs.getString("userEmail"),
						rs.getString("userName")
					);
				}
				
				user.addGroup(rs.getString("groupName"));
			}
			
			if(user.getUserGroups().size() == 0){
				Logger.Log(LogLevel.WARNING, Thread.currentThread().getStackTrace()[1].toString(), String.format("Usuario %s no pertenece a ningun grupo", email), "");
			}
			
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		// TODO Auto-generated method stub
		return user;
	}

}
