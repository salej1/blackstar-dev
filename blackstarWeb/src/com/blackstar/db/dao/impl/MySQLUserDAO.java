package com.blackstar.db.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.blackstar.db.dao.interfaces.UserDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Ticket;
import com.blackstar.model.User;

public class MySQLUserDAO implements UserDAO {

	@Override
	public User getUserById(String email) {
		User user = null;
		Connection conn = null;
		try {
			
			String sql = "SELECT u.email AS userEmail, u.blackstarUserId ,u.name AS userName, g.name AS groupName"
        +" FROM blackstarUser_userGroup ug"
         +       " INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId"
         +       " LEFT OUTER JOIN userGroup g ON g.userGroupId = ug.userGroupId"
        + " WHERE u.email = '"+email+"'";
			
			
			//String.format("CALL GetUserData('%s')", email)
			conn = MySQLDAOFactory.createConnection();
			ResultSet rs = conn.createStatement().executeQuery(sql);
			System.out.println("Email => " + email);
			while(rs.next()) {
				if(user == null){
					user = new User(
						rs.getString("userEmail"),
						rs.getString("userName"),
						rs.getLong("blackstarUserId")
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

}