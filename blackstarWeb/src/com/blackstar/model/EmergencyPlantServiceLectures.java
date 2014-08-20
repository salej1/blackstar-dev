package com.blackstar.model;

public class EmergencyPlantServiceLectures {
	
	public EmergencyPlantServiceLectures(Integer epServiceId,
			Integer epServiceLecturesId, String voltageABAN,
			String voltageACCN, String voltageBCBN, String voltageNT,
			String currentA, String currentB, String currentC,
			String frequency, String oilPreassure, String temp) {
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
	private String voltageABAN;
	private String voltageACCN;
	private String voltageBCBN;
	private String voltageNT;
	private String currentA;
	private String currentB;
	private String currentC;
	private String frequency;
	private String oilPreassure;
	private String temp;
	
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
	public String getVoltageABAN() {
		return voltageABAN;
	}
	public void setVoltageABAN(String voltageABAN) {
		this.voltageABAN = voltageABAN;
	}
	public String getVoltageACCN() {
		return voltageACCN;
	}
	public void setVoltageACCN(String voltageACCN) {
		this.voltageACCN = voltageACCN;
	}
	public String getVoltageBCBN() {
		return voltageBCBN;
	}
	public void setVoltageBCBN(String voltageBCBN) {
		this.voltageBCBN = voltageBCBN;
	}
	public String getVoltageNT() {
		return voltageNT;
	}
	public void setVoltageNT(String voltageNT) {
		this.voltageNT = voltageNT;
	}
	public String getCurrentA() {
		return currentA;
	}
	public void setCurrentA(String currentA) {
		this.currentA = currentA;
	}
	public String getCurrentB() {
		return currentB;
	}
	public void setCurrentB(String currentB) {
		this.currentB = currentB;
	}
	public String getCurrentC() {
		return currentC;
	}
	public void setCurrentC(String currentC) {
		this.currentC = currentC;
	}
	public String getFrequency() {
		return frequency;
	}
	public void setFrequency(String frequency) {
		this.frequency = frequency;
	}
	public String getOilPreassure() {
		return oilPreassure;
	}
	public void setOilPreassure(String oilPreassure) {
		this.oilPreassure = oilPreassure;
	}
	public String getTemp() {
		return temp;
	}
	public void setTemp(String temp) {
		this.temp = temp;
	}
	

}
