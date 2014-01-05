package com.blackstar.model;

import java.util.Date;

public class UpsService {
	
	public UpsService(Integer upsServiceId, Integer serviceOrderId,
			String estatusEquipment, Boolean cleaned, Boolean hooverClean,
			Boolean verifyConnections, String capacitorStatus,
			Boolean verifyFuzz, Boolean chargerReview, String fanStatus,
			Date created, String createdBy, String createdByUsr, Date modified,
			String modifiedBy, String modifiedByUsr, String observations) {
		this.upsServiceId = upsServiceId;
		this.serviceOrderId = serviceOrderId;
		this.estatusEquipment = estatusEquipment;
		this.cleaned = cleaned;
		this.hooverClean = hooverClean;
		this.verifyConnections = verifyConnections;
		this.capacitorStatus = capacitorStatus;
		this.verifyFuzz = verifyFuzz;
		this.chargerReview = chargerReview;
		this.fanStatus = fanStatus;
		this.created = created;
		this.createdBy = createdBy;
		this.createdByUsr = createdByUsr;
		this.modified = modified;
		this.modifiedBy = modifiedBy;
		this.modifiedByUsr = modifiedByUsr;
		this.observations = observations;
	}
	
	private Integer upsServiceId;
	private Integer serviceOrderId;
	private String estatusEquipment;
	private Boolean cleaned;
	private Boolean hooverClean;
	private Boolean verifyConnections;
	private String capacitorStatus;
	private Boolean verifyFuzz;
	private Boolean chargerReview;
	private String fanStatus;
	private String observations;
	private Date created;
	private String createdBy;
	private String createdByUsr;
	private Date modified;
	private String modifiedBy;
	private String modifiedByUsr;
	
	public Integer getUpsServiceId() {
		return upsServiceId;
	}
	public void setUpsServiceId(Integer upsServiceId) {
		this.upsServiceId = upsServiceId;
	}
	public Integer getServiceOrderId() {
		return serviceOrderId;
	}
	public void setServiceOrderId(Integer serviceOrderId) {
		this.serviceOrderId = serviceOrderId;
	}
	public String getEstatusEquipment() {
		return estatusEquipment;
	}
	public void setEstatusEquipment(String estatusEquipment) {
		this.estatusEquipment = estatusEquipment;
	}
	public Boolean getCleaned() {
		return cleaned;
	}
	public void setCleaned(Boolean cleaned) {
		this.cleaned = cleaned;
	}
	public Boolean getHooverClean() {
		return hooverClean;
	}
	public void setHooverClean(Boolean hooverClean) {
		this.hooverClean = hooverClean;
	}
	public Boolean getVerifyConnections() {
		return verifyConnections;
	}
	public void setVerifyConnections(Boolean verifyConnections) {
		this.verifyConnections = verifyConnections;
	}
	public String getCapacitorStatus() {
		return capacitorStatus;
	}
	public void setCapacitorStatus(String capacitorStatus) {
		this.capacitorStatus = capacitorStatus;
	}
	public Boolean getVerifyFuzz() {
		return verifyFuzz;
	}
	public void setVerifyFuzz(Boolean verifyFuzz) {
		this.verifyFuzz = verifyFuzz;
	}
	public Boolean getChargerReview() {
		return chargerReview;
	}
	public void setChargerReview(Boolean chargerReview) {
		this.chargerReview = chargerReview;
	}
	public String getFanStatus() {
		return fanStatus;
	}
	public void setFanStatus(String fanStatus) {
		this.fanStatus = fanStatus;
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
	public String getObservations() {
		return observations;
	}
	public void setObservations(String observations) {
		this.observations = observations;
	}

}
