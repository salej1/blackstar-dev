package com.blackstar.model;

public class EmergencyPlantServiceTestProtection {
	
	public EmergencyPlantServiceTestProtection(
			Integer epServiceTestProtectionId, Integer tempSensor,
			Integer oilSensor, Integer voltageSensor, Integer overSpeedSensor,
			Integer oilPreasureSensor, Integer waterLevelSensor,
			Integer epServiceId) {
		this.epServiceTestProtectionId = epServiceTestProtectionId;
		this.tempSensor = tempSensor;
		this.oilSensor = oilSensor;
		this.voltageSensor = voltageSensor;
		this.overSpeedSensor = overSpeedSensor;
		this.oilPreasureSensor = oilPreasureSensor;
		this.waterLevelSensor = waterLevelSensor;
		this.epServiceId = epServiceId;
	}
	
	private Integer epServiceId;
	private Integer epServiceTestProtectionId;
	private Integer tempSensor;
	private Integer oilSensor;
	private Integer voltageSensor;
	private Integer overSpeedSensor;
	private Integer oilPreasureSensor;
	private Integer waterLevelSensor;
	
	public Integer getEpServiceId() {
		return epServiceId;
	}
	public void setEpServiceId(Integer epServiceId) {
		this.epServiceId = epServiceId;
	}
	public Integer getEpServiceTestProtectionId() {
		return epServiceTestProtectionId;
	}
	public void setEpServiceTestProtectionId(Integer epServiceTestProtectionId) {
		this.epServiceTestProtectionId = epServiceTestProtectionId;
	}
	public Integer getTempSensor() {
		return tempSensor;
	}
	public void setTempSensor(Integer tempSensor) {
		this.tempSensor = tempSensor;
	}
	public Integer getOilSensor() {
		return oilSensor;
	}
	public void setOilSensor(Integer oilSensor) {
		this.oilSensor = oilSensor;
	}
	public Integer getVoltageSensor() {
		return voltageSensor;
	}
	public void setVoltageSensor(Integer voltageSensor) {
		this.voltageSensor = voltageSensor;
	}
	public Integer getOverSpeedSensor() {
		return overSpeedSensor;
	}
	public void setOverSpeedSensor(Integer overSpeedSensor) {
		this.overSpeedSensor = overSpeedSensor;
	}
	public Integer getOilPreasureSensor() {
		return oilPreasureSensor;
	}
	public void setOilPreasureSensor(Integer oilPreasureSensor) {
		this.oilPreasureSensor = oilPreasureSensor;
	}
	public Integer getWaterLevelSensor() {
		return waterLevelSensor;
	}
	public void setWaterLevelSensor(Integer waterLevelSensor) {
		this.waterLevelSensor = waterLevelSensor;
	}
}
