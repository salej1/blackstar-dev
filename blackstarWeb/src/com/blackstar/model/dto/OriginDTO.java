package com.blackstar.model.dto;

import java.io.Serializable;

public class OriginDTO implements Serializable {
	private static final long serialVersionUID = -7350308791188154192L;

	private Integer originId;
	private String name;

	public OriginDTO() {
	}

	public Integer getOriginId() {
		return originId;
	}

	public void setOriginId(Integer originId) {
		this.originId = originId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}
