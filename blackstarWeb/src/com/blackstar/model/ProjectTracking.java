package com.blackstar.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * @author Mauricio Arellano
 * Entity: Historical
 * Date: 05/may/2014
*/

@Entity
@Table(name = "projectTracking", catalog = "blackstarDb")
public class ProjectTracking implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private int projectTrackingId;
	private String projectId;
	private String projectTrakingFileType;
	private String user;
	private String filePath;
	private Date trackingDate;
	
	public ProjectTracking() {
	}

	public int getProjectTrackingId() {
		return projectTrackingId;
	}

	public void setProjectTrackingId(int projectTrackingId) {
		this.projectTrackingId = projectTrackingId;
	}

	public String getProjectId() {
		return projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}

	public String getProjectTrakingFileType() {
		return projectTrakingFileType;
	}

	public void setProjectTrakingFileType(String projectTrakingFileType) {
		this.projectTrakingFileType = projectTrakingFileType;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public Date getTrackingDate() {
		return trackingDate;
	}

	public void setTrackingDate(Date trackingDate) {
		this.trackingDate = trackingDate;
	}


}
