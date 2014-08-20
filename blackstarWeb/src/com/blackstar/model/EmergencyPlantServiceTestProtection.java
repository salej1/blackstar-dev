package com.blackstar.model;

public class EmergencyPlantServiceTestProtection {
	
	public EmergencyPlantServiceTestProtection(
			Integer epServiceTestProtectionId, String tempSensor,
			String oilSensor, String voltageSensor, String overSpeedSensor,
			String oilPreasureSensor, String waterLevelSensor,
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
	private String tempSensor;
	private String oilSensor;
	private String voltageSensor;
	private String overSpeedSensor;
	private String oilPreasureSensor;
	private String waterLevelSensor;
	
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
	public String getTempSensor() {
		return tempSensor;
	}
	public void setTempSensor(String tempSensor) {
		this.tempSensor = tempSensor;
	}
	public String getOilSensor() {
		return oilSensor;
	}
	public void setOilSensor(String oilSensor) {
		this.oilSensor = oilSensor;
	}
	public String getVoltageSensor() {
		return voltageSensor;
	}
	public void setVoltageSensor(String voltageSensor) {
		this.voltageSensor = voltageSensor;
	}
	public String getOverSpeedSensor() {
		return overSpeedSensor;
	}
	public void setOverSpeedSensor(String overSpeedSensor) {
		this.overSpeedSensor = overSpeedSensor;
	}
	public String getOilPreasureSensor() {
		return oilPreasureSensor;
	}
	public void setOilPreasureSensor(String oilPreasureSensor) {
		this.oilPreasureSensor = oilPreasureSensor;
	}
	public String getWaterLevelSensor() {
		return waterLevelSensor;
	}
	public void setWaterLevelSensor(String waterLevelSensor) {
		this.waterLevelSensor = waterLevelSensor;
	}
	
	
}
