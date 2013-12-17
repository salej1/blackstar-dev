package com.blackstar.model;

public class UpsServiceGeneralTest {
	
	public UpsServiceGeneralTest(Integer upsServiceGeneralTestId,
			Integer upsServiceId, Boolean trasferLine,
			Boolean transferEmergencyPlant, Boolean backupBatteries,
			Boolean verifyVoltage) {
		this.upsServiceGeneralTestId = upsServiceGeneralTestId;
		this.upsServiceId = upsServiceId;
		this.trasferLine = trasferLine;
		this.transferEmergencyPlant = transferEmergencyPlant;
		this.backupBatteries = backupBatteries;
		this.verifyVoltage = verifyVoltage;
	}
	
	private Integer upsServiceGeneralTestId;
	private Integer upsServiceId;
	private Boolean trasferLine;
	private Boolean transferEmergencyPlant;
	private Boolean backupBatteries;
	private Boolean verifyVoltage;
	
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
	public Boolean getTrasferLine() {
		return trasferLine;
	}
	public void setTrasferLine(Boolean trasferLine) {
		this.trasferLine = trasferLine;
	}
	public Boolean getTransferEmergencyPlant() {
		return transferEmergencyPlant;
	}
	public void setTransferEmergencyPlant(Boolean transferEmergencyPlant) {
		this.transferEmergencyPlant = transferEmergencyPlant;
	}
	public Boolean getBackupBatteries() {
		return backupBatteries;
	}
	public void setBackupBatteries(Boolean backupBatteries) {
		this.backupBatteries = backupBatteries;
	}
	public Boolean getVerifyVoltage() {
		return verifyVoltage;
	}
	public void setVerifyVoltage(Boolean verifyVoltage) {
		this.verifyVoltage = verifyVoltage;
	}


}
