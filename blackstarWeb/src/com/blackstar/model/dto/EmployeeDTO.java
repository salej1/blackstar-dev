package com.blackstar.model.dto;

import java.io.Serializable;

public class EmployeeDTO implements Serializable {

	private static final long serialVersionUID = 3609765585538661484L;

	private Integer id;
	private String email;
	private String name;
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
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Long getUserId() {
		return userId;
	}
	public void setUserId(Long userId) {
		this.userId = userId;
	}
}