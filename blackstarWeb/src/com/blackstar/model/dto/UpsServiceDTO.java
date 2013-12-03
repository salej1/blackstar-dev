package com.blackstar.model.dto;

import com.blackstar.model.UpsService;
import com.blackstar.model.UpsServiceBatteryBank;
import com.blackstar.model.UpsServiceGeneralTest;
import com.blackstar.model.UpsServiceParams;

public class UpsServiceDTO {
	
	public UpsServiceDTO()
	{
		
	}
	
	public UpsServiceDTO(UpsServicePolicyDTO upsService)
	{
		this.serviceOrderId = upsService.getServiceOrderId();
		this.upsServiceId = upsService.getUpsServiceId();
		this.estatusEquipment = upsService.getEstatusEquipment();
		this.cleaned = upsService.getCleaned();
		this.hooverClean = upsService.getHooverClean();
		this.verifyConnections = upsService.getVerifyConnections();
		this.capacitorStatus = upsService.getCapacitorStatus();
		this.verifyFuzz = upsService.getVerifyFuzz();
		this.chargerReview = upsService.getChargerReview();
		this.fanStatus = upsService.getFanStatus();
		this.observations = upsService.getObservations();
		
		this.upsServiceBatteryBankId = upsService.getUpsServiceBatteryBankId();
		this.checkConnectors = upsService.getCheckConnectors();
		this.cverifyOutflow = upsService.getCverifyOutflow();
		this.numberBatteries = upsService.getNumberBatteries();
		this.manufacturedDateSerial = upsService.getManufacturedDateSerial();
		this.damageBatteries = upsService.getDamageBatteries();
		this.other = upsService.getOther();
		this.temp = upsService.getTemp();
		this.chargeTest = upsService.getChargeTest();
		this.brandModel = upsService.getBrandModel();
		this.batteryVoltage = upsService.getBatteryVoltage();
		
		this.upsServiceGeneralTestId = upsService.getUpsServiceGeneralTestId();
		this.trasferLine = upsService.getTrasferLine();
		this.transferEmergencyPlant = upsService.getTransferEmergencyPlant();
		this.backupBatteries = upsService.getBackupBatteries();
		this.verifyVoltage = upsService.getVerifyVoltage();
		
		this.upsServiceParamsId = upsService.getUpsServiceParamsId();
		this.inputVoltagePhase = upsService.getInputVoltagePhase();
		this.inputVoltageNeutro = upsService.getInputVoltageNeutro();
		this.inputVoltageNeutroGround = upsService.getInputVoltageNeutroGround();
		this.percentCharge = upsService.getPercentCharge();
		this.outputVoltagePhase = upsService.getOutputVoltagePhase();
		this.outputVoltageNeutro = upsService.getOutputVoltageNeutro();
		this.inOutFrecuency = upsService.getInOutFrecuency();
		this.busVoltage = upsService.getBusVoltage();
	}
	
	
	
	public UpsServiceDTO (UpsService upsService, UpsServiceBatteryBank upsServiceBatteryBank, UpsServiceGeneralTest upsServiceGeneralTest, UpsServiceParams upsServiceParams)
	{
		this.upsServiceId = upsService.getUpsServiceId();
		this.serviceOrderId = upsService.getServiceOrderId();
		
		this.estatusEquipment = upsService.getEstatusEquipment();
		this.cleaned = upsService.getCleaned();
		this.hooverClean = upsService.getHooverClean();
		this.verifyConnections = upsService.getVerifyConnections();
		this.capacitorStatus = upsService.getCapacitorStatus();
		this.verifyFuzz = upsService.getVerifyFuzz();
		this.chargerReview = upsService.getChargerReview();
		this.fanStatus = upsService.getFanStatus();
		this.observations = upsService.getObservations();
		
		this.upsServiceBatteryBankId = upsServiceBatteryBank.getUpsServiceBatteryBankId();
		this.checkConnectors = upsServiceBatteryBank.getCheckConnectors();
		this.cverifyOutflow = upsServiceBatteryBank.getCverifyOutflow();
		this.numberBatteries = upsServiceBatteryBank.getNumberBatteries();
		this.manufacturedDateSerial = upsServiceBatteryBank.getManufacturedDateSerial();
		this.damageBatteries = upsServiceBatteryBank.getDamageBatteries();
		this.other = upsServiceBatteryBank.getOther();
		this.temp = upsServiceBatteryBank.getTemp();
		this.chargeTest = upsServiceBatteryBank.getChargeTest();
		this.brandModel = upsServiceBatteryBank.getBrandModel();
		this.batteryVoltage = upsServiceBatteryBank.getBatteryVoltage();
		
		this.upsServiceGeneralTestId = upsServiceGeneralTest.getUpsServiceGeneralTestId();
		this.trasferLine = upsServiceGeneralTest.getTrasferLine();
		this.transferEmergencyPlant = upsServiceGeneralTest.getTransferEmergencyPlant();
		this.backupBatteries = upsServiceGeneralTest.getBackupBatteries();
		this.verifyVoltage = upsServiceGeneralTest.getVerifyVoltage();
		
		this.upsServiceParamsId = upsServiceParams.getUpsServiceParamsId();
		this.inputVoltagePhase = upsServiceParams.getInputVoltagePhase();
		this.inputVoltageNeutro = upsServiceParams.getInputVoltageNeutro();
		this.inputVoltageNeutroGround = upsServiceParams.getInputVoltageNeutroGround();
		this.percentCharge = upsServiceParams.getPercentCharge();
		this.outputVoltagePhase = upsServiceParams.getOutputVoltagePhase();
		this.outputVoltageNeutro = upsServiceParams.getOutputVoltageNeutro();
		this.inOutFrecuency = upsServiceParams.getInOutFrecuency();
		this.busVoltage = upsServiceParams.getBusVoltage();
	}
			
