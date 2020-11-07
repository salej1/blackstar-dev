package com.blackstar.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * @author Mauricio Arellano
 * Entity: Historical
 * Date: 05/may/2014
*/

@Entity
@Table(name = "projectstatus", catalog = "blackstarDb")
public class ProjectStatus implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private String projectStatusId;
	private String projectStatus;
	
	public ProjectStatus() {
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
