
package com.blackstar.model.dto;

import java.util.Date;

import com.blackstar.model.OpenCustomer;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;

public class AirCoServicePolicyDTO {

	public AirCoServicePolicyDTO()
	{
		this.serviceDate = new Date();
	}
	
	public AirCoServicePolicyDTO(OpenCustomer customer)
	{
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
	}
	
	public AirCoServicePolicyDTO(Policy policy)
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
		
		this.serviceDate = new Date();
	}
	
	public AirCoServicePolicyDTO(Policy policy, Serviceorder serviceOrder)
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
		this.receivedByEmail = serviceOrder.getReceivedByEmail();
		this.serviceOrderNumber = serviceOrder.getServiceOrderNumber();
		this.responsibleName = serviceOrder.getEmployeeNameListString();
		this.isWrong = serviceOrder.getIsWrong()>0?true:false;
		this.serviceEndDate = serviceOrder.getServiceEndDate();
		this.surveyScore = serviceOrder.getSurveyScore();
		this.surveyServiceId = serviceOrder.getSurveyServiceId();
		this.hasPdf = serviceOrder.getHasPdf();
	}
	
	public AirCoServicePolicyDTO(Policy policy, Serviceorder serviceOrder,  AirCoServiceDTO airCo)
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
		
		this.aaServiceId = airCo.getAaServiceId();
		this.evaDescription = airCo.getEvaDescription();
		this.evaValTemp = airCo.getEvaValTemp();
		this.evaValHum = airCo.getEvaValHum();
		this.evaSetpointTemp = airCo.getEvaSetpointTemp();
		this.evaSetpointHum = airCo.getEvaSetpointHum();
		this.evaFlagCalibration = airCo.getEvaFlagCalibration();
		this.evaReviewFilter = airCo.getEvaReviewFilter();
		this.evaReviewStrip = airCo.getEvaReviewStrip();
		this.evaCleanElectricSystem = airCo.getEvaCleanElectricSystem();
		this.evaCleanControlCard = airCo.getEvaCleanControlCard();
		this.evaCleanTray = airCo.getEvaCleanTray();
		this.evaLectrurePreasureHigh = airCo.getEvaLectrurePreasureHigh();
		this.evaLectrurePreasureLow = airCo.getEvaLectrurePreasureLow();
		this.evaLectureTemp = airCo.getEvaLectureTemp();
		this.evaLectureOilColor = airCo.getEvaLectureOilColor();
		this.evaLectureOilLevel = airCo.getEvaLectureOilLevel();
		this.evaLectureCoolerColor = airCo.getEvaLectureCoolerColor();
		this.evaLectureCoolerLevel = airCo.getEvaLectureCoolerLevel();
		this.evaCheckOperatation = airCo.getEvaCheckOperatation();
		this.evaCheckNoise = airCo.getEvaCheckNoise();
		this.evaCheckIsolated = airCo.getEvaCheckIsolated();
		this.evaLectureVoltageGroud = airCo.getEvaLectureVoltageGroud();
		this.evaLectureVoltagePhases = airCo.getEvaLectureVoltagePhases();
		this.evaLectureVoltageControl = airCo.getEvaLectureVoltageControl();
		this.evaLectureCurrentMotor1 = airCo.getEvaLectureCurrentMotor1();
		this.evaLectureCurrentMotor2 = airCo.getEvaLectureCurrentMotor2();
		this.evaLectureCurrentMotor3 = airCo.getEvaLectureCurrentMotor3();
		this.evaLectureCurrentCompressor1 = airCo.getEvaLectureCurrentCompressor1();
		this.evaLectureCurrentCompressor2 = airCo.getEvaLectureCurrentCompressor2();
		this.evaLectureCurrentCompressor3 = airCo.getEvaLectureCurrentCompressor3();
		this.evaLectureCurrentHumidifier1 = airCo.getEvaLectureCurrentHumidifier1();
		this.evaLectureCurrentHumidifier2 = airCo.getEvaLectureCurrentHumidifier2();
		this.evaLectureCurrentHumidifier3 = airCo.getEvaLectureCurrentHumidifier3();
		this.evaLectureCurrentHeater1 = airCo.getEvaLectureCurrentHeater1();
		this.evaLectureCurrentHeater2 = airCo.getEvaLectureCurrentHeater2();
		this.evaLectureCurrentHeater3 = airCo.getEvaLectureCurrentHeater3();
		this.evaCheckFluidSensor = airCo.getEvaCheckFluidSensor();
		this.evaRequirMaintenance = airCo.getEvaRequirMaintenance();
		this.condReview = airCo.getCondReview();
		this.condCleanElectricSystem = airCo.getCondCleanElectricSystem();
		this.condClean = airCo.getCondClean();
		this.condLectureVoltageGroud = airCo.getCondLectureVoltageGroud();
		this.condLectureVoltagePhases = airCo.getCondLectureVoltagePhases();
		this.condLectureVoltageControl = airCo.getCondLectureVoltageControl();
		this.condLectureMotorCurrent = airCo.getCondLectureMotorCurrent();
		this.condReviewThermostat = airCo.getCondReviewThermostat();
		this.condModel = airCo.getCondModel();
		this.condSerialNumber = airCo.getCondSerialNumber();
		this.condBrand = airCo.getCondBrand();
		this.observations = airCo.getObservations();
	}
	

	public AirCoServicePolicyDTO(OpenCustomer customer, Serviceorder serviceOrder,  AirCoServiceDTO airCo)
	{
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
		
		this.aaServiceId = airCo.getAaServiceId();
		this.evaDescription = airCo.getEvaDescription();
		this.evaValTemp = airCo.getEvaValTemp();
		this.evaValHum = airCo.getEvaValHum();
		this.evaSetpointTemp = airCo.getEvaSetpointTemp();
		this.evaSetpointHum = airCo.getEvaSetpointHum();
		this.evaFlagCalibration = airCo.getEvaFlagCalibration();
		this.evaReviewFilter = airCo.getEvaReviewFilter();
		this.evaReviewStrip = airCo.getEvaReviewStrip();
		this.evaCleanElectricSystem = airCo.getEvaCleanElectricSystem();
		this.evaCleanControlCard = airCo.getEvaCleanControlCard();
		this.evaCleanTray = airCo.getEvaCleanTray();
		this.evaLectrurePreasureHigh = airCo.getEvaLectrurePreasureHigh();
		this.evaLectrurePreasureLow = airCo.getEvaLectrurePreasureLow();
		this.evaLectureTemp = airCo.getEvaLectureTemp();
		this.evaLectureOilColor = airCo.getEvaLectureOilColor();
		this.evaLectureOilLevel = airCo.getEvaLectureOilLevel();
		this.evaLectureCoolerColor = airCo.getEvaLectureCoolerColor();
		this.evaLectureCoolerLevel = airCo.getEvaLectureCoolerLevel();
		this.evaCheckOperatation = airCo.getEvaCheckOperatation();
		this.evaCheckNoise = airCo.getEvaCheckNoise();
		this.evaCheckIsolated = airCo.getEvaCheckIsolated();
		this.evaLectureVoltageGroud = airCo.getEvaLectureVoltageGroud();
		this.evaLectureVoltagePhases = airCo.getEvaLectureVoltagePhases();
		this.evaLectureVoltageControl = airCo.getEvaLectureVoltageControl();
		this.evaLectureCurrentMotor1 = airCo.getEvaLectureCurrentMotor1();
		this.evaLectureCurrentMotor2 = airCo.getEvaLectureCurrentMotor2();
		this.evaLectureCurrentMotor3 = airCo.getEvaLectureCurrentMotor3();
		this.evaLectureCurrentCompressor1 = airCo.getEvaLectureCurrentCompressor1();
		this.evaLectureCurrentCompressor2 = airCo.getEvaLectureCurrentCompressor2();
		this.evaLectureCurrentCompressor3 = airCo.getEvaLectureCurrentCompressor3();
		this.evaLectureCurrentHumidifier1 = airCo.getEvaLectureCurrentHumidifier1();
		this.evaLectureCurrentHumidifier2 = airCo.getEvaLectureCurrentHumidifier2();
		this.evaLectureCurrentHumidifier3 = airCo.getEvaLectureCurrentHumidifier3();
		this.evaLectureCurrentHeater1 = airCo.getEvaLectureCurrentHeater1();
		this.evaLectureCurrentHeater2 = airCo.getEvaLectureCurrentHeater2();
		this.evaLectureCurrentHeater3 = airCo.getEvaLectureCurrentHeater3();
		this.evaCheckFluidSensor = airCo.getEvaCheckFluidSensor();
		this.evaRequirMaintenance = airCo.getEvaRequirMaintenance();
		this.condReview = airCo.getCondReview();
		this.condCleanElectricSystem = airCo.getCondCleanElectricSystem();
		this.condClean = airCo.getCondClean();
		this.condLectureVoltageGroud = airCo.getCondLectureVoltageGroud();
		this.condLectureVoltagePhases = airCo.getCondLectureVoltagePhases();
		this.condLectureVoltageControl = airCo.getCondLectureVoltageControl();
		this.condLectureMotorCurrent = airCo.getCondLectureMotorCurrent();
		this.condReviewThermostat = airCo.getCondReviewThermostat();
		this.condModel = airCo.getCondModel();
		this.condSerialNumber = airCo.getCondSerialNumber();
		this.condBrand = airCo.getCondBrand();
		this.observations = airCo.getObservations();
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
	private Boolean isWrong;
	private Date serviceEndDate;
	private Integer surveyScore;
	private Integer surveyServiceId;
	private Integer hasPdf;
	
	private Integer aaServiceId;
	private String evaDescription;
	private String evaValTemp;
	private String evaValHum;
	private String evaSetpointTemp;
	private String evaSetpointHum;
	private Integer evaFlagCalibration;
	private Integer evaReviewFilter;
	private Integer evaReviewStrip;
	private Integer evaCleanElectricSystem;
	private Integer evaCleanControlCard;
	private Integer evaCleanTray;
	private String evaLectrurePreasureHigh;
	private String evaLectrurePreasureLow;
	private String evaLectureTemp;
	private String evaLectureOilColor;
	private String evaLectureOilLevel;
	private String evaLectureCoolerColor;
	private String evaLectureCoolerLevel;
	private String evaCheckOperatation;
	private String evaCheckNoise;
	private String evaCheckIsolated;
	private String evaLectureVoltageGroud;
	private String evaLectureVoltagePhases;
	private String evaLectureVoltageControl;
	private String evaLectureCurrentMotor1;
	private String evaLectureCurrentMotor2;
	private String evaLectureCurrentMotor3;
	private String evaLectureCurrentCompressor1;
	private String evaLectureCurrentCompressor2;
	private String evaLectureCurrentCompressor3;
	private String evaLectureCurrentHumidifier1;
	private String evaLectureCurrentHumidifier2;
	private String evaLectureCurrentHumidifier3;
	private String evaLectureCurrentHeater1;
	private String evaLectureCurrentHeater2;
	private String evaLectureCurrentHeater3;
	private Integer evaCheckFluidSensor;
	private Integer evaRequirMaintenance;
	private String condReview;
	private Integer condCleanElectricSystem;
	private Integer condClean;
	private String condLectureVoltageGroud;
	private String condLectureVoltagePhases;
	private String condLectureVoltageControl;
	private String condLectureMotorCurrent;
	private String condReviewThermostat;
	private String condModel;
	private String condSerialNumber;
	private String condBrand;
	private String observations;
	private String receivedByEmail;
	private String responsibleName;
	
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

	public Integer getAaServiceId() {
		return aaServiceId;
	}

	public void setAaServiceId(Integer aaServiceId) {
		this.aaServiceId = aaServiceId;
	}

	public String getEvaDescription() {
		return evaDescription;
	}

	public void setEvaDescription(String evaDescription) {
		this.evaDescription = evaDescription;
	}

	public String getEvaValTemp() {
		return evaValTemp;
	}

	public void setEvaValTemp(String evaValTemp) {
		this.evaValTemp = evaValTemp;
	}

	public String getEvaValHum() {
		return evaValHum;
	}

	public void setEvaValHum(String evaValHum) {
		this.evaValHum = evaValHum;
	}

	public String getEvaSetpointTemp() {
		return evaSetpointTemp;
	}

	public void setEvaSetpointTemp(String evaSetpointTemp) {
		this.evaSetpointTemp = evaSetpointTemp;
	}

	public String getEvaSetpointHum() {
		return evaSetpointHum;
	}

	public void setEvaSetpointHum(String evaSetpointHum) {
		this.evaSetpointHum = evaSetpointHum;
	}

	public Integer getEvaFlagCalibration() {
		return evaFlagCalibration;
	}

	public void setEvaFlagCalibration(Integer evaFlagCalibration) {
		this.evaFlagCalibration = evaFlagCalibration;
	}

	public Integer getEvaReviewFilter() {
		return evaReviewFilter;
	}

	public void setEvaReviewFilter(Integer evaReviewFilter) {
		this.evaReviewFilter = evaReviewFilter;
	}

	public Integer getEvaReviewStrip() {
		return evaReviewStrip;
	}

	public void setEvaReviewStrip(Integer evaReviewStrip) {
		this.evaReviewStrip = evaReviewStrip;
	}

	public Integer getEvaCleanElectricSystem() {
		return evaCleanElectricSystem;
	}

	public void setEvaCleanElectricSystem(Integer evaCleanElectricSystem) {
		this.evaCleanElectricSystem = evaCleanElectricSystem;
	}

	public Integer getEvaCleanControlCard() {
		return evaCleanControlCard;
	}

	public void setEvaCleanControlCard(Integer evaCleanControlCard) {
		this.evaCleanControlCard = evaCleanControlCard;
	}

	public Integer getEvaCleanTray() {
		return evaCleanTray;
	}

	public void setEvaCleanTray(Integer evaCleanTray) {
		this.evaCleanTray = evaCleanTray;
	}

	public String getEvaLectrurePreasureHigh() {
		return evaLectrurePreasureHigh;
	}

	public void setEvaLectrurePreasureHigh(String evaLectrurePreasureHigh) {
		this.evaLectrurePreasureHigh = evaLectrurePreasureHigh;
	}

	public String getEvaLectrurePreasureLow() {
		return evaLectrurePreasureLow;
	}

	public void setEvaLectrurePreasureLow(String evaLectrurePreasureLow) {
		this.evaLectrurePreasureLow = evaLectrurePreasureLow;
	}

	public String getEvaLectureTemp() {
		return evaLectureTemp;
	}

	public void setEvaLectureTemp(String evaLectureTemp) {
		this.evaLectureTemp = evaLectureTemp;
	}

	public String getEvaLectureOilColor() {
		return evaLectureOilColor;
	}

	public void setEvaLectureOilColor(String evaLectureOilColor) {
		this.evaLectureOilColor = evaLectureOilColor;
	}

	public String getEvaLectureOilLevel() {
		return evaLectureOilLevel;
	}

	public void setEvaLectureOilLevel(String evaLectureOilLevel) {
		this.evaLectureOilLevel = evaLectureOilLevel;
	}

	public String getEvaLectureCoolerColor() {
		return evaLectureCoolerColor;
	}

	public void setEvaLectureCoolerColor(String evaLectureCoolerColor) {
		this.evaLectureCoolerColor = evaLectureCoolerColor;
	}

	public String getEvaLectureCoolerLevel() {
		return evaLectureCoolerLevel;
	}

	public void setEvaLectureCoolerLevel(String evaLectureCoolerLevel) {
		this.evaLectureCoolerLevel = evaLectureCoolerLevel;
	}

	public String getEvaCheckOperatation() {
		return evaCheckOperatation;
	}

	public void setEvaCheckOperatation(String evaCheckOperatation) {
		this.evaCheckOperatation = evaCheckOperatation;
	}

	public String getEvaCheckNoise() {
		return evaCheckNoise;
	}

	public void setEvaCheckNoise(String evaCheckNoise) {
		this.evaCheckNoise = evaCheckNoise;
	}

	public String getEvaCheckIsolated() {
		return evaCheckIsolated;
	}

	public void setEvaCheckIsolated(String evaCheckIsolated) {
		this.evaCheckIsolated = evaCheckIsolated;
	}

	public String getEvaLectureVoltageGroud() {
		return evaLectureVoltageGroud;
	}

	public void setEvaLectureVoltageGroud(String evaLectureVoltageGroud) {
		this.evaLectureVoltageGroud = evaLectureVoltageGroud;
	}

	public String getEvaLectureVoltagePhases() {
		return evaLectureVoltagePhases;
	}

	public void setEvaLectureVoltagePhases(String evaLectureVoltagePhases) {
		this.evaLectureVoltagePhases = evaLectureVoltagePhases;
	}

	public String getEvaLectureVoltageControl() {
		return evaLectureVoltageControl;
	}

	public void setEvaLectureVoltageControl(String evaLectureVoltageControl) {
		this.evaLectureVoltageControl = evaLectureVoltageControl;
	}

	public String getEvaLectureCurrentMotor1() {
		return evaLectureCurrentMotor1;
	}

	public void setEvaLectureCurrentMotor1(String evaLectureCurrentMotor1) {
		this.evaLectureCurrentMotor1 = evaLectureCurrentMotor1;
	}

	public String getEvaLectureCurrentMotor2() {
		return evaLectureCurrentMotor2;
	}

	public void setEvaLectureCurrentMotor2(String evaLectureCurrentMotor2) {
		this.evaLectureCurrentMotor2 = evaLectureCurrentMotor2;
	}

	public String getEvaLectureCurrentMotor3() {
		return evaLectureCurrentMotor3;
	}

	public void setEvaLectureCurrentMotor3(String evaLectureCurrentMotor3) {
		this.evaLectureCurrentMotor3 = evaLectureCurrentMotor3;
	}

	public String getEvaLectureCurrentCompressor1() {
		return evaLectureCurrentCompressor1;
	}

	public void setEvaLectureCurrentCompressor1(String evaLectureCurrentCompressor1) {
		this.evaLectureCurrentCompressor1 = evaLectureCurrentCompressor1;
	}

	public String getEvaLectureCurrentCompressor2() {
		return evaLectureCurrentCompressor2;
	}

	public void setEvaLectureCurrentCompressor2(String evaLectureCurrentCompressor2) {
		this.evaLectureCurrentCompressor2 = evaLectureCurrentCompressor2;
	}

	public String getEvaLectureCurrentCompressor3() {
		return evaLectureCurrentCompressor3;
	}

	public void setEvaLectureCurrentCompressor3(String evaLectureCurrentCompressor3) {
		this.evaLectureCurrentCompressor3 = evaLectureCurrentCompressor3;
	}

	public String getEvaLectureCurrentHumidifier1() {
		return evaLectureCurrentHumidifier1;
	}

	public void setEvaLectureCurrentHumidifier1(String evaLectureCurrentHumidifier1) {
		this.evaLectureCurrentHumidifier1 = evaLectureCurrentHumidifier1;
	}

	public String getEvaLectureCurrentHumidifier2() {
		return evaLectureCurrentHumidifier2;
	}

	public void setEvaLectureCurrentHumidifier2(String evaLectureCurrentHumidifier2) {
		this.evaLectureCurrentHumidifier2 = evaLectureCurrentHumidifier2;
	}

	public String getEvaLectureCurrentHumidifier3() {
		return evaLectureCurrentHumidifier3;
	}

	public void setEvaLectureCurrentHumidifier3(String evaLectureCurrentHumidifier3) {
		this.evaLectureCurrentHumidifier3 = evaLectureCurrentHumidifier3;
	}

	public String getEvaLectureCurrentHeater1() {
		return evaLectureCurrentHeater1;
	}

	public void setEvaLectureCurrentHeater1(String evaLectureCurrentHeater1) {
		this.evaLectureCurrentHeater1 = evaLectureCurrentHeater1;
	}

	public String getEvaLectureCurrentHeater2() {
		return evaLectureCurrentHeater2;
	}

	public void setEvaLectureCurrentHeater2(String evaLectureCurrentHeater2) {
		this.evaLectureCurrentHeater2 = evaLectureCurrentHeater2;
	}

	public String getEvaLectureCurrentHeater3() {
		return evaLectureCurrentHeater3;
	}

	public void setEvaLectureCurrentHeater3(String evaLectureCurrentHeater3) {
		this.evaLectureCurrentHeater3 = evaLectureCurrentHeater3;
	}

	public Integer getEvaCheckFluidSensor() {
		return evaCheckFluidSensor;
	}

	public void setEvaCheckFluidSensor(Integer evaCheckFluidSensor) {
		this.evaCheckFluidSensor = evaCheckFluidSensor;
	}

	public Integer getEvaRequirMaintenance() {
		return evaRequirMaintenance;
	}

	public void setEvaRequirMaintenance(Integer evaRequirMaintenance) {
		this.evaRequirMaintenance = evaRequirMaintenance;
	}

	public String getCondReview() {
		return condReview;
	}

	public void setCondReview(String condReview) {
		this.condReview = condReview;
	}

	public Integer getCondCleanElectricSystem() {
		return condCleanElectricSystem;
	}

	public void setCondCleanElectricSystem(Integer condCleanElectricSystem) {
		this.condCleanElectricSystem = condCleanElectricSystem;
	}

	public Integer getCondClean() {
		return condClean;
	}

	public void setCondClean(Integer condClean) {
		this.condClean = condClean;
	}

	public String getCondLectureVoltageGroud() {
		return condLectureVoltageGroud;
	}

	public void setCondLectureVoltageGroud(String condLectureVoltageGroud) {
		this.condLectureVoltageGroud = condLectureVoltageGroud;
	}

	public String getCondLectureVoltagePhases() {
		return condLectureVoltagePhases;
	}

	public void setCondLectureVoltagePhases(String condLectureVoltagePhases) {
		this.condLectureVoltagePhases = condLectureVoltagePhases;
	}

	public String getCondLectureVoltageControl() {
		return condLectureVoltageControl;
	}

	public void setCondLectureVoltageControl(String condLectureVoltageControl) {
		this.condLectureVoltageControl = condLectureVoltageControl;
	}

	public String getCondLectureMotorCurrent() {
		return condLectureMotorCurrent;
	}

	public void setCondLectureMotorCurrent(String condLectureMotorCurrent) {
		this.condLectureMotorCurrent = condLectureMotorCurrent;
	}

	public String getCondReviewThermostat() {
		return condReviewThermostat;
	}

	public void setCondReviewThermostat(String condReviewThermostat) {
		this.condReviewThermostat = condReviewThermostat;
	}

	public String getCondModel() {
		return condModel;
	}

	public void setCondModel(String condModel) {
		this.condModel = condModel;
	}

	public String getCondSerialNumber() {
		return condSerialNumber;
	}

	public void setCondSerialNumber(String condSerialNumber) {
		this.condSerialNumber = condSerialNumber;
	}

	public String getCondBrand() {
		return condBrand;
	}

	public void setCondBrand(String condBrand) {
		this.condBrand = condBrand;
	}

	public String getObservations() {
		return observations;
	}

	public void setObservations(String observations) {
		this.observations = observations;
	}

	public String getReceivedByEmail() {
		return receivedByEmail;
	}

	public void setReceivedByEmail(String receivedByEmail) {
		this.receivedByEmail = receivedByEmail;
	}

	public String getResponsibleName() {
		return responsibleName;
	}

	public void setResponsibleName(String responsibleName) {
		this.responsibleName = responsibleName;
	}

	public Integer getHasPdf() {
		return hasPdf;
	}

	public void setHasPdf(Integer hasPdf) {
		this.hasPdf = hasPdf;
	}
	
}
