package com.blackstar.model;

import java.util.Date;

public class ScheduledService {
	private int scheduledServiceId;
	private String serviceStatusId;
	private String description;
	private Integer openCustomerId;
	private Date created;
	private String createdBy;
	private String createdByUsr;
	private Date modified;
	private String modifiedBy;
	private String modifiedByUsr;
	private String project;
	private String serviceContact;
	private String serviceContactEmail;
	private String officeId;
	
	public String getOfficeId() {
		if(officeId != null){
			return officeId.substring(0,1);
		}
		else{
			return null;
		}
	}
	public void setOfficeId(String officeId) {
		this.officeId = officeId;
	}
	public int getScheduledServiceId() {
		return scheduledServiceId;
	}
	public void setScheduledServiceId(int scheduledServiceId) {
		this.scheduledServiceId = scheduledServiceId;
	}
	public String getServiceStatusId() {
		return serviceStatusId;
	}
	public void setServiceStatusId(String serviceStatusId) {
		this.serviceStatusId = serviceStatusId;
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
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Integer getOpenCustomerId() {
		return openCustomerId;
	}
	public void setOpenCustomerId(Integer openCustomerId) {
		this.openCustomerId = openCustomerId;
	}
	public String getProject() {
		return project;
	}
	public void setProject(String project) {
		this.project = project;
	}
	public String getServiceContact() {
		return serviceContact;
	}
	public void setServiceContact(String serviceContact) {
		this.serviceContact = serviceContact;
	}
	public String getServiceContactEmail() {
		return serviceContactEmail;
	}
	public void setServiceContactEmail(String serviceContactEmail) {
		this.serviceContactEmail = serviceContactEmail;
	}
}