	public UpsServiceDTO(Integer upsServiceId, Integer serviceOrderId,
			String estatusEquipment, Boolean cleaned, Boolean hooverClean,
			Boolean verifyConnections, String capacitorStatus,
			Boolean verifyFuzz, Boolean chargerReview, String fanStatus,
			Integer upsServiceBatteryBankId, Boolean checkConnectors,
			Boolean cverifyOutflow, Integer numberBatteries,
			String manufacturedDateSerial, String damageBatteries,
			String other, Double temp, Boolean chargeTest, String brandModel,
			Double batteryVoltage, Integer upsServiceGeneralTestId,
			Double trasferLine, Double transferEmergencyPlant,
			Double backupBatteries, Double verifyVoltage,
			Integer upsServiceParamsId, Double inputVoltagePhase,
			Double inputVoltageNeutro, Double inputVoltageNeutroGround,
			Double percentCharge, Double outputVoltagePhase,
			Double outputVoltageNeutro, Double inOutFrecuency, Double busVoltage, String observations) {
		this.upsServiceId = upsServiceId;
		this.serviceOrderId = serviceOrderId;
		this.estatusEquipment = estatusEquipment;
		this.cleaned = cleaned;
		this.hooverClean = hooverClean;
		this.verifyConnections = verifyConnections;
		this.capacitorStatus = capacitorStatus;
		this.verifyFuzz = verifyFuzz;
		this.chargerReview = chargerReview;
		this.fanStatus = fanStatus;
		this.upsServiceBatteryBankId = upsServiceBatteryBankId;
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
		this.upsServiceGeneralTestId = upsServiceGeneralTestId;
		this.trasferLine = trasferLine;
		this.transferEmergencyPlant = transferEmergencyPlant;
		this.backupBatteries = backupBatteries;
		this.verifyVoltage = verifyVoltage;
		this.upsServiceParamsId = upsServiceParamsId;
		this.inputVoltagePhase = inputVoltagePhase;
		this.inputVoltageNeutro = inputVoltageNeutro;
		this.inputVoltageNeutroGround = inputVoltageNeutroGround;
		this.percentCharge = percentCharge;
		this.outputVoltagePhase = outputVoltagePhase;
		this.outputVoltageNeutro = outputVoltageNeutro;
		this.inOutFrecuency = inOutFrecuency;
		this.busVoltage = busVoltage;
		this.observations = observations;
	}
	
	private Integer upsServiceId;
	private Integer serviceOrderId;
	
	private String estatusEquipment;
	private Boolean cleaned;
	private Boolean hooverClean;
	private Boolean verifyConnections;
	private String capacitorStatus;
	private Boolean verifyFuzz;
	private Boolean chargerReview;
	private String fanStatus;
	private String observations;

	private Integer upsServiceBatteryBankId;
	private Boolean checkConnectors;
	private Boolean cverifyOutflow;
	private Integer numberBatteries;
	private String manufacturedDateSerial;
	private String damageBatteries;
	private String other;
	private Double temp;
	private Boolean chargeTest;
	private String brandModel;
	private Double batteryVoltage;

	private Integer upsServiceGeneralTestId;
	private Double trasferLine;
	private Double transferEmergencyPlant;
	private Double backupBatteries;
	private Double verifyVoltage;

	private Integer upsServiceParamsId;
	private Double inputVoltagePhase;
	private Double inputVoltageNeutro;
	private Double inputVoltageNeutroGround;
	private Double percentCharge;
	private Double outputVoltagePhase;
	private Double outputVoltageNeutro;
	private Double inOutFrecuency;
	private Double busVoltage;
	
