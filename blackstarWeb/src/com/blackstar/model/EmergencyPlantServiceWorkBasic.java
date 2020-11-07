package com.blackstar.model;

public class EmergencyPlantServiceWorkBasic {

	public EmergencyPlantServiceWorkBasic(Integer epServiceId,
			Integer epServiceWorkBasicId, Boolean washEngine,
			Boolean washRadiator, Boolean cleanWorkArea,
			Boolean conectionCheck, Boolean cleanTransfer,
			Boolean cleanCardControl, Boolean checkConectionControl,
			Boolean checkWinding, Boolean batteryTests, Boolean checkCharger,
			Boolean checkPaint, Boolean cleanGenerator) {
		this.epServiceId = epServiceId;
		this.epServiceWorkBasicId = epServiceWorkBasicId;
		this.washEngine = washEngine;
		this.washRadiator = washRadiator;
		this.cleanWorkArea = cleanWorkArea;
		this.conectionCheck = conectionCheck;
		this.cleanTransfer = cleanTransfer;
		this.cleanCardControl = cleanCardControl;
		this.checkConectionControl = checkConectionControl;
		this.checkWinding = checkWinding;
		this.batteryTests = batteryTests;
		this.checkCharger = checkCharger;
		this.checkPaint = checkPaint;
		this.cleanGenerator = cleanGenerator;
	}
	
	private Integer epServiceId;
	private Integer epServiceWorkBasicId;
	private Boolean washEngine;
	private Boolean washRadiator;
	private Boolean cleanWorkArea;
	private Boolean conectionCheck;
	private Boolean cleanTransfer;
	private Boolean cleanCardControl;
	private Boolean checkConectionControl;
	private Boolean checkWinding;
	private Boolean batteryTests;
	private Boolean checkCharger;
	private Boolean checkPaint;
	private Boolean cleanGenerator;
	
	public Integer getEpServiceId() {
		return epServiceId;
	}
	public void setEpServiceId(Integer epServiceId) {
		this.epServiceId = epServiceId;
	}
	public Integer getEpServiceWorkBasicId() {
		return epServiceWorkBasicId;
	}
	public void setEpServiceWorkBasicId(Integer epServiceWorkBasicId) {
		this.epServiceWorkBasicId = epServiceWorkBasicId;
	}
	public Boolean getWashEngine() {
		return washEngine;
	}
	public void setWashEngine(Boolean washEngine) {
		this.washEngine = washEngine;
	}
	public Boolean getWashRadiator() {
		return washRadiator;
	}
	public void setWashRadiator(Boolean washRadiator) {
		this.washRadiator = washRadiator;
	}
	public Boolean getCleanWorkArea() {
		return cleanWorkArea;
	}
	public void setCleanWorkArea(Boolean cleanWorkArea) {
		this.cleanWorkArea = cleanWorkArea;
	}
	public Boolean getConectionCheck() {
		return conectionCheck;
	}
	public void setConectionCheck(Boolean conectionCheck) {
		this.conectionCheck = conectionCheck;
	}
	public Boolean getCleanTransfer() {
		return cleanTransfer;
	}
	public void setCleanTransfer(Boolean cleanTransfer) {
		this.cleanTransfer = cleanTransfer;
	}
	public Boolean getCleanCardControl() {
		return cleanCardControl;
	}
	public void setCleanCardControl(Boolean cleanCardControl) {
		this.cleanCardControl = cleanCardControl;
	}
	public Boolean getCheckConectionControl() {
		return checkConectionControl;
	}
	public void setCheckConectionControl(Boolean checkConectionControl) {
		this.checkConectionControl = checkConectionControl;
	}
	public Boolean getCheckWinding() {
		return checkWinding;
	}
	public void setCheckWinding(Boolean checkWinding) {
		this.checkWinding = checkWinding;
	}
	public Boolean getBatteryTests() {
		return batteryTests;
	}
	public void setBatteryTests(Boolean batteryTests) {
		this.batteryTests = batteryTests;
	}
	public Boolean getCheckCharger() {
		return checkCharger;
	}
	public void setCheckCharger(Boolean checkCharger) {
		this.checkCharger = checkCharger;
	}
	public Boolean getCheckPaint() {
		return checkPaint;
	}
	public void setCheckPaint(Boolean checkPaint) {
		this.checkPaint = checkPaint;
	}
	public Boolean getCleanGenerator() {
		return cleanGenerator;
	}
	public void setCleanGenerator(Boolean cleanGenerator) {
		this.cleanGenerator = cleanGenerator;
	}
	
	
}
