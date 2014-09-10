package com.blackstar.model;

import java.util.Date;

public class BatteryService {
	
	public BatteryService(Integer bbServiceId, Integer serviceOrderId,
			Integer plugClean, String plugCleanStatus,
			String plugCleanComments, Integer coverClean,
			String coverCleanStatus, String coverCleanComments,
			Integer capClean, String capCleanStatus, String capCleanComments,
			Integer groundClean, String groundCleanStatus,
			String groundCleanComments, Integer rackClean,
			String rackCleanStatus, String rackCleanComments,
			String serialNoDateManufact, String batteryTemperature,
			String voltageBus, String temperature, Date created,
			String createdBy, String createdByUsr, Date modified,
			String modifiedBy, String modifiedByUsr) {
		this.bbServiceId = bbServiceId;
		this.serviceOrderId = serviceOrderId;
		this.plugClean = plugClean;
		this.plugCleanStatus = plugCleanStatus;
		this.plugCleanComments = plugCleanComments;
		this.coverClean = coverClean;
		this.coverCleanStatus = coverCleanStatus;
		this.coverCleanComments = coverCleanComments;
		this.capClean = capClean;
		this.capCleanStatus = capCleanStatus;
		this.capCleanComments = capCleanComments;
		this.groundClean = groundClean;
		this.groundCleanStatus = groundCleanStatus;
		this.groundCleanComments = groundCleanComments;
		this.rackClean = rackClean;
		this.rackCleanStatus = rackCleanStatus;
		this.rackCleanComments = rackCleanComments;
		this.serialNoDateManufact = serialNoDateManufact;
		this.batteryTemperature = batteryTemperature;
		this.voltageBus = voltageBus;
		this.temperature = temperature;
		this.created = created;
		this.createdBy = createdBy;
		this.createdByUsr = createdByUsr;
		this.modified = modified;
		this.modifiedBy = modifiedBy;
		this.modifiedByUsr = modifiedByUsr;
	}
	
	private Integer bbServiceId;
	private Integer serviceOrderId;
	private Integer plugClean;
	private String plugCleanStatus;
	private String plugCleanComments;
	private Integer coverClean;
	private String coverCleanStatus;
	private String coverCleanComments;
	private Integer capClean;
	private String capCleanStatus;
	private String capCleanComments;
	private Integer groundClean;
	private String groundCleanStatus;
	private String groundCleanComments;
	private Integer rackClean;
	private String rackCleanStatus;
	private String rackCleanComments;
	private String serialNoDateManufact;
	private String batteryTemperature;
	private String voltageBus;
	private String temperature;
	private Date created;
	private String createdBy;
	private String createdByUsr;
	private Date modified;
	private String modifiedBy;
	private String modifiedByUsr;
	public Integer getBbServiceId() {
		return bbServiceId;
	}
	public void setBbServiceId(Integer bbServiceId) {
		this.bbServiceId = bbServiceId;
	}
	public Integer getServiceOrderId() {
		return serviceOrderId;
	}
	public void setServiceOrderId(Integer serviceOrderId) {
		this.serviceOrderId = serviceOrderId;
	}
	public Integer getPlugClean() {
		return plugClean;
	}
	public void setPlugClean(Integer plugClean) {
		this.plugClean = plugClean;
	}
	public String getPlugCleanStatus() {
		return plugCleanStatus;
	}
	public void setPlugCleanStatus(String plugCleanStatus) {
		this.plugCleanStatus = plugCleanStatus;
	}
	public String getPlugCleanComments() {
		return plugCleanComments;
	}
	public void setPlugCleanComments(String plugCleanComments) {
		this.plugCleanComments = plugCleanComments;
	}
	public Integer getCoverClean() {
		return coverClean;
	}
	public void setCoverClean(Integer coverClean) {
		this.coverClean = coverClean;
	}
	public String getCoverCleanStatus() {
		return coverCleanStatus;
	}
	public void setCoverCleanStatus(String coverCleanStatus) {
		this.coverCleanStatus = coverCleanStatus;
	}
	public String getCoverCleanComments() {
		return coverCleanComments;
	}
	public void setCoverCleanComments(String coverCleanComments) {
		this.coverCleanComments = coverCleanComments;
	}
	public Integer getCapClean() {
		return capClean;
	}
	public void setCapClean(Integer capClean) {
		this.capClean = capClean;
	}
	public String getCapCleanStatus() {
		return capCleanStatus;
	}
	public void setCapCleanStatus(String capCleanStatus) {
		this.capCleanStatus = capCleanStatus;
	}
	public String getCapCleanComments() {
		return capCleanComments;
	}
	public void setCapCleanComments(String capCleanComments) {
		this.capCleanComments = capCleanComments;
	}
	public Integer getGroundClean() {
		return groundClean;
	}
	public void setGroundClean(Integer groundClean) {
		this.groundClean = groundClean;
	}
	public String getGroundCleanStatus() {
		return groundCleanStatus;
	}
	public void setGroundCleanStatus(String groundCleanStatus) {
		this.groundCleanStatus = groundCleanStatus;
	}
	public String getGroundCleanComments() {
		return groundCleanComments;
	}
	public void setGroundCleanComments(String groundCleanComments) {
		this.groundCleanComments = groundCleanComments;
	}
	public Integer getRackClean() {
		return rackClean;
	}
	public void setRackClean(Integer rackClean) {
		this.rackClean = rackClean;
	}
	public String getRackCleanStatus() {
		return rackCleanStatus;
	}
	public void setRackCleanStatus(String rackCleanStatus) {
		this.rackCleanStatus = rackCleanStatus;
	}
	public String getRackCleanComments() {
		return rackCleanComments;
	}
	public void setRackCleanComments(String rackCleanComments) {
		this.rackCleanComments = rackCleanComments;
	}
	public String getSerialNoDateManufact() {
		return serialNoDateManufact;
	}
	public void setSerialNoDateManufact(String serialNoDateManufact) {
		this.serialNoDateManufact = serialNoDateManufact;
	}
	public String getBatteryTemperature() {
		return batteryTemperature;
	}
	public void setBatteryTemperature(String batteryTemperature) {
		this.batteryTemperature = batteryTemperature;
	}
	public String getVoltageBus() {
		return voltageBus;
	}
	public void setVoltageBus(String voltageBus) {
		this.voltageBus = voltageBus;
	}
	public String getTemperature() {
		return temperature;
	}
	public void setTemperature(String temperature) {
		this.temperature = temperature;
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
