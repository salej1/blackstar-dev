package com.blackstar.services.impl;

import java.io.IOException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.interfaces.IUserService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.google.appengine.api.users.User;

public class GoogleUserServiceImpl implements IUserService{
	com.google.appengine.api.users.UserService srv = com.google.appengine.api.users.UserServiceFactory.getUserService();
	
	@Override
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

	@Override
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
	
	@Override
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
	public Map<String, String> getEmployeeList(){
		BlackstarDataAccess da = new BlackstarDataAccess();
		Map<String, String> empList = new HashMap<String, String>();
		
		try{
			ResultSet employees = da.executeQuery("CALL GetDomainEmployees();");
			
			while(employees.next()){
				empList.put(employees.getString("email"), employees.getString("name"));
			}
		}catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[0].toString(), ex);
		}
		
		return empList;
	}

	@Override
	public Map<String, String> getEmployeeListByGroup(String group) {
		// TODO Auto-generated method stub
		return null;
	}
}