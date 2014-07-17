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
	private String createdUserName;
	private Long createdUserId;
	private Date modified;
	private String modifiedBy;
	private Integer modifiedByUsr;
	private String petitionerArea;
	private Integer petitionerAreaId;
	private Date deadline;
	private String project;
	private Integer reponseInTime;
	private DeliverableTraceBean deliverableTrace;
	private String createdUserEmail;
	private Date desiredDate;

	private String purposeVisitVL;
	private String purposeVisitVISAS;
	private String draftCopyDiagramVED;
	private String formProjectVED;
	private String observationsVEPI;
	private String draftCopyPlanVEPI;
	private String formProjectVEPI;
	private String observationsVRCC;
	private String checkListVRCC;
	private String formProjectVRCC;
	private String questionVPT;
	private String observationsVSA;
	private String formProjectVSA;
	private String productInformationVSP;
	private String observationsISED;
	private String draftCopyPlanISED;
	private String observationsISRC;
	private String attachmentsISRC;
	private String apparatusTraceISSM;
	private String observationsISSM;
	private String questionISPT;
	private String ticketISRPR;
	private String modelPartISRPR;
	private String observationsISRPR;
	private String productInformationISSPC;
	private String positionPGCAS;
	private String collaboratorPGCAS;
	private String justificationPGCAS;
	private String salaryPGCAS;
	private String positionPGCCP;
	private String commentsPGCCP;
	private String developmentPlanPGCCP;
	private String targetPGCCP;
	private String salaryPGCCP;
	private String positionPGCNC;
	private String developmentPlanPGCNC;
	private String targetPGCNC;
	private String salaryPGCNC;
	private String justificationPGCNC;
	private String positionPGCF;
	private String collaboratorPGCF;
	private String justificationPGCF;
	private String positionPGCAA;
	private String collaboratorPGCAA;
	private String justificationPGCAA;
	private String requisitionFormatGRC;
	private String linkDocumentGM;
	private String suggestionGSM;
	private String documentCodeGSM;
	private String justificationGSM;
	private String problemDescriptionGPTR;
	
		
	

	public String getPurposeVisitVL() {
		return purposeVisitVL;
	}

	public void setPurposeVisitVL(String purposeVisitVL) {
		this.purposeVisitVL = purposeVisitVL;
	}

	public String getPurposeVisitVISAS() {
		return purposeVisitVISAS;
	}

	public void setPurposeVisitVISAS(String purposeVisitVISAS) {
		this.purposeVisitVISAS = purposeVisitVISAS;
	}

	public String getDraftCopyDiagramVED() {
		return draftCopyDiagramVED;
	}

	public void setDraftCopyDiagramVED(String draftCopyDiagramVED) {
		this.draftCopyDiagramVED = draftCopyDiagramVED;
	}

	public String getFormProjectVED() {
		return formProjectVED;
	}

	public void setFormProjectVED(String formProjectVED) {
		this.formProjectVED = formProjectVED;
	}

	public String getObservationsVEPI() {
		return observationsVEPI;
	}

	public void setObservationsVEPI(String observationsVEPI) {
		this.observationsVEPI = observationsVEPI;
	}

	public String getDraftCopyPlanVEPI() {
		return draftCopyPlanVEPI;
	}

	public void setDraftCopyPlanVEPI(String draftCopyPlanVEPI) {
		this.draftCopyPlanVEPI = draftCopyPlanVEPI;
	}

	public String getFormProjectVEPI() {
		return formProjectVEPI;
	}

	public void setFormProjectVEPI(String formProjectVEPI) {
		this.formProjectVEPI = formProjectVEPI;
	}

	public String getObservationsVRCC() {
		return observationsVRCC;
	}

	public void setObservationsVRCC(String observationsVRCC) {
		this.observationsVRCC = observationsVRCC;
	}

	public String getCheckListVRCC() {
		return checkListVRCC;
	}

	public void setCheckListVRCC(String checkListVRCC) {
		this.checkListVRCC = checkListVRCC;
	}

	public String getFormProjectVRCC() {
		return formProjectVRCC;
	}

	public void setFormProjectVRCC(String formProjectVRCC) {
		this.formProjectVRCC = formProjectVRCC;
	}

	public String getQuestionVPT() {
		return questionVPT;
	}

	public void setQuestionVPT(String questionVPT) {
		this.questionVPT = questionVPT;
	}

	public String getObservationsVSA() {
		return observationsVSA;
	}

	public void setObservationsVSA(String observationsVSA) {
		this.observationsVSA = observationsVSA;
	}

	public String getFormProjectVSA() {
		return formProjectVSA;
	}

	public void setFormProjectVSA(String formProjectVSA) {
		this.formProjectVSA = formProjectVSA;
	}

	public String getProductInformationVSP() {
		return productInformationVSP;
	}

	public void setProductInformationVSP(String productInformationVSP) {
		this.productInformationVSP = productInformationVSP;
	}

	public String getObservationsISED() {
		return observationsISED;
	}

	public void setObservationsISED(String observationsISED) {
		this.observationsISED = observationsISED;
	}

	public String getDraftCopyPlanISED() {
		return draftCopyPlanISED;
	}

	public void setDraftCopyPlanISED(String draftCopyPlanISED) {
		this.draftCopyPlanISED = draftCopyPlanISED;
	}

	public String getObservationsISRC() {
		return observationsISRC;
	}

	public void setObservationsISRC(String observationsISRC) {
		this.observationsISRC = observationsISRC;
	}

	public String getAttachmentsISRC() {
		return attachmentsISRC;
	}

	public void setAttachmentsISRC(String attachmentsISRC) {
		this.attachmentsISRC = attachmentsISRC;
	}

	public String getApparatusTraceISSM() {
		return apparatusTraceISSM;
	}

	public void setApparatusTraceISSM(String apparatusTraceISSM) {
		this.apparatusTraceISSM = apparatusTraceISSM;
	}

	public String getObservationsISSM() {
		return observationsISSM;
	}

	public void setObservationsISSM(String observationsISSM) {
		this.observationsISSM = observationsISSM;
	}

	public String getQuestionISPT() {
		return questionISPT;
	}

	public void setQuestionISPT(String questionISPT) {
		this.questionISPT = questionISPT;
	}

	public String getTicketISRPR() {
		return ticketISRPR;
	}

	public void setTicketISRPR(String ticketISRPR) {
		this.ticketISRPR = ticketISRPR;
	}

	public String getModelPartISRPR() {
		return modelPartISRPR;
	}

	public void setModelPartISRPR(String modelPartISRPR) {
		this.modelPartISRPR = modelPartISRPR;
	}

	public String getObservationsISRPR() {
		return observationsISRPR;
	}

	public void setObservationsISRPR(String observationsISRPR) {
		this.observationsISRPR = observationsISRPR;
	}

	public String getProductInformationISSPC() {
		return productInformationISSPC;
	}

	public void setProductInformationISSPC(String productInformationISSPC) {
		this.productInformationISSPC = productInformationISSPC;
	}

	public String getPositionPGCAS() {
		return positionPGCAS;
	}

	public void setPositionPGCAS(String positionPGCAS) {
		this.positionPGCAS = positionPGCAS;
	}

	public String getCollaboratorPGCAS() {
		return collaboratorPGCAS;
	}

	public void setCollaboratorPGCAS(String collaboratorPGCAS) {
		this.collaboratorPGCAS = collaboratorPGCAS;
	}

	public String getJustificationPGCAS() {
		return justificationPGCAS;
	}

	public void setJustificationPGCAS(String justificationPGCAS) {
		this.justificationPGCAS = justificationPGCAS;
	}

	public String getSalaryPGCAS() {
		return salaryPGCAS;
	}

	public void setSalaryPGCAS(String salaryPGCAS) {
		this.salaryPGCAS = salaryPGCAS;
	}

	public String getPositionPGCCP() {
		return positionPGCCP;
	}

	public void setPositionPGCCP(String positionPGCCP) {
		this.positionPGCCP = positionPGCCP;
	}

	public String getCommentsPGCCP() {
		return commentsPGCCP;
	}

	public void setCommentsPGCCP(String commentsPGCCP) {
		this.commentsPGCCP = commentsPGCCP;
	}

	public String getDevelopmentPlanPGCCP() {
		return developmentPlanPGCCP;
	}

	public void setDevelopmentPlanPGCCP(String developmentPlanPGCCP) {
		this.developmentPlanPGCCP = developmentPlanPGCCP;
	}

	public String getTargetPGCCP() {
		return targetPGCCP;
	}

	public void setTargetPGCCP(String targetPGCCP) {
		this.targetPGCCP = targetPGCCP;
	}

	public String getSalaryPGCCP() {
		return salaryPGCCP;
	}

	public void setSalaryPGCCP(String salaryPGCCP) {
		this.salaryPGCCP = salaryPGCCP;
	}

	public String getPositionPGCNC() {
		return positionPGCNC;
	}

	public void setPositionPGCNC(String positionPGCNC) {
		this.positionPGCNC = positionPGCNC;
	}

	public String getDevelopmentPlanPGCNC() {
		return developmentPlanPGCNC;
	}

	public void setDevelopmentPlanPGCNC(String developmentPlanPGCNC) {
		this.developmentPlanPGCNC = developmentPlanPGCNC;
	}

	public String getTargetPGCNC() {
		return targetPGCNC;
	}

	public void setTargetPGCNC(String targetPGCNC) {
		this.targetPGCNC = targetPGCNC;
	}

	public String getSalaryPGCNC() {
		return salaryPGCNC;
	}

	public void setSalaryPGCNC(String salaryPGCNC) {
		this.salaryPGCNC = salaryPGCNC;
	}

	public String getJustificationPGCNC() {
		return justificationPGCNC;
	}

	public void setJustificationPGCNC(String justificationPGCNC) {
		this.justificationPGCNC = justificationPGCNC;
	}

	public String getPositionPGCF() {
		return positionPGCF;
	}

	public void setPositionPGCF(String positionPGCF) {
		this.positionPGCF = positionPGCF;
	}

	public String getCollaboratorPGCF() {
		return collaboratorPGCF;
	}

	public void setCollaboratorPGCF(String collaboratorPGCF) {
		this.collaboratorPGCF = collaboratorPGCF;
	}

	public String getJustificationPGCF() {
		return justificationPGCF;
	}

	public void setJustificationPGCF(String justificationPGCF) {
		this.justificationPGCF = justificationPGCF;
	}

	public String getPositionPGCAA() {
		return positionPGCAA;
	}

	public void setPositionPGCAA(String positionPGCAA) {
		this.positionPGCAA = positionPGCAA;
	}

	public String getCollaboratorPGCAA() {
		return collaboratorPGCAA;
	}

	public void setCollaboratorPGCAA(String collaboratorPGCAA) {
		this.collaboratorPGCAA = collaboratorPGCAA;
	}

	public String getJustificationPGCAA() {
		return justificationPGCAA;
	}

	public void setJustificationPGCAA(String justificationPGCAA) {
		this.justificationPGCAA = justificationPGCAA;
	}

	public String getRequisitionFormatGRC() {
		return requisitionFormatGRC;
	}

	public void setRequisitionFormatGRC(String requisitionFormatGRC) {
		this.requisitionFormatGRC = requisitionFormatGRC;
	}

	public String getLinkDocumentGM() {
		return linkDocumentGM;
	}

	public void setLinkDocumentGM(String linkDocumentGM) {
		this.linkDocumentGM = linkDocumentGM;
	}

	public String getSuggestionGSM() {
		return suggestionGSM;
	}

	public void setSuggestionGSM(String suggestionGSM) {
		this.suggestionGSM = suggestionGSM;
	}

	public String getDocumentCodeGSM() {
		return documentCodeGSM;
	}

	public void setDocumentCodeGSM(String documentCodeGSM) {
		this.documentCodeGSM = documentCodeGSM;
	}

	public String getJustificationGSM() {
		return justificationGSM;
	}

	public void setJustificationGSM(String justificationGSM) {
		this.justificationGSM = justificationGSM;
	}

	public String getProblemDescriptionGPTR() {
		return problemDescriptionGPTR;
	}

	public void setProblemDescriptionGPTR(String problemDescriptionGPTR) {
		this.problemDescriptionGPTR = problemDescriptionGPTR;
	}

	
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

	public Date getDesiredDate() {
		return desiredDate;
	}

	public void setDesiredDate(Date desiredDate) {
		this.desiredDate = desiredDate;
	}



}
