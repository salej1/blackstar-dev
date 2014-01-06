package com.blackstar.services;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.services.IUserService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.google.appengine.api.users.User;
import com.google.appengine.api.utils.SystemProperty;

public class GoogleUserService implements IUserService {
	com.google.appengine.api.users.UserService srv = com.google.appengine.api.users.UserServiceFactory.getUserService();
	
	
	public String getCurrentUserId(HttpServletResponse resp) {
        User user = srv.getCurrentUser();
        String userId = null;
        
        if (user != null) {
            userId = user.getEmail();
        } else {
            try {
				resp.sendRedirect(srv.createLoginURL("/dashboard"));
			} catch (IOException e) {
				Logger.Log(LogLevel.CRITICAL, Thread.currentThread().getStackTrace()[0].toString(), e);
			}
        }
        
        return userId;
	}

	
	public String getCurrentUserName(HttpServletResponse resp) {
		User user = srv.getCurrentUser();
        String userName = null;
        
        if (user != null) {
            userName = user.getNickname();
        } else {
            try {
				resp.sendRedirect(srv.createLoginURL("/dashboard"));
			} catch (IOException e) {
				Logger.Log(LogLevel.CRITICAL, Thread.currentThread().getStackTrace()[0].toString(), e);
			}
        }
        
        return userName;
	}
	
	
	public List<String> getCurrentUserGroups(HttpServletResponse resp){
		// TODO Auto-generated method stub
		List<String> groupList = new ArrayList<String>();
		
		try{
			BlackstarDataAccess da = new BlackstarDataAccess();
			String usrCommonId = getCurrentUserId(resp);
			ResultSet groups = da.executeQuery("CALL GetUserData('" + usrCommonId + "');");
						
			while(groups.next()){
				groupList.add(groups.getString("groupName"));
			}
			
			da.closeConnection();	
		}catch(Exception se){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[0].toString(), se);
		}
		
		return groupList;
	}

	@Override
	public List<com.blackstar.model.User> getEmployeeList(){
		BlackstarDataAccess da = new BlackstarDataAccess();
		List<com.blackstar.model.User> empList = new ArrayList<com.blackstar.model.User>();
		
		try{
			ResultSet employees = da.executeQuery("CALL GetDomainEmployees();");
			
			while(employees.next()){
				empList.add(new com.blackstar.model.User(employees.getString("email"), employees.getString("name")));
			}
		}catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[0].toString(), ex);
		}
		
		return empList;
	}
	
	
	public Map<String, String> getEmployeeListByGroup(String group){
		BlackstarDataAccess da = new BlackstarDataAccess();
		Map<String, String> empList = new HashMap<String, String>();
		
		try{
			ResultSet employees = da.executeQuery(String.format("CALL GetDomainEmployeesByGroup('%s');", group));
			
			while(employees.next()){
				empList.put(employees.getString("email"), employees.getString("name"));
			}
		}catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[0].toString(), ex);
		}
		
		return empList;
	}

	@Override
	public com.blackstar.model.User gerUserById(String id) {
		// TODO Auto-generated method stub
		return null;
	}
}
