package com.blackstar.model;

public class EmergencyPlantServiceTransferSwitch {

	public EmergencyPlantServiceTransferSwitch(Integer epServiceId,
			Integer epServiceTransferSwitchId, String mechanicalStatus,
			Boolean boardClean, Boolean screwAdjust, Boolean conectionAdjust,
			String systemMotors, String electricInterlock,
			String mechanicalInterlock, Integer capacityAmp) {
		this.epServiceId = epServiceId;
		this.epServiceTransferSwitchId = epServiceTransferSwitchId;
		this.mechanicalStatus = mechanicalStatus;
		this.boardClean = boardClean;
		this.screwAdjust = screwAdjust;
		this.conectionAdjust = conectionAdjust;
		this.systemMotors = systemMotors;
		this.electricInterlock = electricInterlock;
		this.mechanicalInterlock = mechanicalInterlock;
		this.capacityAmp = capacityAmp;
	}
	
	private Integer epServiceId;
	private Integer epServiceTransferSwitchId;
	private String mechanicalStatus;
	private Boolean boardClean;
	private Boolean screwAdjust;
	private Boolean conectionAdjust;
	private String systemMotors;
	private String electricInterlock;
	private String mechanicalInterlock;
	private Integer capacityAmp;
	
	public Integer getEpServiceId() {
		return epServiceId;
	}
	public void setEpServiceId(Integer epServiceId) {
		this.epServiceId = epServiceId;
	}
	public Integer getEpServiceTransferSwitchId() {
		return epServiceTransferSwitchId;
	}
	public void setEpServiceTransferSwitchId(Integer epServiceTransferSwitchId) {
		this.epServiceTransferSwitchId = epServiceTransferSwitchId;
	}
	public String getMechanicalStatus() {
		return mechanicalStatus;
	}
	public void setMechanicalStatus(String mechanicalStatus) {
		this.mechanicalStatus = mechanicalStatus;
	}
	public Boolean getBoardClean() {
		return boardClean;
	}
	public void setBoardClean(Boolean boardClean) {
		this.boardClean = boardClean;
	}
	public Boolean getScrewAdjust() {
		return screwAdjust;
	}
	public void setScrewAdjust(Boolean screwAdjust) {
		this.screwAdjust = screwAdjust;
	}
	public Boolean getConectionAdjust() {
		return conectionAdjust;
	}
	public void setConectionAdjust(Boolean conectionAdjust) {
		this.conectionAdjust = conectionAdjust;
	}
	public String getSystemMotors() {
		return systemMotors;
	}
	public void setSystemMotors(String systemMotors) {
		this.systemMotors = systemMotors;
	}
	public String getElectricInterlock() {
		return electricInterlock;
	}
	public void setElectricInterlock(String electricInterlock) {
		this.electricInterlock = electricInterlock;
	}
	public String getMechanicalInterlock() {
		return mechanicalInterlock;
	}
	public void setMechanicalInterlock(String mechanicalInterlock) {
		this.mechanicalInterlock = mechanicalInterlock;
	}
	public Integer getCapacityAmp() {
		return capacityAmp;
	}
	public void setCapacityAmp(Integer capacityAmp) {
		this.capacityAmp = capacityAmp;
	}	
}
