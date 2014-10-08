package com.blackstar.model.dto;

import java.util.Date;

import com.blackstar.model.OpenCustomer;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;

public class UpsServicePolicyDTO {

	public UpsServicePolicyDTO()
	{
		this.closed = new Date();
		this.serviceDate = new Date();
	}
	
	public UpsServicePolicyDTO(Policy policy)
	{
		this.policyId = policy.getPolicyId();
		this.customer = policy.getCustomer();
		this.finalUser = policy.getFinalUser();
		this.project = policy.getProject();
		this.equipmentTypeId = policy.getEquipmentTypeId();
		this.brand = policy.getBrand();
		this.model =policy.getModel();
		this.serialNumber = policy.getSerialNumber();
		this.capacity = policy.getCapacity();
		this.equipmentAddress = policy.getEquipmentAddress();
		this.officeId = String.valueOf(policy.getOfficeId());
		this.contactName = policy.getContactName();
		this.contactPhone = policy.getContactPhone();

	}
	
	public UpsServicePolicyDTO(OpenCustomer customer){
		this.customer = customer.getCustomerName();
		this.finalUser = customer.getContactEmail();
		this.project = "";
		if(customer.getEquipmentTypeId() != null && customer.getEquipmentTypeId().length() > 0){
			this.equipmentTypeId = customer.getEquipmentTypeId().charAt(0);
		}
		this.brand = customer.getBrand();
		this.model = customer.getModel();
		this.serialNumber = customer.getSerialNumber();
		this.capacity = customer.getCapacity();
		this.equipmentAddress = customer.getAddress();
		this.contactName = customer.getContactName();
		this.contactPhone = customer.getPhone();
		this.officeId = customer.getOfficeId();
	}

	public UpsServicePolicyDTO(Policy policy, Serviceorder serviceOrder)
	{
		this.policyId = policy.getPolicyId();
		this.customer = policy.getCustomer();
		this.finalUser = policy.getFinalUser();
		this.project = policy.getProject();
		this.equipmentTypeId = policy.getEquipmentTypeId();
		this.brand = policy.getBrand();
		this.model =policy.getModel();
		this.serialNumber = policy.getSerialNumber();
		this.capacity = policy.getCapacity();
		this.equipmentAddress = policy.getEquipmentAddress();
		this.officeId = String.valueOf(policy.getOfficeId());
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
		this.receivedByEmail = serviceOrder.getReceivedByEmail();
		this.responsibleName = serviceOrder.getEmployeeNameListString();
		this.isWrong = serviceOrder.getIsWrong()>0?true:false;
		this.serviceEndDate = serviceOrder.getServiceEndDate();
		this.surveyScore = serviceOrder.getSurveyScore();
		this.surveyServiceId = serviceOrder.getSurveyServiceId();
		this.hasPdf = serviceOrder.getHasPdf();
	}
	
	public UpsServicePolicyDTO(Policy policy, Serviceorder serviceOrder,  UpsServiceDTO upsService)
	{
		this.policyId = policy.getPolicyId();
		this.customer = policy.getCustomer();
		this.finalUser = policy.getFinalUser();
		this.project = policy.getProject();
		this.equipmentTypeId = policy.getEquipmentTypeId();
		this.brand = policy.getBrand();
		this.model =policy.getModel();
		this.serialNumber = policy.getSerialNumber();
		this.capacity = policy.getCapacity();
		this.equipmentAddress = policy.getEquipmentAddress();
		this.officeId = String.valueOf(policy.getOfficeId());
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
		this.receivedByEmail = serviceOrder.getReceivedByEmail();
		this.responsibleName = serviceOrder.getEmployeeNameListString();
		this.isWrong = serviceOrder.getIsWrong()>0?true:false;
		this.serviceEndDate = serviceOrder.getServiceEndDate();
		this.surveyScore = serviceOrder.getSurveyScore();
		this.surveyServiceId = serviceOrder.getSurveyServiceId();
		this.hasPdf = serviceOrder.getHasPdf();
		
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
	
	public UpsServicePolicyDTO(OpenCustomer customer, Serviceorder serviceOrder,  UpsServiceDTO upsService){
		this.customer = customer.getCustomerName();
		this.finalUser = customer.getContactEmail();
		this.project = "";
		if(customer.getEquipmentTypeId() != null && customer.getEquipmentTypeId().length() > 0){
			this.equipmentTypeId = customer.getEquipmentTypeId().charAt(0);
		}
		this.brand = customer.getBrand();
		this.model = customer.getModel();
		this.serialNumber = customer.getSerialNumber();
		this.capacity = customer.getCapacity();
		this.equipmentAddress = customer.getAddress();
		this.contactName = customer.getContactName();
		this.contactPhone = customer.getPhone();
		this.officeId = customer.getOfficeId();
		
		this.serviceDate = new Date();
		
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
		this.receivedByEmail = serviceOrder.getReceivedByEmail();
		this.responsibleName = serviceOrder.getEmployeeNameListString();
		this.isWrong = serviceOrder.getIsWrong()>0?true:false;
		this.serviceEndDate = serviceOrder.getServiceEndDate();
		this.surveyScore = serviceOrder.getSurveyScore();
		this.surveyServiceId = serviceOrder.getSurveyServiceId();
		this.hasPdf = serviceOrder.getHasPdf();
		
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
	private String officeId;
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
	private String serviceTypeId;
	private String	responsibleName;
	private Integer openCustomerId;
	private Boolean isWrong;
	private Date serviceEndDate;
	private Integer surveyScore;
	private Integer surveyServiceId;
	private Integer hasPdf;
	
	private Integer upsServiceId;	
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
	private String receivedByEmail;
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

	public String getOfficeId() {
		return officeId;
	}

	public void setOfficeId(String officeId) {
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

	public String getServiceTypeId() {
		return serviceTypeId;
	}

	public void setServiceTypeId(String serviceTypeId) {
		this.serviceTypeId = serviceTypeId;
	}

	public String getResponsibleName() {
		return responsibleName;
	}

	public void setResponsibleName(String responsibleName) {
		this.responsibleName = responsibleName;
	}

	public Integer getOpenCustomerId() {
		return openCustomerId;
	}

	public void setOpenCustomerId(Integer openCustomerId) {
		this.openCustomerId = openCustomerId;
	}

	public Boolean getIsWrong() {
		return isWrong;
	}

	public void setIsWrong(Boolean isWrong) {
		this.isWrong = isWrong;
	}

	public Date getServiceEndDate() {
		return serviceEndDate;
	}

	public void setServiceEndDate(Date serviceEndDate) {
		this.serviceEndDate = serviceEndDate;
	}

	public Integer getSurveyScore() {
		return surveyScore;
	}

	public void setSurveyScore(Integer surveyScore) {
		this.surveyScore = surveyScore;
	}

	public Integer getSurveyServiceId() {
		return surveyServiceId;
	}

	public void setSurveyServiceId(Integer surveyServiceId) {
		this.surveyServiceId = surveyServiceId;
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

	public String getReceivedByEmail() {
		return receivedByEmail;
	}

	public void setReceivedByEmail(String receivedByEmail) {
		this.receivedByEmail = receivedByEmail;
	}

	public Integer getHasPdf() {
		return hasPdf;
	}

	public void setHasPdf(Integer hasPdf) {
		this.hasPdf = hasPdf;
	}


}
