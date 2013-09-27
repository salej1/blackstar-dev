package com.blackstar.model;

import java.util.ArrayList;
import java.util.List;

import com.blackstar.logging.*;

public class User {
	String userId;
	List<String> userGroups;
	String userName;
	
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public List<String> getUserGroups() {
		return userGroups;
	}

	public void setUserGroups(List<String> userGroups) {
		this.userGroups = userGroups;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public User(String _userId, String _userName) {
		userId = _userId;
		userName = _userName;
	}
	
	public void addGroup(String group){
		if(userGroups == null){
			userGroups = new ArrayList<String>();
		}
		
		userGroups.add(group);
	}
	
	public String getFullDescriptor() throws Exception{	
		String name = this.getUserName();
		
		if(this.getUserGroups() != null && this.getUserGroups().size() > 0 && name.length() > 0){
			String mainGroup = this.getUserGroups().get(0);
			
			return name + ": " + mainGroup;
		}
		else{
			String msg = "Error con el usuario";
			
			if(name.length() == 0){
				msg="No se encontro nombre del usuario";
			}
			else if(this.getUserGroups() == null){
				msg="No se encontraron grupos del usuario";
			}
			else if(this.getUserGroups().size() > 0){
				msg="No se encontraron grupos del usuario";
			}
			
			Logger.Log(LogLevel.Critical, "User", msg, Thread.currentThread().getStackTrace().toString());
			throw new Exception(msg);
		}
	}
}
