/**
 * 
 */
package com.bloom.common.bean;

import java.util.Date;

/**
 * @author Oscar.Martinez
 * 
 */
public class InternalTicketBean {

	private Long id;

	private String officeId;
	
	private String officeName;

	private Integer applicantUserId;

	private Integer serviceTypeId;

	private String serviceTypeDescr;

	private Integer statusId;

	private Integer applicantAreaId;

	private String ticketNumber;

	private String description;

	private Integer evaluation;

	private Integer desviation;

	private Date created;

	private String createdStr;

	private String createdUserName;

	private Long createdUserId;

	private Date modified;

	private String modifiedBy;

	private Integer modifiedByUsr;

	private String petitionerArea;
	
	private Integer petitionerAreaId;

	private Date deadline;

	private String deadlineStr;
	
	private String project;
	
	private Integer reponseInTime;
	
	private DeliverableTraceBean deliverableTrace;

	
	/**
	 * @return the project
	 */
	public String getProject() {
		return project;
	}

	/**
	 * @param project the project to set
	 */
	public void setProject(String project) {
		this.project = project;
	}

	/**
	 * @return the petitionerAreaId
	 */
	public Integer getPetitionerAreaId() {
		return petitionerAreaId;
	}

	/**
	 * @param petitionerAreaId the petitionerAreaId to set
	 */
	public void setPetitionerAreaId(Integer petitionerAreaId) {
		this.petitionerAreaId = petitionerAreaId;
	}
	
	

	/**
	 * @return the createdStr
	 */
	public String getCreatedStr() {
		return createdStr;
	}

	/**
	 * @param createdStr
	 *            the createdStr to set
	 */
	public void setCreatedStr(String createdStr) {
		this.createdStr = createdStr;
	}

	/**
	 * @return the deadline
	 */
	public Date getDeadline() {
		return deadline;
	}

	/**
	 * @param deadline
	 *            the deadline to set
	 */
	public void setDeadline(Date deadline) {
		this.deadline = deadline;
	}

	/**
	 * @return the deadlineStr
	 */
	public String getDeadlineStr() {
		return deadlineStr;
	}

	/**
	 * @param deadlineStr
	 *            the deadlineStr to set
	 */
	public void setDeadlineStr(String deadlineStr) {
		this.deadlineStr = deadlineStr;
	}


	/**
	 * @return the serviceTypeDescr
	 */
	public String getServiceTypeDescr() {
		return serviceTypeDescr;
	}

	/**
	 * @param serviceTypeDescr
	 *            the serviceTypeDescr to set
	 */
	public void setServiceTypeDescr(String serviceTypeDescr) {
		this.serviceTypeDescr = serviceTypeDescr;
	}

	/**
	 * @return the petitionerArea
	 */
	public String getPetitionerArea() {
		return petitionerArea;
	}

	/**
	 * @param petitionerArea
	 *            the petitionerArea to set
	 */
	public void setPetitionerArea(String petitionerArea) {
		this.petitionerArea = petitionerArea;
	}

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the officeId
	 */
	public String getOfficeId() {
		return officeId;
	}

	/**
	 * @param officeId
	 *            the officeId to set
	 */
	public void setOfficeId(String officeId) {
		this.officeId = officeId;
	}

	/**
	 * @return the applicantUserId
	 */
	public Integer getApplicantUserId() {
		return applicantUserId;
	}

	/**
	 * @param applicantUserId
	 *            the applicantUserId to set
	 */
	public void setApplicantUserId(Integer applicantUserId) {
		this.applicantUserId = applicantUserId;
	}

	/**
	 * @return the serviceTypeId
	 */
	public Integer getServiceTypeId() {
		return serviceTypeId;
	}

	/**
	 * @param serviceTypeId
	 *            the serviceTypeId to set
	 */
	public void setServiceTypeId(Integer serviceTypeId) {
		this.serviceTypeId = serviceTypeId;
	}

	/**
	 * @return the statusId
	 */
	public Integer getStatusId() {
		return statusId;
	}

