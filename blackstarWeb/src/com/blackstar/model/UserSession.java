package com.blackstar.model;

import java.io.Serializable;

public class UserSession implements Serializable {
	 
  private static final long serialVersionUID = -631316598591276031L;
  
  private String googleId;
  private User user;
  
  public String getGoogleId() {
	return googleId;
  }
  public void setGoogleId(String googleId) {
	this.googleId = googleId;
  }
  public User getUser() {
	return user;
  }
  public void setUser(User user) {
	this.user = user;
  } 
}
