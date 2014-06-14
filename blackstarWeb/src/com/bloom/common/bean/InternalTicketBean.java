/**
 * 
 */
package com.bloom.common.bean;

import java.io.Serializable;
import java.util.Date;

/**
 * @author Oscar.Martinez
 * 
 */
public class InternalTicketBean implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long id;

	private String officeId;
	
	private String officeName;

	private Long applicantUserId;

	private Integer serviceTypeId;

	private String serviceTypeDescr;

	private Integer statusId;
	
	private String statusDescr;

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
	
	private String createdUserEmail;
	
	
	private String additionalData1;
	private String additionalData2;
	private String additionalData3;
	private String additionalData4;
	private String additionalData5;

	
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
	public Long getApplicantUserId() {
		return applicantUserId;
	}

	/**
	 * @param applicantUserId
	 *            the applicantUserId to set
	 */
	public void setApplicantUserId(Long applicantUserId) {
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

	/**
	 * @return the createdUserEmail
	 */
	public String getCreatedUserEmail() {
		return createdUserEmail;
	}

	/**
	 * @param createdUserEmail the createdUserEmail to set
	 */
	public void setCreatedUserEmail(String createdUserEmail) {
		this.createdUserEmail = createdUserEmail;
	}

	/**
	 * @return the statusDescr
	 */
	public String getStatusDescr() {
		return statusDescr;
	}

	/**
	 * @param statusDescr the statusDescr to set
	 */
	public void setStatusDescr(String statusDescr) {
		this.statusDescr = statusDescr;
	}

	/**
	 * @return the additionalData1
	 */
	public String getAdditionalData1() {
		return additionalData1;
	}

	/**
	 * @param additionalData1 the additionalData1 to set
	 */
	public void setAdditionalData1(String additionalData1) {
		this.additionalData1 = additionalData1;
	}

	/**
	 * @return the additionalData2
	 */
	public String getAdditionalData2() {
		return additionalData2;
	}

	/**
	 * @param additionalData2 the additionalData2 to set
	 */
	public void setAdditionalData2(String additionalData2) {
		this.additionalData2 = additionalData2;
	}

	/**
	 * @return the additionalData3
	 */
	public String getAdditionalData3() {
		return additionalData3;
	}

	/**
	 * @param additionalData3 the additionalData3 to set
	 */
	public void setAdditionalData3(String additionalData3) {
		this.additionalData3 = additionalData3;
	}

	/**
	 * @return the additionalData4
	 */
	public String getAdditionalData4() {
		return additionalData4;
	}

	/**
	 * @param additionalData4 the additionalData4 to set
	 */
	public void setAdditionalData4(String additionalData4) {
		this.additionalData4 = additionalData4;
	}

	/**
	 * @return the additionalData5
	 */
	public String getAdditionalData5() {
		return additionalData5;
	}

	/**
	 * @param additionalData5 the additionalData5 to set
	 */
	public void setAdditionalData5(String additionalData5) {
		this.additionalData5 = additionalData5;
	}

}
