package com.codex.model.dto;

import java.util.Date;

public class DeliverableTraceDTO {
	// Deliverable Trace
	private  int _id  ;
	private  int codexProjectId  ;
	private  int deliverableTypeId  ;
	private  Date created ;
	private  String userId ;
	private  String createdBy ;
	private  String createdByUsr ;
	private  String documentId ;
	private  String documentName ;
	
	// User part
	private String userName;
	
	// Project part
	private String projectNumber;
	
	// DeliverableType
	private String deliverableTypeName;
	private String deliverableTypeDescription;
	
	// getters-setters
	public int get_id() {
		return _id;
	}
	public void set_id(int _id) {
		this._id = _id;
	}
	public int getCodexProjectId() {
		return codexProjectId;
	}
	public void setCodexProjectId(int codexProjectId) {
		this.codexProjectId = codexProjectId;
	}
	public int getDeliverableTypeId() {
		return deliverableTypeId;
	}
	public void setDeliverableTypeId(int deliverableTypeId) {
		this.deliverableTypeId = deliverableTypeId;
	}
	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}
	public String getCreatedByUsr() {
		return createdByUsr;
	}
	public void setCreatedByUsr(String createdByUsr) {
		this.createdByUsr = createdByUsr;
	}
	public String getDocumentId() {
		return documentId;
	}
	public void setDocumentId(String documentId) {
		this.documentId = documentId;
	}
	public String getDocumentName() {
		return documentName;
	}
	public void setDocumentName(String documentName) {
		this.documentName = documentName;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getProjectNumber() {
		return projectNumber;
	}
	public void setProjectNumber(String projectNumber) {
		this.projectNumber = projectNumber;
	}
	public String getDeliverableTypeName() {
		return deliverableTypeName;
	}
	public void setDeliverableTypeName(String deliverableTypeName) {
		this.deliverableTypeName = deliverableTypeName;
	}
	public String getDeliverableTypeDescription() {
		return deliverableTypeDescription;
	}
	public void setDeliverableTypeDescription(String deliverableTypeDescription) {
		this.deliverableTypeDescription = deliverableTypeDescription;
	}

 
}
