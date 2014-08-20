package com.blackstar.model;

public class EmergencyPlantServiceDynamicTest {

	public EmergencyPlantServiceDynamicTest(Integer epServiceId,
			Integer epServiceDynamicTestId, String vacuumFrequency,
			String chargeFrequency, String bootTryouts, String vacuumVoltage,
			String chargeVoltage, String qualitySmoke, String startTime,
			String transferTime, String stopTime) {
		this.epServiceId = epServiceId;
		this.epServiceDynamicTestId = epServiceDynamicTestId;
		this.vacuumFrequency = vacuumFrequency;
		this.chargeFrequency = chargeFrequency;
		this.bootTryouts = bootTryouts;
		this.vacuumVoltage = vacuumVoltage;
		this.chargeVoltage = chargeVoltage;
		this.qualitySmoke = qualitySmoke;
		this.startTime = startTime;
		this.transferTime = transferTime;
		this.stopTime = stopTime;
	}
	
	private Integer epServiceId;
	private Integer epServiceDynamicTestId;
	private String vacuumFrequency;
	private String chargeFrequency;
	private String bootTryouts;
	private String vacuumVoltage;
	private String chargeVoltage;
	private String qualitySmoke;
	private String startTime;
	private String transferTime;
	private String stopTime;
	
	public Integer getEpServiceId() {
		return epServiceId;
	}
	public void setEpServiceId(Integer epServiceId) {
		this.epServiceId = epServiceId;
	}
	public Integer getEpServiceDynamicTestId() {
		return epServiceDynamicTestId;
	}
	public void setEpServiceDynamicTestId(Integer epServiceDynamicTestId) {
		this.epServiceDynamicTestId = epServiceDynamicTestId;
	}
	public String getVacuumFrequency() {
		return vacuumFrequency;
	}
	public void setVacuumFrequency(String vacuumFrequency) {
		this.vacuumFrequency = vacuumFrequency;
	}
	public String getChargeFrequency() {
		return chargeFrequency;
	}
	public void setChargeFrequency(String chargeFrequency) {
		this.chargeFrequency = chargeFrequency;
	}
	public String getBootTryouts() {
		return bootTryouts;
	}
	public void setBootTryouts(String bootTryouts) {
		this.bootTryouts = bootTryouts;
	}
	public String getVacuumVoltage() {
		return vacuumVoltage;
	}
	public void setVacuumVoltage(String vacuumVoltage) {
		this.vacuumVoltage = vacuumVoltage;
	}
	public String getChargeVoltage() {
		return chargeVoltage;
	}
	public void setChargeVoltage(String chargeVoltage) {
		this.chargeVoltage = chargeVoltage;
	}
	public String getQualitySmoke() {
		return qualitySmoke;
	}
	public void setQualitySmoke(String qualitySmoke) {
		this.qualitySmoke = qualitySmoke;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getTransferTime() {
		return transferTime;
	}
	public void setTransferTime(String transferTime) {
		this.transferTime = transferTime;
	}
	public String getStopTime() {
		return stopTime;
	}
	public void setStopTime(String stopTime) {
		this.stopTime = stopTime;
	}
		
}
