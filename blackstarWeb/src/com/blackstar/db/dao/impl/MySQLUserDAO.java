package com.blackstar.db.dao.impl;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.blackstar.db.dao.interfaces.UserDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.User;

public class MySQLUserDAO implements UserDAO {

	@Override
	public User getUserById(String email) {
		User user = null;
		Connection conn = null;
		try {
			conn = MySQLDAOFactory.createConnection();
			ResultSet rs = conn.createStatement().executeQuery(String.format("CALL GetUserData('%s')", email));
			System.out.println("Email => " + email);
			while(rs.next()) {
				if(user == null){
					user = new User(
					    rs.getInt("blackstarUserId"),
						rs.getString("userEmail"),
						rs.getString("userName")
					);
				}

				String groupName = rs.getString("groupName");
				if(groupName != null && groupName.length() > 0){
					user.addGroup(groupName);
				}
			}

			if(user.getUserGroups().size() == 0){
				Logger.Log(LogLevel.WARNING, Thread.currentThread().getStackTrace()[1].toString(), String.format("Usuario %s no pertenece a ningun grupo", email), "");
			}

		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
				}
			}
		}
		// TODO Auto-generated method stub
		return user;
	}

	@Override
	public List<User> getDomainUserList() {
		// TODO Auto-generated method stub
		return null;
	}

	public User getUserById(Integer id){
		return null;
	}

}