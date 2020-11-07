package com.blackstar.model;

public class EmergencyPlantServiceLectures {
	
	public EmergencyPlantServiceLectures(Integer epServiceId,
			Integer epServiceLecturesId, Integer voltageABAN,
			Integer voltageACCN, Integer voltageBCBN, Integer voltageNT,
			Integer currentA, Integer currentB, Integer currentC,
			Integer frequency, Integer oilPreassure, Integer temp) {
		this.epServiceId = epServiceId;
		this.epServiceLecturesId = epServiceLecturesId;
		this.voltageABAN = voltageABAN;
		this.voltageACCN = voltageACCN;
		this.voltageBCBN = voltageBCBN;
		this.voltageNT = voltageNT;
		this.currentA = currentA;
		this.currentB = currentB;
		this.currentC = currentC;
		this.frequency = frequency;
		this.oilPreassure = oilPreassure;
		this.temp = temp;
	}
	
	private Integer epServiceId;
	private Integer epServiceLecturesId;
	private Integer voltageABAN;
	private Integer voltageACCN;
	private Integer voltageBCBN;
	private Integer voltageNT;
	private Integer currentA;
	private Integer currentB;
	private Integer currentC;
	private Integer frequency;
	private Integer oilPreassure;
	private Integer temp;
	
	public Integer getEpServiceId() {
		return epServiceId;
	}
	public void setEpServiceId(Integer epServiceId) {
		this.epServiceId = epServiceId;
	}
	public Integer getEpServiceLecturesId() {
		return epServiceLecturesId;
	}
	public void setEpServiceLecturesId(Integer epServiceLecturesId) {
		this.epServiceLecturesId = epServiceLecturesId;
	}
	public Integer getVoltageABAN() {
		return voltageABAN;
	}
	public void setVoltageABAN(Integer voltageABAN) {
		this.voltageABAN = voltageABAN;
	}
	public Integer getVoltageACCN() {
		return voltageACCN;
	}
	public void setVoltageACCN(Integer voltageACCN) {
		this.voltageACCN = voltageACCN;
	}
	public Integer getVoltageBCBN() {
		return voltageBCBN;
	}
	public void setVoltageBCBN(Integer voltageBCBN) {
		this.voltageBCBN = voltageBCBN;
	}
	public Integer getVoltageNT() {
		return voltageNT;
	}
	public void setVoltageNT(Integer voltageNT) {
		this.voltageNT = voltageNT;
	}
	public Integer getCurrentA() {
		return currentA;
	}
	public void setCurrentA(Integer currentA) {
		this.currentA = currentA;
	}
	public Integer getCurrentB() {
		return currentB;
	}
	public void setCurrentB(Integer currentB) {
		this.currentB = currentB;
	}
	public Integer getCurrentC() {
		return currentC;
	}
	public void setCurrentC(Integer currentC) {
		this.currentC = currentC;
	}
	public Integer getFrequency() {
		return frequency;
	}
	public void setFrequency(Integer frequency) {
		this.frequency = frequency;
	}
	public Integer getOilPreassure() {
		return oilPreassure;
	}
	public void setOilPreassure(Integer oilPreassure) {
		this.oilPreassure = oilPreassure;
	}
	public Integer getTemp() {
		return temp;
	}
	public void setTemp(Integer temp) {
		this.temp = temp;
	}

}
