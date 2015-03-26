package com.blackstar.model.dto;

import java.io.Serializable;

public class SellerDTO implements Serializable {
	private static final long serialVersionUID = -7350308791188154192L;

	private Integer blackstarUserId;
	private String name;
	private String email;

	public SellerDTO() {
	}

	public Integer getBlackstarUserId() {
		return blackstarUserId;
	}

	public void setBlackstarUserId(Integer blackstarUserId) {
		this.blackstarUserId = blackstarUserId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
}
