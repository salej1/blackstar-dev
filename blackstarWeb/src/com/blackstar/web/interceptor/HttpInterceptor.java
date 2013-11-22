package com.blackstar.web.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.blackstar.common.Globals;
import com.blackstar.services.interfaces.SecurityService;

public class HttpInterceptor extends HandlerInterceptorAdapter {
	
  private SecurityService service;
	
  public void setService(SecurityService service) {
	this.service = service;
  }
  
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response
			                                   , Object handler) throws Exception {
    if(request.getSession().getAttribute(Globals.SESSION_KEY_PARAM) == null){
    	response.sendRedirect(service.getAuthorizationUrl());
    }	  
	return true;		
  }


}