	public Integer getUpsServiceId() {
		return upsServiceId;
	}
	public void setUpsServiceId(Integer upsServiceId) {
		this.upsServiceId = upsServiceId;
	}
	public Integer getServiceOrderId() {
		return serviceOrderId;
	}
	public void setServiceOrderId(Integer serviceOrderId) {
		this.serviceOrderId = serviceOrderId;
	}
	public String getEstatusEquipment() {
		return estatusEquipment;
	}
	public void setEstatusEquipment(String estatusEquipment) {
		this.estatusEquipment = estatusEquipment;
	}
	public Boolean getCleaned() {
		return cleaned;
	}
	public void setCleaned(Boolean cleaned) {
		this.cleaned = cleaned;
	}
	public Boolean getHooverClean() {
		return hooverClean;
	}
	public void setHooverClean(Boolean hooverClean) {
		this.hooverClean = hooverClean;
	}
	public Boolean getVerifyConnections() {
		return verifyConnections;
	}
	public void setVerifyConnections(Boolean verifyConnections) {
		this.verifyConnections = verifyConnections;
	}
	public String getCapacitorStatus() {
		return capacitorStatus;
	}
	public void setCapacitorStatus(String capacitorStatus) {
		this.capacitorStatus = capacitorStatus;
	}
	public Boolean getVerifyFuzz() {
		return verifyFuzz;
	}
	public void setVerifyFuzz(Boolean verifyFuzz) {
		this.verifyFuzz = verifyFuzz;
	}
	public Boolean getChargerReview() {
		return chargerReview;
	}
	public void setChargerReview(Boolean chargerReview) {
		this.chargerReview = chargerReview;
	}
	public String getFanStatus() {
		return fanStatus;
	}
	public void setFanStatus(String fanStatus) {
		this.fanStatus = fanStatus;
	}
	public Integer getUpsServiceBatteryBankId() {
		return upsServiceBatteryBankId;
	}
	public void setUpsServiceBatteryBankId(Integer upsServiceBatteryBankId) {
		this.upsServiceBatteryBankId = upsServiceBatteryBankId;
	}
	public Boolean getCheckConnectors() {
		return checkConnectors;
	}
	public void setCheckConnectors(Boolean checkConnectors) {
		this.checkConnectors = checkConnectors;
	}
	public Boolean getCverifyOutflow() {
		return cverifyOutflow;
	}
	public void setCverifyOutflow(Boolean cverifyOutflow) {
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
	public Double getTemp() {
		return temp;
	}
	public void setTemp(Double temp) {
		this.temp = temp;
	}
	public Boolean getChargeTest() {
		return chargeTest;
	}
	public void setChargeTest(Boolean chargeTest) {
		this.chargeTest = chargeTest;
	}
	public String getBrandModel() {
		return brandModel;
	}
	public void setBrandModel(String brandModel) {
		this.brandModel = brandModel;
	}
	public Double getBatteryVoltage() {
		return batteryVoltage;
	}
	public void setBatteryVoltage(Double batteryVoltage) {
		this.batteryVoltage = batteryVoltage;
	}
	public Integer getUpsServiceGeneralTestId() {
		return upsServiceGeneralTestId;
	}
	public void setUpsServiceGeneralTestId(Integer upsServiceGeneralTestId) {
		this.upsServiceGeneralTestId = upsServiceGeneralTestId;
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
	public Integer getUpsServiceParamsId() {
		return upsServiceParamsId;
	}
	public void setUpsServiceParamsId(Integer upsServiceParamsId) {
		this.upsServiceParamsId = upsServiceParamsId;
	}
	public Double getInputVoltagePhase() {
		return inputVoltagePhase;
	}
	public void setInputVoltagePhase(Double inputVoltagePhase) {
		this.inputVoltagePhase = inputVoltagePhase;
	}
	public Double getInputVoltageNeutro() {
		return inputVoltageNeutro;
	}
	public void setInputVoltageNeutro(Double inputVoltageNeutro) {
		this.inputVoltageNeutro = inputVoltageNeutro;
	}
	public Double getInputVoltageNeutroGround() {
		return inputVoltageNeutroGround;
	}
	public void setInputVoltageNeutroGround(Double inputVoltageNeutroGround) {
		this.inputVoltageNeutroGround = inputVoltageNeutroGround;
	}
	public Double getPercentCharge() {
		return percentCharge;
	}
	public void setPercentCharge(Double percentCharge) {
		this.percentCharge = percentCharge;
	}
	public Double getOutputVoltagePhase() {
		return outputVoltagePhase;
	}
	public void setOutputVoltagePhase(Double outputVoltagePhase) {
		this.outputVoltagePhase = outputVoltagePhase;
	}
	public Double getOutputVoltageNeutro() {
		return outputVoltageNeutro;
	}
	public void setOutputVoltageNeutro(Double outputVoltageNeutro) {
		this.outputVoltageNeutro = outputVoltageNeutro;
	}
	public Double getInOutFrecuency() {
		return inOutFrecuency;
	}
	public void setInOutFrecuency(Double inOutFrecuency) {
		this.inOutFrecuency = inOutFrecuency;
	}
	public Double getBusVoltage() {
		return busVoltage;
	}
	public void setBusVoltage(Double busVoltage) {
		this.busVoltage = busVoltage;
	}

	public String getObservations() {
		return observations;
	}

	public void setObservations(String observations) {
		this.observations = observations;
	}
}
