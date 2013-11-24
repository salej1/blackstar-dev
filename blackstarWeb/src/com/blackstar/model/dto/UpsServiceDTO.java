package com.blackstar.model.dto;

import java.util.Date;

import com.blackstar.model.UpsService;
import com.blackstar.model.UpsServiceBatteryBank;
import com.blackstar.model.UpsServiceGeneralTest;
import com.blackstar.model.UpsServiceParams;

public class UpsServiceDTO {
	
	public UpsServiceDTO()
	{
		
	}
	
	public UpsServiceDTO(OrderserviceDTO serviceOrder, UpsService upsService, UpsServiceBatteryBank upsServiceBatteryBank, UpsServiceGeneralTest upsServiceGeneralTest, UpsServiceParams upsServiceParams)
	{
		this.upsServiceId = upsService.getUpsServiceId();
		this.serviceOrderId = upsService.getServiceOrderId();
		
		this.coordinator = serviceOrder.getCoordinator();
		this.serviceOrderNo = serviceOrder.getServiceOrderNo();
		this.ticketNo = serviceOrder.getTicketNo();
		this.ticketId = serviceOrder.getTicketId();
		this.policyId = serviceOrder.getPolicyId();
		this.serviceTypeId = serviceOrder.getServiceTypeId();
		this.equipmentTypeId = serviceOrder.getEquipmentTypeId();
		this.customer = serviceOrder.getCustomer();
		this.equipmentAddress = serviceOrder.getEquipmentAddress();
		this.serviceDate = serviceOrder.getServiceDate();
		this.contactName = serviceOrder.getContactName();
		this.contactPhone = serviceOrder.getContactPhone();
		this.equipmentType = serviceOrder.getEquipmentType();
		this.equipmentBrand = serviceOrder.getEquipmentBrand();
		this.equipmentModel = serviceOrder.getEquipmentModel();
		this.equipmentSerialNo = serviceOrder.getEquipmentSerialNo();
		this.failureDescription = serviceOrder.getFailureDescription();
		this.serviceType = serviceOrder.getServiceType();
		this.proyectNumber = serviceOrder.getProyectNumber();
		this.signCreated = serviceOrder.getSignCreated();
		this.signReceivedBy = serviceOrder.getSignReceivedBy();
		this.receivedBy = serviceOrder.getReceivedBy();
		this.receivedByPosition = serviceOrder.getReceivedByPosition();
		this.responsible = serviceOrder.getResponsible();
		this.closed = serviceOrder.getClosed();
		
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
			String coordinator, String serviceOrderNo, String ticketNo,
			Integer ticketId, Integer policyId, String serviceTypeId,
			String equipmentTypeId, String customer, String equipmentAddress,
			Date serviceDate, String contactName, String contactPhone,
			String equipmentType, String equipmentBrand, String equipmentModel,
			String equipmentSerialNo, String failureDescription,
			String serviceType, String proyectNumber, String detailIssue,
			String detailWorkDone, String detailTechnicalJob,
			String detailRequirments, String detailStatus, String signCreated,
			String signReceivedBy, String receivedBy,
			String receivedByPosition, String responsible, Date closed,
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
		this.coordinator = coordinator;
		this.serviceOrderNo = serviceOrderNo;
		this.ticketNo = ticketNo;
		this.ticketId = ticketId;
		this.policyId = policyId;
		this.serviceTypeId = serviceTypeId;
		this.equipmentTypeId = equipmentTypeId;
		this.customer = customer;
		this.equipmentAddress = equipmentAddress;
		this.serviceDate = serviceDate;
		this.contactName = contactName;
		this.contactPhone = contactPhone;
		this.equipmentType = equipmentType;
		this.equipmentBrand = equipmentBrand;
		this.equipmentModel = equipmentModel;
		this.equipmentSerialNo = equipmentSerialNo;
		this.failureDescription = failureDescription;
		this.serviceType = serviceType;
		this.proyectNumber = proyectNumber;
		this.detailIssue = detailIssue;
		this.detailWorkDone = detailWorkDone;
		this.detailTechnicalJob = detailTechnicalJob;
		this.detailRequirments = detailRequirments;
		this.detailStatus = detailStatus;
		this.signCreated = signCreated;
		this.signReceivedBy = signReceivedBy;
		this.receivedBy = receivedBy;
		this.receivedByPosition = receivedByPosition;
		this.responsible = responsible;
		this.closed = closed;
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
	
	private String coordinator;
	private String serviceOrderNo;
	private String ticketNo;
	private Integer ticketId;
	private Integer policyId;
	private String serviceTypeId;
	private String equipmentTypeId;
	private String customer;
	private String equipmentAddress;
	private Date serviceDate;
	private String contactName;
	private String contactPhone;
	private String equipmentType;
	private String equipmentBrand;
	private String equipmentModel;
	private String equipmentSerialNo;
	private String failureDescription;
	private String serviceType;
	private String proyectNumber;
	private String detailIssue;
	private String detailWorkDone;
	private String detailTechnicalJob;
	private String detailRequirments;
	private String detailStatus;
	private String signCreated;
	private String signReceivedBy;
	private String receivedBy;
	private String receivedByPosition;
	private String responsible;
	private Date closed;
	
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
	public String getCoordinator() {
		return coordinator;
	}
	public void setCoordinator(String coordinator) {
		this.coordinator = coordinator;
	}
	public String getServiceOrderNo() {
		return serviceOrderNo;
	}
	public void setServiceOrderNo(String serviceOrderNo) {
		this.serviceOrderNo = serviceOrderNo;
	}
	public String getTicketNo() {
		return ticketNo;
	}
	public void setTicketNo(String ticketNo) {
		this.ticketNo = ticketNo;
	}
	public Integer getTicketId() {
		return ticketId;
	}
	public void setTicketId(Integer ticketId) {
		this.ticketId = ticketId;
	}
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getServiceTypeId() {
		return serviceTypeId;
	}
	public void setServiceTypeId(String serviceTypeId) {
		this.serviceTypeId = serviceTypeId;
	}
	public String getEquipmentTypeId() {
		return equipmentTypeId;
	}
	public void setEquipmentTypeId(String equipmentTypeId) {
		this.equipmentTypeId = equipmentTypeId;
	}
	public String getCustomer() {
		return customer;
	}
	public void setCustomer(String customer) {
		this.customer = customer;
	}
	public String getEquipmentAddress() {
		return equipmentAddress;
	}
	public void setEquipmentAddress(String equipmentAddress) {
		this.equipmentAddress = equipmentAddress;
	}
	public Date getServiceDate() {
		return serviceDate;
	}
	public void setServiceDate(Date serviceDate) {
		this.serviceDate = serviceDate;
	}
	public String getContactName() {
		return contactName;
	}
	public void setContactName(String contactName) {
		this.contactName = contactName;
	}
	public String getContactPhone() {
		return contactPhone;
	}
	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}
	public String getEquipmentType() {
		return equipmentType;
	}
	public void setEquipmentType(String equipmentType) {
		this.equipmentType = equipmentType;
	}
	public String getEquipmentBrand() {
		return equipmentBrand;
	}
	public void setEquipmentBrand(String equipmentBrand) {
		this.equipmentBrand = equipmentBrand;
	}
	public String getEquipmentModel() {
		return equipmentModel;
	}
	public void setEquipmentModel(String equipmentModel) {
		this.equipmentModel = equipmentModel;
	}
	public String getEquipmentSerialNo() {
		return equipmentSerialNo;
	}
	public void setEquipmentSerialNo(String equipmentSerialNo) {
		this.equipmentSerialNo = equipmentSerialNo;
	}
	public String getFailureDescription() {
		return failureDescription;
	}
	public void setFailureDescription(String failureDescription) {
		this.failureDescription = failureDescription;
	}
	public String getServiceType() {
		return serviceType;
	}
	public void setServiceType(String serviceType) {
		this.serviceType = serviceType;
	}
	public String getProyectNumber() {
		return proyectNumber;
	}
	public void setProyectNumber(String proyectNumber) {
		this.proyectNumber = proyectNumber;
	}
	public String getDetailIssue() {
		return detailIssue;
	}
	public void setDetailIssue(String detailIssue) {
		this.detailIssue = detailIssue;
	}
	public String getDetailWorkDone() {
		return detailWorkDone;
	}
	public void setDetailWorkDone(String detailWorkDone) {
		this.detailWorkDone = detailWorkDone;
	}
	public String getDetailTechnicalJob() {
		return detailTechnicalJob;
	}
	public void setDetailTechnicalJob(String detailTechnicalJob) {
		this.detailTechnicalJob = detailTechnicalJob;
	}
	public String getDetailRequirments() {
		return detailRequirments;
	}
	public void setDetailRequirments(String detailRequirments) {
		this.detailRequirments = detailRequirments;
	}
	public String getDetailStatus() {
		return detailStatus;
	}
	public void setDetailStatus(String detailStatus) {
		this.detailStatus = detailStatus;
	}
	public String getSignCreated() {
		return signCreated;
	}
	public void setSignCreated(String signCreated) {
		this.signCreated = signCreated;
	}
	public String getSignReceivedBy() {
		return signReceivedBy;
	}
	public void setSignReceivedBy(String signReceivedBy) {
		this.signReceivedBy = signReceivedBy;
	}
	public String getReceivedBy() {
		return receivedBy;
	}
	public void setReceivedBy(String receivedBy) {
		this.receivedBy = receivedBy;
	}
	public String getReceivedByPosition() {
		return receivedByPosition;
	}
	public void setReceivedByPosition(String receivedByPosition) {
		this.receivedByPosition = receivedByPosition;
	}
	public String getResponsible() {
		return responsible;
	}
	public void setResponsible(String responsible) {
		this.responsible = responsible;
	}
	public Date getClosed() {
		return closed;
	}
	public void setClosed(Date closed) {
		this.closed = closed;
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
