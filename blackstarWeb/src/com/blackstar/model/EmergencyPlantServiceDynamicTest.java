package com.blackstar.model;

public class EmergencyPlantServiceDynamicTest {

	public EmergencyPlantServiceDynamicTest(Integer epServiceId,
			Integer epServiceDynamicTestId, Double vacuumFrequency,
			Double chargeFrequency, Double bootTryouts, Double vacuumVoltage,
			Double chargeVoltage, Double qualitySmoke, Integer startTime,
			Integer transferTime, Integer stopTime) {
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
	private Double vacuumFrequency;
	private Double chargeFrequency;
	private Double bootTryouts;
	private Double vacuumVoltage;
	private Double chargeVoltage;
	private Double qualitySmoke;
	private Integer startTime;
	private Integer transferTime;
	private Integer stopTime;
	
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
	public Double getVacuumFrequency() {
		return vacuumFrequency;
	}
	public void setVacuumFrequency(Double vacuumFrequency) {
		this.vacuumFrequency = vacuumFrequency;
	}
	public Double getChargeFrequency() {
		return chargeFrequency;
	}
	public void setChargeFrequency(Double chargeFrequency) {
		this.chargeFrequency = chargeFrequency;
	}
	public Double getBootTryouts() {
		return bootTryouts;
	}
	public void setBootTryouts(Double bootTryouts) {
		this.bootTryouts = bootTryouts;
	}
	public Double getVacuumVoltage() {
		return vacuumVoltage;
	}
	public void setVacuumVoltage(Double vacuumVoltage) {
		this.vacuumVoltage = vacuumVoltage;
	}
	public Double getChargeVoltage() {
		return chargeVoltage;
	}
	public void setChargeVoltage(Double chargeVoltage) {
		this.chargeVoltage = chargeVoltage;
	}
	public Double getQualitySmoke() {
		return qualitySmoke;
	}
	public void setQualitySmoke(Double qualitySmoke) {
		this.qualitySmoke = qualitySmoke;
	}
	public Integer getStartTime() {
		return startTime;
	}
	public void setStartTime(Integer startTime) {
		this.startTime = startTime;
	}
	public Integer getTransferTime() {
		return transferTime;
	}
	public void setTransferTime(Integer transferTime) {
		this.transferTime = transferTime;
	}
	public Integer getStopTime() {
		return stopTime;
	}
	public void setStopTime(Integer stopTime) {
		this.stopTime = stopTime;
	}
	
	
}