	/**
	 * @param statusId
	 *            the statusId to set
	 */
	public void setStatusId(Integer statusId) {
		this.statusId = statusId;
	}

	/**
	 * @return the applicantAreaId
	 */
	public Integer getApplicantAreaId() {
		return applicantAreaId;
	}

	/**
	 * @param applicantAreaId
	 *            the applicantAreaId to set
	 */
	public void setApplicantAreaId(Integer applicantAreaId) {
		this.applicantAreaId = applicantAreaId;
	}

	/**
	 * @return the ticketNumber
	 */
	public String getTicketNumber() {
		return ticketNumber;
	}

	/**
	 * @param ticketNumber
	 *            the ticketNumber to set
	 */
	public void setTicketNumber(String ticketNumber) {
		this.ticketNumber = ticketNumber;
	}

	/**
	 * @return the description
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @param description
	 *            the description to set
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * @return the evaluation
	 */
	public Integer getEvaluation() {
		return evaluation;
	}

	/**
	 * @param evaluation
	 *            the evaluation to set
	 */
	public void setEvaluation(Integer evaluation) {
		this.evaluation = evaluation;
	}

	/**
	 * @return the desviation
	 */
	public Integer getDesviation() {
		return desviation;
	}

	/**
	 * @param desviation
	 *            the desviation to set
	 */
	public void setDesviation(Integer desviation) {
		this.desviation = desviation;
	}

	/**
	 * @return the created
	 */
	public Date getCreated() {
		return created;
	}

	/**
	 * @param created
	 *            the created to set
	 */
	public void setCreated(Date created) {
		this.created = created;
	}



	/**
	 * @return the modified
	 */
	public Date getModified() {
		return modified;
	}

	/**
	 * @param modified
	 *            the modified to set
	 */
	public void setModified(Date modified) {
		this.modified = modified;
	}

	/**
	 * @return the officeName
	 */
	public String getOfficeName() {
		return officeName;
	}

	/**
	 * @param officeName the officeName to set
	 */
	public void setOfficeName(String officeName) {
		this.officeName = officeName;
	}

	/**
	 * @return the createdUserName
	 */
	public String getCreatedUserName() {
		return createdUserName;
	}

	/**
	 * @param createdUserName the createdUserName to set
	 */
	public void setCreatedUserName(String createdUserName) {
		this.createdUserName = createdUserName;
	}

	/**
	 * @return the createdUserId
	 */
	public Long getCreatedUserId() {
		return createdUserId;
	}

	/**
	 * @param createdUserId the createdUserId to set
	 */
	public void setCreatedUserId(Long createdUserId) {
		this.createdUserId = createdUserId;
	}

	/**
	 * @return the modifiedBy
	 */
	public String getModifiedBy() {
		return modifiedBy;
	}

	/**
	 * @param modifiedBy
	 *            the modifiedBy to set
	 */
	public void setModifiedBy(String modifiedBy) {
		this.modifiedBy = modifiedBy;
	}

	/**
	 * @return the modifiedByUsr
	 */
	public Integer getModifiedByUsr() {
		return modifiedByUsr;
	}

	/**
	 * @param modifiedByUsr
	 *            the modifiedByUsr to set
	 */
	public void setModifiedByUsr(Integer modifiedByUsr) {
		this.modifiedByUsr = modifiedByUsr;
	}

	/**
	 * @return the reponseInTime
	 */
	public Integer getReponseInTime() {
		return reponseInTime;
	}

	/**
	 * @param reponseInTime the reponseInTime to set
	 */
	public void setReponseInTime(Integer reponseInTime) {
		this.reponseInTime = reponseInTime;
	}

	/**
	 * @return the deliverableTrace
	 */
	public DeliverableTraceBean getDeliverableTrace() {
		return deliverableTrace;
	}

	/**
	 * @param deliverableTrace the deliverableTrace to set
	 */
	public void setDeliverableTrace(DeliverableTraceBean deliverableTrace) {
		this.deliverableTrace = deliverableTrace;
	}

}
