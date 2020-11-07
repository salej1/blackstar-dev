package com.blackstar.model;

import java.util.Date;

public class PlainService {
	
	
	public PlainService(Integer plainServiceId, Integer serviceOrderId,
			String troubleDescription, String techParam, String workDone,
			String materialUsed, String observations, Date created,
			String createdBy, String createdByUsr, Date modified,
			String modifiedBy, String modifiedByUsr) {
		this.plainServiceId = plainServiceId;
		this.serviceOrderId = serviceOrderId;
		this.troubleDescription = troubleDescription;
		this.techParam = techParam;
		this.workDone = workDone;
		this.materialUsed = materialUsed;
		this.observations = observations;
		this.created = created;
		this.createdBy = createdBy;
		this.createdByUsr = createdByUsr;
		this.modified = modified;
		this.modifiedBy = modifiedBy;
		this.modifiedByUsr = modifiedByUsr;
	}
	
	private Integer plainServiceId;
	private Integer serviceOrderId;
	private String troubleDescription;
	private String techParam;
	private String workDone;
	private String materialUsed;
	private String observations;
	private Date created;
	private String createdBy;
	private String createdByUsr;
	private Date modified;
	private String modifiedBy;
	private String modifiedByUsr;


	public Integer getPlainServiceId() {
		return plainServiceId;
	}
	public void setPlainServiceId(Integer plainServiceId) {
		this.plainServiceId = plainServiceId;
	}
	public Integer getServiceOrderId() {
		return serviceOrderId;
	}
	public void setServiceOrderId(Integer serviceOrderId) {
		this.serviceOrderId = serviceOrderId;
	}
	public String getTroubleDescription() {
		return troubleDescription;
	}
	public void setTroubleDescription(String troubleDescription) {
		this.troubleDescription = troubleDescription;
	}
	public String getTechParam() {
		return techParam;
	}
	public void setTechParam(String techParam) {
		this.techParam = techParam;
	}
	public String getWorkDone() {
		return workDone;
	}
	public void setWorkDone(String workDone) {
		this.workDone = workDone;
	}
	public String getMaterialUsed() {
		return materialUsed;
	}
	public void setMaterialUsed(String materialUsed) {
		this.materialUsed = materialUsed;
	}
	public String getObservations() {
		return observations;
	}
	public void setObservations(String observations) {
		this.observations = observations;
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

	
}
