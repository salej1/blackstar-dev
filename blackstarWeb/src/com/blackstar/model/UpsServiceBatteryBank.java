package com.blackstar.model;

public class UpsServiceBatteryBank {

	public UpsServiceBatteryBank(Integer upsServiceBatteryBankId,
			Integer upsServiceId, Integer checkConnectors,
			Integer cverifyOutflow, Integer numberBatteries,
			String manufacturedDateSerial, String damageBatteries,
			String other, String temp, Integer chargeTest, String brandModel,
			String batteryVoltage) {
		this.upsServiceBatteryBankId = upsServiceBatteryBankId;
		this.upsServiceId = upsServiceId;
		this.checkConnectors = checkConnectors;
		this.cverifyOutflow = cverifyOutflow;
		this.numberBatteries = numberBatteries;
		this.manufacturedDateSerial = manufacturedDateSerial;
		this.damageBatteries = damageBatteries;
		this.other = other;
		this.temp = temp;
		this.chargeTest = chargeTest;
		this.brandModel = brandModel;
		this.batteryVoltage = batteryVoltage;
	}
	
	private Integer upsServiceBatteryBankId;
	private Integer upsServiceId;
	private Integer checkConnectors;
	private Integer cverifyOutflow;
	private Integer numberBatteries;
	private String manufacturedDateSerial;
	private String damageBatteries;
	private String other;
	private String temp;
	private Integer chargeTest;
	private String brandModel;
	private String batteryVoltage;
	public Integer getUpsServiceBatteryBankId() {
		return upsServiceBatteryBankId;
	}
	public void setUpsServiceBatteryBankId(Integer upsServiceBatteryBankId) {
		this.upsServiceBatteryBankId = upsServiceBatteryBankId;
	}
	public Integer getUpsServiceId() {
		return upsServiceId;
	}
	public void setUpsServiceId(Integer upsServiceId) {
		this.upsServiceId = upsServiceId;
	}
	public Integer getCheckConnectors() {
		return checkConnectors;
	}
	public void setCheckConnectors(Integer checkConnectors) {
		this.checkConnectors = checkConnectors;
	}
	public Integer getCverifyOutflow() {
		return cverifyOutflow;
	}
	public void setCverifyOutflow(Integer cverifyOutflow) {
		this.cverifyOutflow = cverifyOutflow;
	}
	public Integer getNumberBatteries() {
		return numberBatteries;
	}
	public void setNumberBatteries(Integer numberBatteries) {
		this.numberBatteries = numberBatteries;
	}
	public String getManufacturedDateSerial() {
		return manufacturedDateSerial;
	}
	public void setManufacturedDateSerial(String manufacturedDateSerial) {
		this.manufacturedDateSerial = manufacturedDateSerial;
	}
	public String getDamageBatteries() {
		return damageBatteries;
	}
	public void setDamageBatteries(String damageBatteries) {
		this.damageBatteries = damageBatteries;
	}
	public String getOther() {
		return other;
	}
	public void setOther(String other) {
		this.other = other;
	}
	public String getTemp() {
		return temp;
	}
	public void setTemp(String temp) {
		this.temp = temp;
	}
	public Integer getChargeTest() {
		return chargeTest;
	}
	public void setChargeTest(Integer chargeTest) {
		this.chargeTest = chargeTest;
	}
	public String getBrandModel() {
		return brandModel;
	}
	public void setBrandModel(String brandModel) {
		this.brandModel = brandModel;
	}
	public String getBatteryVoltage() {
		return batteryVoltage;
	}
	public void setBatteryVoltage(String batteryVoltage) {
		this.batteryVoltage = batteryVoltage;
	}
}
