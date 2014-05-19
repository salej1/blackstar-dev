package com.bloom.model.dto;

import java.util.Date;

public class PendingAppointmentsDTO {
	
	private Integer ticketId;
	private String ticketNumber;
	private Date dueDate;
	private String description;
	private Date assignedDate;
	private String responsibleName;
	private String responsibleMail;
	private String responsibleType;
	
	public Integer getTicketId() {
		return ticketId;
	}
	public void setTicketId(Integer ticketId) {
		this.ticketId = ticketId;
	}
	public String getTicketNumber() {
		return ticketNumber;
	}
	public void setTicketNumber(String ticketNumber) {
		this.ticketNumber = ticketNumber;
	}
	public Date getDueDate() {
		return dueDate;
	}
	public void setDueDate(Date dueDate) {
		this.dueDate = dueDate;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Date getAssignedDate() {
		return assignedDate;
	}
	public void setAssignedDate(Date assignedDate) {
		this.assignedDate = assignedDate;
	}
	public String getResponsibleName() {
		return responsibleName;
	}
	public void setResponsibleName(String responsibleName) {
		this.responsibleName = responsibleName;
	}
	public String getResponsibleMail() {
		return responsibleMail;
	}
	public void setResponsibleMail(String responsibleMail) {
		this.responsibleMail = responsibleMail;
	}
	public String getResponsibleType() {
		return responsibleType;
	}
	public void setResponsibleType(String responsibleType) {
		this.responsibleType = responsibleType;
	}

}
