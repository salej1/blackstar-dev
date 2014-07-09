package com.blackstar.model.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import com.blackstar.model.Issue;

public class IssueDTO implements Serializable{

	private static final long serialVersionUID = 4840679374540141508L;

	private String referenceTypeId;
	private Integer referenceId;
	private String referenceNumber;
	private String referenceStatusId;
	private String referenceStatus;
	private String title;
	private String detail;
	private String project;
	private String customer;
	private String referenceAsignee;
	private Date created;
	private String createdBy;
	private String createdByUsr;
	private Date modified;
	private String modifiedBy;
	private String modifiedByUsr; 
	private List<FollowUpDTO> followUpList;
	private String resolution;
	private Date dueDate;
	
	public String getResolution() {
		return resolution;
	}

	public void setResolution(String resolution) {
		this.resolution = resolution;
	}

	public IssueDTO(){
		
	}
	
	public IssueDTO(Issue issue){
		this.referenceTypeId = "I";
		this.referenceId = issue.getIssueId();
		this.referenceNumber = issue.getIssueNumber();
		this.referenceStatusId = issue.getIssueStatusId();
		this.title = issue.getTitle();
		this.detail = issue.getDetail();
		this.project = issue.getProject();
		this.customer = issue.getCustomer();
		this.referenceAsignee = issue.getAsignee();
		this.created = issue.getCreated();
		this.createdBy = issue.getCreatedBy();
		this.createdByUsr = issue.getCreatedByUsr();
		this.modified = issue.getModified();
		this.modifiedBy = issue.getModifiedBy();
		this.modifiedByUsr  = issue.getModifiedByUsr();
		this.dueDate = issue.getDueDate();
	}
	
	public String getReferenceTypeId() {
		return referenceTypeId;
	}
	public void setReferenceTypeId(String referenceTypeId) {
		this.referenceTypeId = referenceTypeId;
	}
	public Integer getReferenceId() {
		return referenceId;
	}
	public void setReferenceId(Integer referenceId) {
		this.referenceId = referenceId;
	}
	public String getReferenceNumber() {
		return referenceNumber;
	}
	public void setReferenceNumber(String referenceNumber) {
		this.referenceNumber = referenceNumber;
	}
	public String getReferenceStatusId() {
		if(referenceStatusId != null && referenceStatusId.length() > 0){
			return referenceStatusId.substring(0, 1);	
		}else{
			return null;
		}
	}
	public void setReferenceStatusId(String referenceStatusId) {
		this.referenceStatusId = referenceStatusId;
	}
	public String getReferenceStatus() {
		return referenceStatus;
	}
	public void setReferenceStatus(String referenceStatus) {
		this.referenceStatus = referenceStatus;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	public String getProject() {
		return project;
	}
	public void setProject(String project) {
		this.project = project;
	}
	public String getCustomer() {
		return customer;
	}
	public void setCustomer(String customer) {
		this.customer = customer;
	}
	public String getReferenceAsignee() {
		return referenceAsignee;
	}
	public void setReferenceAsignee(String asignee) {
		this.referenceAsignee = asignee;
	}
	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
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
	public Date getModified() {
		return modified;
	}
	public void setModified(Date modified) {
		this.modified = modified;
	}
	public String getModifiedBy() {
		return modifiedBy;
	}
	public void setModifiedBy(String modifiedBy) {
		this.modifiedBy = modifiedBy;
	}
	public String getModifiedByUsr() {
		return modifiedByUsr;
	}
	public void setModifiedByUsr(String modifiedByUsr) {
		this.modifiedByUsr = modifiedByUsr;
	}
	public List<FollowUpDTO> getFollowUpList() {
		return followUpList;
	}
	public void setFollowUpList(List<FollowUpDTO> followUpList) {
		this.followUpList = followUpList;
	}

	public Date getDueDate() {
		return dueDate;
	}

	public void setDueDate(Date dueDate) {
		this.dueDate = dueDate;
	}
	
}
