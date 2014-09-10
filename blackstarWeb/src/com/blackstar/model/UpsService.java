package com.blackstar.model;

import java.util.Date;

public class UpsService {
	
	public UpsService(Integer upsServiceId, Integer serviceOrderId,
			String estatusEquipment, Integer cleaned, Integer hooverClean,
			Integer verifyConnections, String capacitorStatus,
			Integer verifyFuzz, Integer chargerReview, String fanStatus,
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
	private Integer cleaned;
	private Integer hooverClean;
	private Integer verifyConnections;
	private String capacitorStatus;
	private Integer verifyFuzz;
	private Integer chargerReview;
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
	public Integer getCleaned() {
		return cleaned;
	}
	public void setCleaned(Integer cleaned) {
		this.cleaned = cleaned;
	}
	public Integer getHooverClean() {
		return hooverClean;
	}
	public void setHooverClean(Integer hooverClean) {
		this.hooverClean = hooverClean;
	}
	public Integer getVerifyConnections() {
		return verifyConnections;
	}
	public void setVerifyConnections(Integer verifyConnections) {
		this.verifyConnections = verifyConnections;
	}
	public String getCapacitorStatus() {
		return capacitorStatus;
	}
	public void setCapacitorStatus(String capacitorStatus) {
		this.capacitorStatus = capacitorStatus;
	}
	public Integer getVerifyFuzz() {
		return verifyFuzz;
	}
	public void setVerifyFuzz(Integer verifyFuzz) {
		this.verifyFuzz = verifyFuzz;
	}
	public Integer getChargerReview() {
		return chargerReview;
	}
	public void setChargerReview(Integer chargerReview) {
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
