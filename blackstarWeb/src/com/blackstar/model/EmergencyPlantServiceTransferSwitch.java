package com.blackstar.model;

public class EmergencyPlantServiceTransferSwitch {

	public EmergencyPlantServiceTransferSwitch(Integer epServiceId,
			Integer epServiceTransferSwitchId, String mechanicalStatus,
			Integer boardClean, Integer screwAdjust,Integer lampTest, Integer conectionAdjust,
			String systemMotors, String electricInterlock,
			String mechanicalInterlock, String capacityAmp) {
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
		this.lampTest = lampTest;
	}
	
	private Integer epServiceId;
	private Integer epServiceTransferSwitchId;
	private String mechanicalStatus;
	private Integer boardClean;
	private Integer screwAdjust;
	private Integer lampTest;
	private Integer conectionAdjust;
	private String systemMotors;
	private String electricInterlock;
	private String mechanicalInterlock;
	private String capacityAmp;
	
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
	public Integer getBoardClean() {
		return boardClean;
	}
	public void setBoardClean(Integer boardClean) {
		this.boardClean = boardClean;
	}
	public Integer getScrewAdjust() {
		return screwAdjust;
	}
	public void setScrewAdjust(Integer screwAdjust) {
		this.screwAdjust = screwAdjust;
	}
	public Integer getConectionAdjust() {
		return conectionAdjust;
	}
	public void setConectionAdjust(Integer conectionAdjust) {
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
	public String getCapacityAmp() {
		return capacityAmp;
	}
	public void setCapacityAmp(String capacityAmp) {
		this.capacityAmp = capacityAmp;
	}
	public Integer getLampTest() {
		return lampTest;
	}
	public void setLampTest(Integer lampTest) {
		this.lampTest = lampTest;
	}	
}
