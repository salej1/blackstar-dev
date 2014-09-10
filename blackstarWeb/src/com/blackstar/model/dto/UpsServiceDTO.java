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
			String estatusEquipment, Integer cleaned, Integer hooverClean,
			Integer verifyConnections, String capacitorStatus,
			Integer verifyFuzz, Integer chargerReview, String fanStatus,
			Integer upsServiceBatteryBankId, Integer checkConnectors,
			Integer cverifyOutflow, Integer numberBatteries,
			String manufacturedDateSerial, String damageBatteries,
			String other, String temp, Integer chargeTest, String brandModel,
			String batteryVoltage, Integer upsServiceGeneralTestId,
			Integer trasferLine, Integer transferEmergencyPlant,
			Integer backupBatteries, Integer verifyVoltage,
			Integer upsServiceParamsId, String inputVoltagePhase,
			String inputVoltageNeutro, String inputVoltageNeutroGround,
			String percentCharge, String outputVoltagePhase,
			String outputVoltageNeutro, String inOutFrecuency, String busVoltage, String observations) {
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
	private Integer cleaned;
	private Integer hooverClean;
	private Integer verifyConnections;
	private String capacitorStatus;
	private Integer verifyFuzz;
	private Integer chargerReview;
	private String fanStatus;
	private String observations;

	private Integer upsServiceBatteryBankId;
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

	private Integer upsServiceGeneralTestId;
	private Integer trasferLine;
	private Integer transferEmergencyPlant;
	private Integer backupBatteries;
	private Integer verifyVoltage;

	private Integer upsServiceParamsId;
	private String inputVoltagePhase;
	private String inputVoltageNeutro;
	private String inputVoltageNeutroGround;
	private String percentCharge;
	private String outputVoltagePhase;
	private String outputVoltageNeutro;
	private String inOutFrecuency;
	private String busVoltage;
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

	public Integer getCleaned() {
		return cleaned;
	}

	public void setCleaned(Integer cleaned) {
		this.cleaned = cleaned;
	}

	public Integer getHooverClean() {
		return hooverClean;
	}

	public void setHooverClean(Integer hooverClean) {
		this.hooverClean = hooverClean;
	}

	public Integer getVerifyConnections() {
		return verifyConnections;
	}

	public void setVerifyConnections(Integer verifyConnections) {
		this.verifyConnections = verifyConnections;
	}

	public String getCapacitorStatus() {
		return capacitorStatus;
	}

	public void setCapacitorStatus(String capacitorStatus) {
		this.capacitorStatus = capacitorStatus;
	}

	public Integer getVerifyFuzz() {
		return verifyFuzz;
	}

	public void setVerifyFuzz(Integer verifyFuzz) {
		this.verifyFuzz = verifyFuzz;
	}

	public Integer getChargerReview() {
		return chargerReview;
	}

	public void setChargerReview(Integer chargerReview) {
		this.chargerReview = chargerReview;
	}

	public String getFanStatus() {
		return fanStatus;
	}

	public void setFanStatus(String fanStatus) {
		this.fanStatus = fanStatus;
	}

	public String getObservations() {
		return observations;
	}

	public void setObservations(String observations) {
		this.observations = observations;
	}

	public Integer getUpsServiceBatteryBankId() {
		return upsServiceBatteryBankId;
	}

	public void setUpsServiceBatteryBankId(Integer upsServiceBatteryBankId) {
		this.upsServiceBatteryBankId = upsServiceBatteryBankId;
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

	public Integer getUpsServiceGeneralTestId() {
		return upsServiceGeneralTestId;
	}

	public void setUpsServiceGeneralTestId(Integer upsServiceGeneralTestId) {
		this.upsServiceGeneralTestId = upsServiceGeneralTestId;
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

	public Integer getUpsServiceParamsId() {
		return upsServiceParamsId;
	}

	public void setUpsServiceParamsId(Integer upsServiceParamsId) {
		this.upsServiceParamsId = upsServiceParamsId;
	}

	public String getInputVoltagePhase() {
		return inputVoltagePhase;
	}

	public void setInputVoltagePhase(String inputVoltagePhase) {
		this.inputVoltagePhase = inputVoltagePhase;
	}

	public String getInputVoltageNeutro() {
		return inputVoltageNeutro;
	}

	public void setInputVoltageNeutro(String inputVoltageNeutro) {
		this.inputVoltageNeutro = inputVoltageNeutro;
	}

	public String getInputVoltageNeutroGround() {
		return inputVoltageNeutroGround;
	}

	public void setInputVoltageNeutroGround(String inputVoltageNeutroGround) {
		this.inputVoltageNeutroGround = inputVoltageNeutroGround;
	}

	public String getPercentCharge() {
		return percentCharge;
	}

	public void setPercentCharge(String percentCharge) {
		this.percentCharge = percentCharge;
	}

	public String getOutputVoltagePhase() {
		return outputVoltagePhase;
	}

	public void setOutputVoltagePhase(String outputVoltagePhase) {
		this.outputVoltagePhase = outputVoltagePhase;
	}

	public String getOutputVoltageNeutro() {
		return outputVoltageNeutro;
	}

	public void setOutputVoltageNeutro(String outputVoltageNeutro) {
		this.outputVoltageNeutro = outputVoltageNeutro;
	}

	public String getInOutFrecuency() {
		return inOutFrecuency;
	}

	public void setInOutFrecuency(String inOutFrecuency) {
		this.inOutFrecuency = inOutFrecuency;
	}

	public String getBusVoltage() {
		return busVoltage;
	}

	public void setBusVoltage(String busVoltage) {
		this.busVoltage = busVoltage;
	}
	
}
