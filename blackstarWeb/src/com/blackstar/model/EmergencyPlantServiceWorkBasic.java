package com.blackstar.model;

public class EmergencyPlantServiceWorkBasic {

	public EmergencyPlantServiceWorkBasic(Integer epServiceId,
			Integer epServiceWorkBasicId, Integer washEngine,
			Integer washRadiator, Integer cleanWorkArea,
			Integer conectionCheck, Integer cleanTransfer,
			Integer cleanCardControl, Integer checkConectionControl,
			Integer checkWinding, Integer batteryTests, Integer checkCharger,
			Integer checkPaint, Integer cleanGenerator) {
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
	private Integer washEngine;
	private Integer washRadiator;
	private Integer cleanWorkArea;
	private Integer conectionCheck;
	private Integer cleanTransfer;
	private Integer cleanCardControl;
	private Integer checkConectionControl;
	private Integer checkWinding;
	private Integer batteryTests;
	private Integer checkCharger;
	private Integer checkPaint;
	private Integer cleanGenerator;
	
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
	public Integer getWashEngine() {
		return washEngine;
	}
	public void setWashEngine(Integer washEngine) {
		this.washEngine = washEngine;
	}
	public Integer getWashRadiator() {
		return washRadiator;
	}
	public void setWashRadiator(Integer washRadiator) {
		this.washRadiator = washRadiator;
	}
	public Integer getCleanWorkArea() {
		return cleanWorkArea;
	}
	public void setCleanWorkArea(Integer cleanWorkArea) {
		this.cleanWorkArea = cleanWorkArea;
	}
	public Integer getConectionCheck() {
		return conectionCheck;
	}
	public void setConectionCheck(Integer conectionCheck) {
		this.conectionCheck = conectionCheck;
	}
	public Integer getCleanTransfer() {
		return cleanTransfer;
	}
	public void setCleanTransfer(Integer cleanTransfer) {
		this.cleanTransfer = cleanTransfer;
	}
	public Integer getCleanCardControl() {
		return cleanCardControl;
	}
	public void setCleanCardControl(Integer cleanCardControl) {
		this.cleanCardControl = cleanCardControl;
	}
	public Integer getCheckConectionControl() {
		return checkConectionControl;
	}
	public void setCheckConectionControl(Integer checkConectionControl) {
		this.checkConectionControl = checkConectionControl;
	}
	public Integer getCheckWinding() {
		return checkWinding;
	}
	public void setCheckWinding(Integer checkWinding) {
		this.checkWinding = checkWinding;
	}
	public Integer getBatteryTests() {
		return batteryTests;
	}
	public void setBatteryTests(Integer batteryTests) {
		this.batteryTests = batteryTests;
	}
	public Integer getCheckCharger() {
		return checkCharger;
	}
	public void setCheckCharger(Integer checkCharger) {
		this.checkCharger = checkCharger;
	}
	public Integer getCheckPaint() {
		return checkPaint;
	}
	public void setCheckPaint(Integer checkPaint) {
		this.checkPaint = checkPaint;
	}
	public Integer getCleanGenerator() {
		return cleanGenerator;
	}
	public void setCleanGenerator(Integer cleanGenerator) {
		this.cleanGenerator = cleanGenerator;
	}
	
	
}
