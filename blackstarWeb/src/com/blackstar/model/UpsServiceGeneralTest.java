package com.blackstar.model;

public class UpsServiceGeneralTest {
	
	public UpsServiceGeneralTest(Integer upsServiceGeneralTestId,
			Integer upsServiceId, Double trasferLine,
			Double transferEmergencyPlant, Double backupBatteries,
			Double verifyVoltage) {
		this.upsServiceGeneralTestId = upsServiceGeneralTestId;
		this.upsServiceId = upsServiceId;
		this.trasferLine = trasferLine;
		this.transferEmergencyPlant = transferEmergencyPlant;
		this.backupBatteries = backupBatteries;
		this.verifyVoltage = verifyVoltage;
	}
	
	private Integer upsServiceGeneralTestId;
	private Integer upsServiceId;
	private Double trasferLine;
	private Double transferEmergencyPlant;
	private Double backupBatteries;
	private Double verifyVoltage;
	
	public Integer getUpsServiceGeneralTestId() {
		return upsServiceGeneralTestId;
	}
	public void setUpsServiceGeneralTestId(Integer upsServiceGeneralTestId) {
		this.upsServiceGeneralTestId = upsServiceGeneralTestId;
	}
	public Integer getUpsServiceId() {
		return upsServiceId;
	}
	public void setUpsServiceId(Integer upsServiceId) {
		this.upsServiceId = upsServiceId;
	}
	public Double getTrasferLine() {
		return trasferLine;
	}
	public void setTrasferLine(Double trasferLine) {
		this.trasferLine = trasferLine;
	}
	public Double getTransferEmergencyPlant() {
		return transferEmergencyPlant;
	}
	public void setTransferEmergencyPlant(Double transferEmergencyPlant) {
		this.transferEmergencyPlant = transferEmergencyPlant;
	}
	public Double getBackupBatteries() {
		return backupBatteries;
	}
	public void setBackupBatteries(Double backupBatteries) {
		this.backupBatteries = backupBatteries;
	}
	public Double getVerifyVoltage() {
		return verifyVoltage;
	}
	public void setVerifyVoltage(Double verifyVoltage) {
		this.verifyVoltage = verifyVoltage;
	}


}
