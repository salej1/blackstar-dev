package com.blackstar.model.dto;

import java.io.Serializable;
import java.util.Date;

/**
 * 
 * @author Mauricio Arellano
 *
 */
public class ProjectFollowUpDTO implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private int projectFollowUpId;
	private String projectId;
	private Date followUpDate;
	private int userAssigner;
	private int userAssigned;
	private String comment;
	
	public ProjectFollowUpDTO() {
	}

	public int getProjectFollowUpId() {
		return projectFollowUpId;
	}

	public void setProjectFollowUpId(int projectFollowUpId) {
		this.projectFollowUpId = projectFollowUpId;
	}

	public String getProjectId() {
		return projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}

	public Date getFollowUpDate() {
		return followUpDate;
	}

	public void setFollowUpDate(Date followUpDate) {
		this.followUpDate = followUpDate;
	}

	public int getUserAssigner() {
		return userAssigner;
	}

	public void setUserAssigner(int userAssigner) {
		this.userAssigner = userAssigner;
	}

	public int getUserAssigned() {
		return userAssigned;
	}

	public void setUserAssigned(int userAssigned) {
		this.userAssigned = userAssigned;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

}
