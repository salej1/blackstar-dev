package com.bloom.model.dto;

import java.util.Date;

public class TicketDetailDTO {
	
	private Integer _id;
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
    private Integer resolvedOnTime;
    private Date desiredDate;
    private boolean userCanClose;
    

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
	public Integer getResolvedOnTime() {
		return resolvedOnTime;
	}
	public void setResolvedOnTime(Integer resolvedOnTime) {
		this.resolvedOnTime = resolvedOnTime;
	}
	public void setReponseInTime(Boolean reponseInTime) {
		this.reponseInTime = reponseInTime;
	}
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
	public Integer get_id() {
		return _id;
	}
	public void set_id(Integer _id) {
		this._id = _id;
	}
	public Date getDesiredDate() {
		return desiredDate;
	}
	public void setDesiredDate(Date desiredDate) {
		this.desiredDate = desiredDate;
	}
	public boolean isUserCanClose() {
		return userCanClose;
	}
	public void setUserCanClose(boolean userCanClose) {
		this.userCanClose = userCanClose;
	}
    
}
