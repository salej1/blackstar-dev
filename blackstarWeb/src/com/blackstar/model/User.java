package com.blackstar.model;

import java.util.ArrayList;
import java.util.List;

import com.blackstar.logging.*;

public class User implements java.io.Serializable {
	String userEmail;
	String userName;
	List<String> userGroups;
	
	public List<String> getUserGroups() {
		return userGroups;
	}

	public String getUserName() {
		return userName;
	}
	
	public String getUserEmail() {
		return userEmail;
	}
	
	public User(String _userName, String _email) {
		userName = _userName;
		userEmail = _email;
	}
	
	public void addGroup(String group){
		if(userGroups == null){
			userGroups = new ArrayList<String>();
		}
		
		userGroups.add(group);
	}
	
	public String getFullDescriptor() throws Exception{	
		String name = this.getUserName();
		String mainGroup;
		
		if(this.getUserGroups() != null && this.getUserGroups().size() > 0 && name.length() > 0){
			mainGroup = this.getUserGroups().get(0);
		}
		else{
			mainGroup = "Grupo Desconocido";
		}
		
		return name + ": " + mainGroup;
	}
}
