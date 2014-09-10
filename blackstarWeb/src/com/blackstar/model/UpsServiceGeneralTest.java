package com.blackstar.model;

public class UpsServiceGeneralTest {
	
	public UpsServiceGeneralTest(Integer upsServiceGeneralTestId,
			Integer upsServiceId, Integer trasferLine,
			Integer transferEmergencyPlant, Integer backupBatteries,
			Integer verifyVoltage) {
		this.upsServiceGeneralTestId = upsServiceGeneralTestId;
		this.upsServiceId = upsServiceId;
		this.trasferLine = trasferLine;
		this.transferEmergencyPlant = transferEmergencyPlant;
		this.backupBatteries = backupBatteries;
		this.verifyVoltage = verifyVoltage;
	}
	
	private Integer upsServiceGeneralTestId;
	private Integer upsServiceId;
	private Integer trasferLine;
	private Integer transferEmergencyPlant;
	private Integer backupBatteries;
	private Integer verifyVoltage;
	
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
	public Integer getTrasferLine() {
		return trasferLine;
	}
	public void setTrasferLine(Integer trasferLine) {
		this.trasferLine = trasferLine;
	}
	public Integer getTransferEmergencyPlant() {
		return transferEmergencyPlant;
	}
	public void setTransferEmergencyPlant(Integer transferEmergencyPlant) {
		this.transferEmergencyPlant = transferEmergencyPlant;
	}
	public Integer getBackupBatteries() {
		return backupBatteries;
	}
	public void setBackupBatteries(Integer backupBatteries) {
		this.backupBatteries = backupBatteries;
	}
	public Integer getVerifyVoltage() {
		return verifyVoltage;
	}
	public void setVerifyVoltage(Integer verifyVoltage) {
		this.verifyVoltage = verifyVoltage;
	}


}
