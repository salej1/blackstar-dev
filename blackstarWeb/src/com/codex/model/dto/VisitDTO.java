package com.codex.model.dto;

import java.util.Date;

public class VisitDTO {
	int codexVisitId ;
	int cstId ;
	int codexClientId ;
	Date visitDate ;
	String description ;
	String visitStatusId ;
	Date created ;
	String createdBy ;
	String createdByUsr ;
	Date modified ;
	String modifiedBy ;
	String modifiedByUsr ;
	// CST
	String cstName;
	String cstEmail;
	// Client
	String clientName;
	// Status
	String visitStatus;

	public int getCodexVisitId() {
		return codexVisitId;
	}
	public void setCodexVisitId(int codexVisitId) {
		this.codexVisitId = codexVisitId;
	}
	public int getCstId() {
		return cstId;
	}
	public void setCstId(int cstId) {
		this.cstId = cstId;
	}
	public int getCodexClientId() {
		return codexClientId;
	}
	public void setCodexClientId(int codexClientId) {
		this.codexClientId = codexClientId;
	}
	public Date getVisitDate() {
		return visitDate;
	}
	public void setVisitDate(Date visitDate) {
		this.visitDate = visitDate;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getVisitStatusId() {
		return visitStatusId;
	}
	public void setVisitStatusId(String visitStatusId) {
		this.visitStatusId = visitStatusId;
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
	public String getCstName() {
		return cstName;
	}
	public void setCstName(String cstName) {
		this.cstName = cstName;
	}
	public String getCstEmail() {
		return cstEmail;
	}
	public void setCstEmail(String cstEmail) {
		this.cstEmail = cstEmail;
	}
	public String getClientName() {
		return clientName;
	}
	public void setClientName(String clientName) {
		this.clientName = clientName;
	}

	public String getVisitStatus(){
		return visitStatus;
	}

	public void setVisitStatus(String status){
		this.visitStatus = status;
	}
}
