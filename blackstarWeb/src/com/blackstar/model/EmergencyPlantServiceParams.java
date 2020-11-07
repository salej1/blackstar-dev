package com.blackstar.model;

public class EmergencyPlantServiceParams {

	public EmergencyPlantServiceParams(Integer epServiceId,
			Integer epServiceParamsId, String adjsutmentTherm, String current,
			String batteryCurrent, String clockStatus,
			String trasnferTypeProtection, String generatorTypeProtection) {
		this.epServiceId = epServiceId;
		this.epServiceParamsId = epServiceParamsId;
		this.adjsutmentTherm = adjsutmentTherm;
		this.current = current;
		this.batteryCurrent = batteryCurrent;
		this.clockStatus = clockStatus;
		this.trasnferTypeProtection = trasnferTypeProtection;
		this.generatorTypeProtection = generatorTypeProtection;
	}
	
	private Integer epServiceId;
	private Integer epServiceParamsId;
	private String adjsutmentTherm;
	private String current;
	private String batteryCurrent;
	private String clockStatus;
	private String trasnferTypeProtection;
	private String generatorTypeProtection;
	
	public Integer getEpServiceId() {
		return epServiceId;
	}
	public void setEpServiceId(Integer epServiceId) {
		this.epServiceId = epServiceId;
	}
	public Integer getEpServiceParamsId() {
		return epServiceParamsId;
	}
	public void setEpServiceParamsId(Integer epServiceParamsId) {
		this.epServiceParamsId = epServiceParamsId;
	}
	public String getAdjsutmentTherm() {
		return adjsutmentTherm;
	}
	public void setAdjsutmentTherm(String adjsutmentTherm) {
		this.adjsutmentTherm = adjsutmentTherm;
	}
	public String getCurrent() {
		return current;
	}
	public void setCurrent(String current) {
		this.current = current;
	}
	public String getBatteryCurrent() {
		return batteryCurrent;
	}
	public void setBatteryCurrent(String batteryCurrent) {
		this.batteryCurrent = batteryCurrent;
	}
	public String getClockStatus() {
		return clockStatus;
	}
	public void setClockStatus(String clockStatus) {
		this.clockStatus = clockStatus;
	}
	public String getTrasnferTypeProtection() {
		return trasnferTypeProtection;
	}
	public void setTrasnferTypeProtection(String trasnferTypeProtection) {
		this.trasnferTypeProtection = trasnferTypeProtection;
	}
	public String getGeneratorTypeProtection() {
		return generatorTypeProtection;
	}
	public void setGeneratorTypeProtection(String generatorTypeProtection) {
		this.generatorTypeProtection = generatorTypeProtection;
	}
	
}
