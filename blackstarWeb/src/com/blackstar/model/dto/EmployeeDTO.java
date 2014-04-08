package com.blackstar.model.dto;

import java.io.Serializable;

public class EmployeeDTO implements Serializable {
	
	private static final long serialVersionUID = 3609765585538661484L;
	
	String email;
	String name;
	Long userId;
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return the userId
	 */
	public Long getUserId() {
		return userId;
	}
	/**
	 * @param userId the userId to set
	 */
	public void setUserId(Long userId) {
		this.userId = userId;
	}
}
