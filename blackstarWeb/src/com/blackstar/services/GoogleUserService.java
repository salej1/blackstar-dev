package com.blackstar.services;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.interfaces.IUserService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.google.appengine.api.users.User;
import com.google.apphosting.api.UserServicePb.UserService;

public class GoogleUserService implements IUserService {
	com.google.appengine.api.users.UserService srv = com.google.appengine.api.users.UserServiceFactory.getUserService();
	
	@Override
	public String getCurrentUserId() {
		// TODO Auto-generated method stub
		com.google.appengine.api.users.UserService srv = com.google.appengine.api.users.UserServiceFactory.getUserService();
		User currUsr = srv.getCurrentUser();
		return currUsr.getEmail();
	}

	@Override
	public String getCurrentUserName() {
		// TODO Auto-generated method stub
		User currUsr = srv.getCurrentUser();
		return currUsr.getNickname();
	}

	@Override
	public List<String> getCurrentUserGroups(){
		// TODO Auto-generated method stub
		List<String> groupList = new ArrayList<String>();
		
		try{
			BlackstarDataAccess da = new BlackstarDataAccess();
			String usrCommonId = getCurrentUserId();
			ResultSet groups = da.executeQuery("CALL GetUserData('" + usrCommonId + "');");
						
			while(groups.next()){
				groupList.add(groups.getString("groupName"));
			}
			
			da.closeConnection();	
		}catch(Exception se){
			Logger.Log(LogLevel.ERROR, se);
		}
		
		return groupList;
	}

	@Override
	public Map<String, String> getEmployeeList(){
		BlackstarDataAccess da = new BlackstarDataAccess();
		Map<String, String> empList = new HashMap<String, String>();
		
		try{
			ResultSet employees = da.executeQuery("CALL GetDomainEmployess();");
			
			while(employees.next()){
				empList.put(employees.getString("email"), employees.getString("name"));
			}
		}catch(Exception ex){
			Logger.Log(LogLevel.ERROR, ex);
		}
		
		return empList;
	}
}
