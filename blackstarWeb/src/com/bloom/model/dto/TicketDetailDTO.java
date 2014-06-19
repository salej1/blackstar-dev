package com.bloom.model.dto;

import java.util.Date;

public class TicketDetailDTO {
	
	private Integer id;
	private Integer applicantUserId;
	private String applicantUserName;
	private Character officeId;
	private String officeName;
	private Integer serviceTypeId;
	private String serviceTypeName;
	private Integer statusId;
	private String statusName;
	private Integer applicantAreaId;
	private String applicantAreaName;
    private Date dueDate;
    private String project;
    private String ticketNumber;
    private String description;
    private Boolean reponseInTime;
    private Integer evaluation;
    private Float desviation;
    private Date responseDate;
    private Date created;
    private String createdBy;
    private Integer createdByUsr;
    private String createdByUsrName;
    private Date modified;
    private String modifiedBy;
    private Integer modifiedByUsr;
    private String modifiedByUsrName;
    
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getApplicantUserId() {
		return applicantUserId;
	}
	public void setApplicantUserId(Integer applicantUserId) {
		this.applicantUserId = applicantUserId;
	}
	public String getApplicantUserName() {
		return applicantUserName;
	}
	public void setApplicantUserName(String applicantUserName) {
		this.applicantUserName = applicantUserName;
	}
	public Character getOfficeId() {
		return officeId;
	}
	public void setOfficeId(Character officeId) {
		this.officeId = officeId;
	}
	public String getOfficeName() {
		return officeName;
	}
	public void setOfficeName(String officeName) {
		this.officeName = officeName;
	}
	public Integer getServiceTypeId() {
		return serviceTypeId;
	}
	public void setServiceTypeId(Integer serviceTypeId) {
		this.serviceTypeId = serviceTypeId;
	}
	public String getServiceTypeName() {
		return serviceTypeName;
	}
	public void setServiceTypeName(String serviceTypeName) {
		this.serviceTypeName = serviceTypeName;
	}
	public Integer getStatusId() {
		return statusId;
	}
	public void setStatusId(Integer statusId) {
		this.statusId = statusId;
	}
	public String getStatusName() {
		return statusName;
	}
	public void setStatusName(String statusName) {
		this.statusName = statusName;
	}
	public Integer getApplicantAreaId() {
		return applicantAreaId;
	}
	public void setApplicantAreaId(Integer applicantAreaId) {
		this.applicantAreaId = applicantAreaId;
	}
	public String getApplicantAreaName() {
		return applicantAreaName;
	}
	public void setApplicantAreaName(String applicantAreaName) {
		this.applicantAreaName = applicantAreaName;
	}
	public Date getDueDate() {
		return dueDate;
	}
	public void setDueDate(Date dueDate) {
		this.dueDate = dueDate;
	}
	public String getProject() {
		return project;
	}
	public void setProject(String project) {
		this.project = project;
	}
	public String getTicketNumber() {
		return ticketNumber;
	}
	public void setTicketNumber(String ticketNumber) {
		this.ticketNumber = ticketNumber;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Boolean getReponseInTime() {
		return reponseInTime;
	}
	public void setReponseInTime(Integer reponseInTime) {
		this.reponseInTime = reponseInTime.equals(1);
	}
	public Integer getEvaluation() {
		return evaluation;
	}
	public void setEvaluation(Integer evaluation) {
		this.evaluation = evaluation;
	}
	public Float getDesviation() {
		return desviation;
	}
	public void setDesviation(Float desviation) {
		this.desviation = desviation;
	}
	public Date getResponseDate() {
		return responseDate;
	}
	public void setResponseDate(Date responseDate) {
		this.responseDate = responseDate;
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
	public Integer getCreatedByUsr() {
		return createdByUsr;
	}
	public void setCreatedByUsr(Integer createdByUsr) {
		this.createdByUsr = createdByUsr;
	}
	public String getCreatedByUsrName() {
		return createdByUsrName;
	}
	public void setCreatedByUsrName(String createdByUsrName) {
		this.createdByUsrName = createdByUsrName;
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
	public Integer getModifiedByUsr() {
		return modifiedByUsr;
	}
	public void setModifiedByUsr(Integer modifiedByUsr) {
		this.modifiedByUsr = modifiedByUsr;
	}
	public String getModifiedByUsrName() {
		return modifiedByUsrName;
	}
	public void setModifiedByUsrName(String modifiedByUsrName) {
		this.modifiedByUsrName = modifiedByUsrName;
	}
    
}
