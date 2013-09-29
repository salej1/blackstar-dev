package com.blackstar.web;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import com.blackstar.interfaces.IUserService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.*;
import com.blackstar.services.UserServiceFactory;

/**
 * Application Lifecycle Listener implementation class SessionListener
 *
 */
public class SessionListener implements HttpSessionListener {

    /**
     * Default constructor. 
     */
    public SessionListener() {
        // TODO Auto-generated constructor stub
    }

	/**
     * @see HttpSessionListener#sessionCreated(HttpSessionEvent)
     */
    public void sessionCreated(HttpSessionEvent arg0) {
        // TODO: Recuperar User de google Services
//    	IUserService dir = UserServiceFactory.getUserService();
//    	String uid = dir.getCurrentUserId();
//    	String name = dir.getCurrentUserName();
//    	String[] groups = dir.getCurrentUsetGroups();
//    	
//    	if(uid.equals("") || name.equals("") || groups.length == 0){
//    		Logger.Log(LogLevel.Fatal, "SessionListener", "Could not find current user ID", Thread.currentThread().getStackTrace().toString());
//    	}
//    	
//    	User usr = new User(uid, name);
//    	for(int i = 0; i < groups.length; i++){
//    		usr.addGroup(groups[i]);
//    	}
    }

	/**
     * @see HttpSessionListener#sessionDestroyed(HttpSessionEvent)
     */
    public void sessionDestroyed(HttpSessionEvent arg0) {
        // TODO Auto-generated method stub
    }
	
}
