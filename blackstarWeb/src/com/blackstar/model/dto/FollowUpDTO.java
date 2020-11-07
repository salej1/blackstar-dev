package com.blackstar.model.dto;

public class FollowUpDTO {
	public FollowUpDTO(){
		
	}
	
	public FollowUpDTO(String timeStamp, String asignee, String createdBy,
			String followUp) {
		super();
		this.timeStamp = timeStamp;
		this.asignee = asignee;
		this.createdBy = createdBy;
		this.followUp = followUp;
	}
	private String timeStamp;
	private String asignee;
	private String createdBy;
	private String followUp;
	
	public String getFollowUp() {
		return followUp;
	}
	public void setFollowUp(String follwUp) {
		this.followUp = follwUp;
	}
	public String getTimeStamp() {
		return timeStamp;
	}
	public void setTimeStamp(String timeStamp) {
		this.timeStamp = timeStamp;
	}
	public String getAsignee() {
		return asignee;
	}
	public void setAsignee(String asignee) {
		this.asignee = asignee;
	}
	public String getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}
}
