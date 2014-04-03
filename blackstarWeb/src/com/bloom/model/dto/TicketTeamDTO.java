package com.bloom.model.dto;

import java.util.Date;

public class TicketTeamDTO {
	
  private Integer id;
  private Integer ticketId;
  private Integer workerRoleTypeId;
  private String workerRoleTypeName;
  private Integer blackstarUserId;
  private String blackstarUserName;
  private Date assignedDate;
  
  public Integer getId() {
	return id;
  }
  public void setId(Integer id) {
	this.id = id;
  }
  public Integer getTicketId() {
	return ticketId;
  }
  public void setTicketId(Integer ticketId) {
	this.ticketId = ticketId;
  }
  public Integer getWorkerRoleTypeId() {
	return workerRoleTypeId;
  }
  public void setWorkerRoleTypeId(Integer workerRoleTypeId) {
	this.workerRoleTypeId = workerRoleTypeId;
  }
  public String getWorkerRoleTypeName() {
	return workerRoleTypeName;
  }
  public void setWorkerRoleTypeName(String workerRoleTypeName) {
	this.workerRoleTypeName = workerRoleTypeName;
  }
  public Integer getBlackstarUserId() {
	return blackstarUserId;
  }
  public void setBlackstarUserId(Integer blackstarUserId) {
	this.blackstarUserId = blackstarUserId;
  }
  public String getBlackstarUserName() {
	return blackstarUserName;
  }
  public void setBlackstarUserName(String blackstarUserString) {
	this.blackstarUserName = blackstarUserString;
  }
  public Date getAssignedDate() {
	return assignedDate;
  }
  public void setAssignedDate(Date assignedDate) {
	this.assignedDate = assignedDate;
  }
  
}
