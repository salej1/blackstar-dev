package com.blackstar.services.interfaces;

import com.blackstar.model.UserSession;

public interface SecurityService {
	
	public UserSession getSession(String code) throws Exception;
	public String getAuthorizationUrl();

}
