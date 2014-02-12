package com.blackstar.services.impl;

import java.io.FileReader;
import java.io.IOException;
import java.util.List;

import com.blackstar.common.Globals;
import com.blackstar.db.dao.interfaces.UserDAO;
import com.blackstar.model.User;
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

@SuppressWarnings("deprecation")
public class SecurityServiceImpl extends AbstractService implements SecurityService {
	
  private GoogleClientSecrets clientSecrets;
  
  private String secretsPath;
  private  List<String> authorities;
  private static AppEngineCredentialStore credentialStore;
  private UserDAO uDAO;
  private String domain;

  static{
	  credentialStore = new AppEngineCredentialStore();
  }
    
  public UserSession getSession(String code) throws Exception{
	UserSession userSession = new UserSession();
	Credential credential = null;
	Userinfo userInfo = null;
	User user = null;
	try{
		credential = getCredential(code);
		userInfo = getOauth2Service(credential).userinfo().get().execute();
		if((user = uDAO.getUserById(userInfo.getEmail())) == null){
		  if(userInfo.getEmail().indexOf(domain) > 0){
			 user = getGenericUser(userInfo);
		   } else {
			 return null;
		   }
		}
		userSession.setGoogleId(userInfo.getId());
		userSession.setUser(user);
		credentialStore.store(userSession.getGoogleId(), credential);
	} catch(Exception e){
		e.printStackTrace();
		return null;
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
	GoogleAuthorizationCodeRequestUrl urlBuilder = null; 
	urlBuilder = new GoogleAuthorizationCodeRequestUrl(clientSecrets.getWeb()
			  .getClientId(), clientSecrets.getWeb().getRedirectUris().get(0),
	         authorities).setAccessType("offline").setApprovalPrompt("auto");
	return urlBuilder.build();
  }
  
  private Credential getCredential(String code) throws IOException{
	GoogleTokenResponse response = null; 
	response = new GoogleAuthorizationCodeTokenRequest(Globals.HTTP_TRANSPORT
	              , Globals.JSON_FACTORY,clientSecrets.getWeb().getClientId()
			      ,clientSecrets.getWeb().getClientSecret(), code, clientSecrets
			                      .getWeb().getRedirectUris().get(0)).execute();
	return buildEmpty().setAccessToken(response.getAccessToken());
  }
  
  private Credential buildEmpty() {
	return new GoogleCredential.Builder().setClientSecrets(this.clientSecrets)
	                                     .setTransport(Globals.HTTP_TRANSPORT)
	                                     .setJsonFactory(Globals.JSON_FACTORY)
	                                     .build();
  }
  
  
  private Oauth2 getOauth2Service(Credential credential) {
	 return new Oauth2.Builder(Globals.HTTP_TRANSPORT, Globals.JSON_FACTORY
			                                         , credential).build();
  }

  public void setuDAO(UserDAO uDAO) {
	this.uDAO = uDAO;
  }

  public void setSecretsPath(String secretsPath) {
	this.secretsPath = SecurityServiceImpl.class.getClassLoader()
			                 .getResource(secretsPath).getPath();
  }
	
  public void setAuthorities(List<String> authorities){
	this.authorities = authorities;
  }
  
  public void setDomain(String domain) {
	this.domain = domain;
  }
	
  public void init() throws Exception{
	clientSecrets = GoogleClientSecrets.load(Globals.JSON_FACTORY
			                      , new FileReader(secretsPath));
  }
  
  private User getGenericUser(Userinfo userInfo){
	 User user = new User(userInfo.getEmail(), userInfo.getName());
	 user.addGroup("Grupo SAC");
	 return user;
  }

}
