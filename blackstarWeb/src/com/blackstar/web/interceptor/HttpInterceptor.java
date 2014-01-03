package com.blackstar.web.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.blackstar.common.Globals;
import com.blackstar.services.interfaces.SecurityService;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class HttpInterceptor extends HandlerInterceptorAdapter {
	
  private SecurityService service;
	
  public void setService(SecurityService service) {
	this.service = service;
  }
  
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response
			                                   , Object handler) throws Exception {
	UserService userService = UserServiceFactory.getUserService();
	System.out.println("bsMessage => CurrentUser : " + userService.getCurrentUser());
    if((userService.getCurrentUser() == null) && (request.getSession().getAttribute(Globals
    		                                                .SESSION_KEY_PARAM) == null)) {
    	System.out.println("bsMessage => No Logged");
    	String url = service.getAuthorizationUrl();
    	response.sendRedirect(url);
    	return false;
    }	  
	return true;		
  }


}
