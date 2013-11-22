package com.blackstar.model;

import java.io.Serializable;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.services.oauth2.model.Userinfo;

public class UserSession implements Serializable {
	 
  private static final long serialVersionUID = -631316598591276031L;
  
  private transient Credential credential;
  private transient Userinfo userInfo;
  private transient User user;
  
  public Credential getCredential() {
	return credential;
  }
  public void setCredential(Credential credential) {
	this.credential = credential;
  }
  public Userinfo getUserInfo() {
	return userInfo;
  }
  public void setUserInfo(Userinfo userInfo) {
	this.userInfo = userInfo;
  }
  public User getUser() {
	return user;
  }
  public void setUser(User user) {
	this.user = user;
  }

}
