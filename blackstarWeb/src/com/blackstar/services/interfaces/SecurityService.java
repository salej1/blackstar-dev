package com.blackstar.services.interfaces;

import com.blackstar.model.UserSession;
import com.google.api.client.auth.oauth2.Credential;

public interface SecurityService {
	
	public UserSession getSession(String code) throws Exception;
	public String getAuthorizationUrl();
	public Credential getStoredCredential(String userId);

}
