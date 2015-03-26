package com.codex.vo;

import java.util.Date;

public class DeliverableVO {
	
  private Integer id;
  private Integer projectId;
  private String projectNumber;
  private Integer deliverableTypeId;
  private String deliverableTypeDescription;
  private Date created;
  private Integer userId;
  private String userName;
  
  public Integer getId() {
	return id;
  }
  public void setId(Integer id) {
	this.id = id;
  }
  public Integer getProjectId() {
	return projectId;
  }
  public void setProjectId(Integer projectId) {
	this.projectId = projectId;
  }
  public String getProjectNumber() {
	return projectNumber;
  }
  public void setProjectNumber(String projectNumber) {
	this.projectNumber = projectNumber;
  }
  public Integer getDeliverableTypeId() {
	return deliverableTypeId;
  }
  public void setDeliverableTypeId(Integer deliverableTypeId) {
	this.deliverableTypeId = deliverableTypeId;
  }
  public String getDeliverableTypeDescription() {
	return deliverableTypeDescription;
  }
  public void setDeliverableTypeDescription(String deliverableTypeDescription) {
	this.deliverableTypeDescription = deliverableTypeDescription;
  }
  public Date getCreated() {
	return created;
  }
  public void setCreated(Date created) {
	this.created = created;
  }
  public Integer getUserId() {
	return userId;
  }
  public void setUserId(Integer userId) {
	this.userId = userId;
  }
  public String getUserName() {
	return userName;
  }
  public void setUserName(String userName) {
	this.userName = userName;
  }

}
