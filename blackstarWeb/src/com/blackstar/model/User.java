package com.blackstar.model;

import com.blackstar.logging.*;

public class User {
	String _userId;
	public String get_userId() {
		return _userId;
	}
	
	String[] _userGroups;
	public String[] get_userGroups() {
		return _userGroups;
	}
	
	String _userName;
	public String get_userName() {
		return _userName;
	}
	
	public User(String id) {
		// TODO Auto-generated constructor stub
	}
	
	public String getFullDescriptor() throws Exception{	
		String name = this.get_userName();
		
		if(this.get_userGroups() != null && this.get_userGroups().length > 0 && name.length() > 0){
			String mainGroup = this.get_userGroups()[0];
			
			return name + ": " + mainGroup;
		}
		else{
			String msg = "Error con el usuario";
			
			if(name.length() == 0){
				msg="No se encontro nombre del usuario";
			}
			else if(this.get_userGroups() == null){
				msg="No se encontraron grupos del usuario";
			}
			else if(this.get_userGroups().length > 0){
				msg="No se encontraron grupos del usuario";
			}
			
			Logger.Log(LogLevel.Critical, "User", msg, Thread.currentThread().getStackTrace().toString());
			throw new Exception(msg);
		}
	}
}
