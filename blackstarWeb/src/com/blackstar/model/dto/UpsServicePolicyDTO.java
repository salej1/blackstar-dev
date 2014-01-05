package com.blackstar.model.dto;

import java.util.Date;

import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;

public class UpsServicePolicyDTO {

	public UpsServicePolicyDTO()
	{
		this.closed = new Date();
		this.serviceDate = new Date();
	}
	
	public UpsServicePolicyDTO(Policy policy, String equipmentType)
	{
		this.policyId = policy.getPolicyId();
		this.customer = policy.getCustomer();
		this.finalUser = policy.getFinalUser();
		this.project = policy.getProject();
		this.equipmentTypeId = policy.getEquipmentTypeId();
		this.equipmentType =equipmentType;
		this.brand = policy.getBrand();
		this.model =policy.getModel();
		this.serialNumber = policy.getSerialNumber();
		this.capacity = policy.getCapacity();
		this.equipmentAddress = policy.getEquipmentAddress();
		this.officeId = policy.getOfficeId();
		this.contactName = policy.getContactName();
		this.contactPhone = policy.getContactPhone();
		
		this.closed = new Date();
		this.serviceDate = new Date();
	}
	

	public UpsServicePolicyDTO(Policy policy, String equipmentType, Serviceorder serviceOrder)
	{
		this.policyId = policy.getPolicyId();
		this.customer = policy.getCustomer();
		this.finalUser = policy.getFinalUser();
		this.project = policy.getProject();
		this.equipmentTypeId = policy.getEquipmentTypeId();
		this.equipmentType =equipmentType;
		this.brand = policy.getBrand();
		this.model =policy.getModel();
		this.serialNumber = policy.getSerialNumber();
		this.capacity = policy.getCapacity();
		this.equipmentAddress = policy.getEquipmentAddress();
		this.officeId = policy.getOfficeId();
		this.contactName = policy.getContactName();
		this.contactPhone = policy.getContactPhone();
		
		this.serviceOrderId = serviceOrder.getServiceOrderId();
		this.ticketId = serviceOrder.getTicketId();
		this.serviceDate = serviceOrder.getServiceDate();
		this.responsible = serviceOrder.getResponsible();
		this.receivedBy = serviceOrder.getReceivedBy();
		this.serviceStatusId = serviceOrder.getStatusId();
		this.closed = serviceOrder.getClosed();
		this.consultant = serviceOrder.getConsultant();
		this.coordinator = serviceOrder.getCoordinator();
		this.asignee = serviceOrder.getAsignee();
		this.signCreated = serviceOrder.getSignCreated();
		this.signReceivedBy = serviceOrder.getsignReceivedBy();
		this.receivedByPosition = serviceOrder.getReceivedByPosition();
		this.serviceOrderNumber = serviceOrder.getServiceOrderNumber();
		
	}
	
