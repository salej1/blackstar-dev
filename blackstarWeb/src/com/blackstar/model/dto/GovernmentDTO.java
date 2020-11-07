package com.blackstar.model.dto;

import java.io.Serializable;

public class GovernmentDTO implements Serializable
{
	private static final long serialVersionUID = -7350308791188154192L;

	private Integer governmentId;
	private String name;

	public GovernmentDTO()
	{
	}

	public Integer getGovernmentId() {
		return governmentId;
	}
	
	public void setGovernmentId(Integer governmentId) {
		this.governmentId = governmentId;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
}
