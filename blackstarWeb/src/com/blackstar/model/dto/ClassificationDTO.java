package com.blackstar.model.dto;

import java.io.Serializable;

public class ClassificationDTO implements Serializable
{
	private static final long serialVersionUID = -7350308791188154192L;

	private Integer classificationId;
	private String name;

	public ClassificationDTO()
	{
	}

	public Integer getClassificationId() {
		return classificationId;
	}
	
	public void setClassificationId(Integer classificationId) {
		this.classificationId = classificationId;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
}
