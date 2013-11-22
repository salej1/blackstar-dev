package com.blackstar.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.blackstar.logging.*;

public class User implements java.io.Serializable {
	String userEmail;
	String userName;
	List<String> userGroups = new ArrayList<String>();
	
	public List<String> getUserGroups() {
		return userGroups;
	}

	public String getUserName() {
		return userName;
	}
	
	public String getUserEmail() {
		return userEmail;
	}
	
	public User(String _email, String _userName) {
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

	public Map<String, Boolean> getBelongsToGroup() {
		Iterator<String> git = userGroups.iterator();
		Map<String, Boolean> retval = new HashMap<String, Boolean>();
		
		while(git.hasNext()){
			String groupName = git.next().toString();
			if(!retval.containsKey(groupName)){
				retval.put(groupName, true);
			}
		}
		
		return retval;
	}
}
