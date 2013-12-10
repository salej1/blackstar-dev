package com.blackstar.services.impl;

import java.io.FileReader;
import java.io.IOException;
import java.util.List;

import com.blackstar.common.Globals;
import com.blackstar.db.DAOFactory;
import com.blackstar.model.UserSession;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.SecurityService;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.appengine.auth.oauth2.AppEngineCredentialStore;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeRequestUrl;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.services.oauth2.Oauth2;
import com.google.api.services.oauth2.model.Userinfo;

public class SecurityServiceImpl extends AbstractService implements SecurityService {
	
  private GoogleClientSecrets clientSecrets;
  
  private String secretsPath;
  private  List<String> authorities;
  private static AppEngineCredentialStore credentialStore = new AppEngineCredentialStore();

  public void setSecretsPath(String secretsPath) {
	this.secretsPath = SecurityServiceImpl.class.getClassLoader().getResource(secretsPath).getPath();
  }
	
  public void setAuthorities(List<String> authorities){
	this.authorities = authorities;
  }
	
  public void init() throws Exception{
	  clientSecrets = GoogleClientSecrets.load(Globals.JSON_FACTORY, new FileReader(secretsPath));
  }
  
  public UserSession getSession(String code) throws Exception{
	UserSession userSession = new UserSession();
	Credential credential = null;
	Userinfo userInfo = null;
	try{
		credential = getCredential(code);
		userInfo = getOauth2Service(credential).userinfo().get().execute();
		userSession.setGoogleId(userInfo.getId());
		userSession.setUser(DAOFactory.getDAOFactory(DAOFactory.MYSQL).getUserDAO()
				                                .getUserById(userInfo.getEmail()));
		credentialStore.store(userSession.getGoogleId(), credential);
	} catch(Exception e){
		
	}
	return userSession;
  }
  
  public Credential getStoredCredential(String userId) {
	Credential credential = buildEmpty();
	if (credentialStore.load(userId, credential)) {
	  return credential;
	}
	return null;
	}
  
  public String getAuthorizationUrl() {
	GoogleAuthorizationCodeRequestUrl urlBuilder = new GoogleAuthorizationCodeRequestUrl(
	          clientSecrets.getWeb().getClientId(), clientSecrets.getWeb().getRedirectUris().get(0),
	                                authorities).setAccessType("offline").setApprovalPrompt("auto");
	return urlBuilder.build();
  }
  
  private Credential getCredential(String code) throws IOException{
	GoogleTokenResponse response = new GoogleAuthorizationCodeTokenRequest(Globals.HTTP_TRANSPORT
			      , Globals.JSON_FACTORY,clientSecrets.getWeb().getClientId(),clientSecrets.getWeb()
			   .getClientSecret(), code, clientSecrets.getWeb().getRedirectUris().get(0)).execute();
	return buildEmpty().setAccessToken(response.getAccessToken());
  }
  
  private Credential buildEmpty() {
	return new GoogleCredential.Builder().setClientSecrets(this.clientSecrets)
	                                     .setTransport(Globals.HTTP_TRANSPORT)
	                                     .setJsonFactory(Globals.JSON_FACTORY)
	                                     .build();
  }
  
  
  private Oauth2 getOauth2Service(Credential credential) {
	 return new Oauth2.Builder(Globals.HTTP_TRANSPORT, Globals.JSON_FACTORY, credential).build();
  }

}
