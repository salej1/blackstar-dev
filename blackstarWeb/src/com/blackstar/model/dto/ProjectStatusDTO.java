package com.blackstar.model.dto;

import java.io.Serializable;

public class ProjectStatusDTO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private String projectStatusId;
	private String projectStatus;

	public ProjectStatusDTO() {
	}

	public String getProjectStatusId() {
		return projectStatusId;
	}

	public void setProjectStatusId(String projectStatusId) {
		this.projectStatusId = projectStatusId;
	}

	public String getProjectStatus() {
		return projectStatus;
	}

	public void setProjectStatus(String projectStatus) {
		this.projectStatus = projectStatus;
	}

}