	public UpsServicePolicyDTO(Policy policy, String equipmentType, Serviceorder serviceOrder,  UpsServiceDTO upsService)
	{
		this.policyId = policy.getPolicyId();
		this.customer = policy.getCustomer();
		this.finalUser = policy.getFinalUser();
		this.project = policy.getProject();
		this.equipmentTypeId = policy.getEquipmentTypeId();
		this.equipmentType =equipmentType;
		this.brand = policy.getBrand();
		this.model =policy.getModel();
		this.serialNumber = policy.getSerialNumber();
		this.capacity = policy.getCapacity();
		this.equipmentAddress = policy.getEquipmentAddress();
		this.officeId = policy.getOfficeId();
		this.contactName = policy.getContactName();
		this.contactPhone = policy.getContactPhone();
		
		this.serviceOrderId = serviceOrder.getServiceOrderId();
		this.ticketId = serviceOrder.getTicketId();
		this.serviceDate = serviceOrder.getServiceDate();
		this.responsible = serviceOrder.getResponsible();
		this.receivedBy = serviceOrder.getReceivedBy();
		this.serviceStatusId = serviceOrder.getStatusId();
		this.closed = serviceOrder.getClosed();
		this.consultant = serviceOrder.getConsultant();
		this.coordinator = serviceOrder.getCoordinator();
		this.asignee = serviceOrder.getAsignee();
		this.signCreated = serviceOrder.getSignCreated();
		this.signReceivedBy = serviceOrder.getsignReceivedBy();
		this.receivedByPosition = serviceOrder.getReceivedByPosition();
		this.serviceOrderNumber = serviceOrder.getServiceOrderNumber();
		
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
	
	private Integer policyId;
	private String customer;
	private String finalUser;
	private String project;
	private Character equipmentTypeId;
	private String equipmentType;
	private String brand;
	private String model;
	private String serialNumber;
	private String capacity;
	private String equipmentAddress;
	private char officeId;
	private String contactName;
	private String contactPhone;

	private Integer serviceOrderId;
	private Integer ticketId;
	private Date serviceDate;
	private String responsible;
	private String receivedBy;
	private String serviceStatusId;
	private Date closed;
	private String consultant;
	private String coordinator;
	private String asignee;
	private String signCreated;
	private String signReceivedBy;
	private String receivedByPosition;
	private String serviceOrderNumber;
	
	private Integer upsServiceId;	
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
	private Boolean trasferLine;
	private Boolean transferEmergencyPlant;
	private Boolean backupBatteries;
	private Boolean verifyVoltage;

	private Integer upsServiceParamsId;
	private Double inputVoltagePhase;
	private Double inputVoltageNeutro;
	private Double inputVoltageNeutroGround;
	private Double percentCharge;
	private Double outputVoltagePhase;
	private Double outputVoltageNeutro;
	private Double inOutFrecuency;
	private Double busVoltage;
	
	public Integer getPolicyId() {
		return policyId;
	}
	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}
	public String getCustomer() {
		return customer;
	}
	public void setCustomer(String customer) {
		this.customer = customer;
	}
	public String getFinalUser() {
		return finalUser;
	}
	public void setFinalUser(String finalUser) {
		this.finalUser = finalUser;
	}
	public String getProject() {
		return project;
	}
	public void setProject(String project) {
		this.project = project;
	}
	public Character getEquipmentTypeId() {
		return equipmentTypeId;
	}
	public void setEquipmentTypeId(Character equipmentTypeId) {
		this.equipmentTypeId = equipmentTypeId;
	}
	public String getEquipmentType() {
		return equipmentType;
	}
	public void setEquipmentType(String equipmentType) {
		this.equipmentType = equipmentType;
	}
	public String getBrand() {
		return brand;
	}
	public void setBrand(String brand) {
		this.brand = brand;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public String getSerialNumber() {
		return serialNumber;
	}
	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}
	public String getCapacity() {
		return capacity;
	}
	public void setCapacity(String capacity) {
		this.capacity = capacity;
	}
	public String getEquipmentAddress() {
		return equipmentAddress;
	}
	public void setEquipmentAddress(String equipmentAddress) {
		this.equipmentAddress = equipmentAddress;
	}
	public char getOfficeId() {
		return officeId;
	}
	public void setOfficeId(char officeId) {
		this.officeId = officeId;
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
	public Integer getServiceOrderId() {
		return serviceOrderId;
	}
	public void setServiceOrderId(Integer serviceOrderId) {
		this.serviceOrderId = serviceOrderId;
	}
	public Integer getTicketId() {
		return ticketId;
	}
	public void setTicketId(Integer ticketId) {
		this.ticketId = ticketId;
	}
	public Date getServiceDate() {
		return serviceDate;
	}
	public void setServiceDate(Date serviceDate) {
		this.serviceDate = serviceDate;
	}
	public String getResponsible() {
		return responsible;
	}
	public void setResponsible(String responsible) {
		this.responsible = responsible;
	}
	public String getReceivedBy() {
		return receivedBy;
	}
	public void setReceivedBy(String receivedBy) {
		this.receivedBy = receivedBy;
	}
	public String getServiceStatusId() {
		return serviceStatusId;
	}
	public void setServiceStatusId(String serviceStatusId) {
		this.serviceStatusId = serviceStatusId;
	}
	public Date getClosed() {
		return closed;
	}
	public void setClosed(Date closed) {
		this.closed = closed;
	}
	public String getConsultant() {
		return consultant;
	}
	public void setConsultant(String consultant) {
		this.consultant = consultant;
	}
	public String getCoordinator() {
		return coordinator;
	}
	public void setCoordinator(String coordinator) {
		this.coordinator = coordinator;
	}
	public String getAsignee() {
		return asignee;
	}
	public void setAsignee(String asignee) {
		this.asignee = asignee;
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
	public String getReceivedByPosition() {
		return receivedByPosition;
	}
	public void setReceivedByPosition(String receivedByPosition) {
		this.receivedByPosition = receivedByPosition;
	}
	public String getServiceOrderNumber() {
		return serviceOrderNumber;
	}
	public void setServiceOrderNumber(String serviceOrderNumber) {
		this.serviceOrderNumber = serviceOrderNumber;
	}
	public Integer getUpsServiceId() {
		return upsServiceId;
	}
	public void setUpsServiceId(Integer upsServiceId) {
		this.upsServiceId = upsServiceId;
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
}
