
package com.blackstar.model.dto;

import java.util.Date;

import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;

public class AirCoServicePolicyDTO {

	public AirCoServicePolicyDTO()
	{
		this.closed = new Date();
		this.serviceDate = new Date();
	}
	
	public AirCoServicePolicyDTO(Policy policy, String equipmentType)
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
	
	public AirCoServicePolicyDTO(Policy policy, String equipmentType, Serviceorder serviceOrder)
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
	
	public AirCoServicePolicyDTO(Policy policy, String equipmentType, Serviceorder serviceOrder,  AirCoServiceDTO airCo)
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
	
	private Integer aaServiceId;
	private String evaDescription;
	private Double evaValTemp;
	private Double evaValHum;
	private Double evaSetpointTemp;
	private Double evaSetpointHum;
	private Boolean evaFlagCalibration;
	private Boolean evaReviewFilter;
	private Boolean evaReviewStrip;
	private Boolean evaCleanElectricSystem;
	private Boolean evaCleanControlCard;
	private Boolean evaCleanTray;
	private Double evaLectrurePreasureHigh;
	private Double evaLectrurePreasureLow;
	private Double evaLectureTemp;
	private String evaLectureOilColor;
	private Double evaLectureOilLevel;
	private String evaLectureCoolerColor;
	private Double evaLectureCoolerLevel;
	private String evaCheckOperatation;
	private String evaCheckNoise;
	private String evaCheckIsolated;
	private Double evaLectureVoltageGroud;
	private Double evaLectureVoltagePhases;
	private Double evaLectureVoltageControl;
	private Double evaLectureCurrentMotor1;
	private Double evaLectureCurrentMotor2;
	private Double evaLectureCurrentMotor3;
	private Double evaLectureCurrentCompressor1;
	private Double evaLectureCurrentCompressor2;
	private Double evaLectureCurrentCompressor3;
	private Double evaLectureCurrentHumidifier1;
	private Double evaLectureCurrentHumidifier2;
	private Double evaLectureCurrentHumidifier3;
	private Double evaLectureCurrentHeater1;
	private Double evaLectureCurrentHeater2;
	private Double evaLectureCurrentHeater3;
	private Boolean evaCheckFluidSensor;
	private Boolean evaRequirMaintenance;
	private String condReview;
	private Boolean condCleanElectricSystem;
	private Boolean condClean;
	private Double condLectureVoltageGroud;
	private Double condLectureVoltagePhases;
	private Double condLectureVoltageControl;
	private Double condLectureMotorCurrent;
	private String condReviewThermostat;
	private String condModel;
	private String condSerialNumber;
	private String condBrand;
	private String observations;
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
	public Double getEvaValTemp() {
		return evaValTemp;
	}
	public void setEvaValTemp(Double evaValTemp) {
		this.evaValTemp = evaValTemp;
	}
	public Double getEvaValHum() {
		return evaValHum;
	}
	public void setEvaValHum(Double evaValHum) {
		this.evaValHum = evaValHum;
	}
	public Double getEvaSetpointTemp() {
		return evaSetpointTemp;
	}
	public void setEvaSetpointTemp(Double evaSetpointTemp) {
		this.evaSetpointTemp = evaSetpointTemp;
	}
	public Double getEvaSetpointHum() {
		return evaSetpointHum;
	}
	public void setEvaSetpointHum(Double evaSetpointHum) {
		this.evaSetpointHum = evaSetpointHum;
	}
	public Boolean getEvaFlagCalibration() {
		return evaFlagCalibration;
	}
	public void setEvaFlagCalibration(Boolean evaFlagCalibration) {
		this.evaFlagCalibration = evaFlagCalibration;
	}
	public Boolean getEvaReviewFilter() {
		return evaReviewFilter;
	}
	public void setEvaReviewFilter(Boolean evaReviewFilter) {
		this.evaReviewFilter = evaReviewFilter;
	}
	public Boolean getEvaReviewStrip() {
		return evaReviewStrip;
	}
	public void setEvaReviewStrip(Boolean evaReviewStrip) {
		this.evaReviewStrip = evaReviewStrip;
	}
	public Boolean getEvaCleanElectricSystem() {
		return evaCleanElectricSystem;
	}
	public void setEvaCleanElectricSystem(Boolean evaCleanElectricSystem) {
		this.evaCleanElectricSystem = evaCleanElectricSystem;
	}
	public Boolean getEvaCleanControlCard() {
		return evaCleanControlCard;
	}
	public void setEvaCleanControlCard(Boolean evaCleanControlCard) {
		this.evaCleanControlCard = evaCleanControlCard;
	}
	public Boolean getEvaCleanTray() {
		return evaCleanTray;
	}
	public void setEvaCleanTray(Boolean evaCleanTray) {
		this.evaCleanTray = evaCleanTray;
	}
	public Double getEvaLectrurePreasureHigh() {
		return evaLectrurePreasureHigh;
	}
	public void setEvaLectrurePreasureHigh(Double evaLectrurePreasureHigh) {
		this.evaLectrurePreasureHigh = evaLectrurePreasureHigh;
	}
	public Double getEvaLectrurePreasureLow() {
		return evaLectrurePreasureLow;
	}
	public void setEvaLectrurePreasureLow(Double evaLectrurePreasureLow) {
		this.evaLectrurePreasureLow = evaLectrurePreasureLow;
	}
	public Double getEvaLectureTemp() {
		return evaLectureTemp;
	}
	public void setEvaLectureTemp(Double evaLectureTemp) {
		this.evaLectureTemp = evaLectureTemp;
	}
	public String getEvaLectureOilColor() {
		return evaLectureOilColor;
	}
	public void setEvaLectureOilColor(String evaLectureOilColor) {
		this.evaLectureOilColor = evaLectureOilColor;
	}
	public Double getEvaLectureOilLevel() {
		return evaLectureOilLevel;
	}
	public void setEvaLectureOilLevel(Double evaLectureOilLevel) {
		this.evaLectureOilLevel = evaLectureOilLevel;
	}
	public String getEvaLectureCoolerColor() {
		return evaLectureCoolerColor;
	}
	public void setEvaLectureCoolerColor(String evaLectureCoolerColor) {
		this.evaLectureCoolerColor = evaLectureCoolerColor;
	}
	public Double getEvaLectureCoolerLevel() {
		return evaLectureCoolerLevel;
	}
	public void setEvaLectureCoolerLevel(Double evaLectureCoolerLevel) {
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
	public Double getEvaLectureVoltageGroud() {
		return evaLectureVoltageGroud;
	}
	public void setEvaLectureVoltageGroud(Double evaLectureVoltageGroud) {
		this.evaLectureVoltageGroud = evaLectureVoltageGroud;
	}
	public Double getEvaLectureVoltagePhases() {
		return evaLectureVoltagePhases;
	}
	public void setEvaLectureVoltagePhases(Double evaLectureVoltagePhases) {
		this.evaLectureVoltagePhases = evaLectureVoltagePhases;
	}
	public Double getEvaLectureVoltageControl() {
		return evaLectureVoltageControl;
	}
	public void setEvaLectureVoltageControl(Double evaLectureVoltageControl) {
		this.evaLectureVoltageControl = evaLectureVoltageControl;
	}
	public Double getEvaLectureCurrentMotor1() {
		return evaLectureCurrentMotor1;
	}
	public void setEvaLectureCurrentMotor1(Double evaLectureCurrentMotor1) {
		this.evaLectureCurrentMotor1 = evaLectureCurrentMotor1;
	}
	public Double getEvaLectureCurrentMotor2() {
		return evaLectureCurrentMotor2;
	}
	public void setEvaLectureCurrentMotor2(Double evaLectureCurrentMotor2) {
		this.evaLectureCurrentMotor2 = evaLectureCurrentMotor2;
	}
	public Double getEvaLectureCurrentMotor3() {
		return evaLectureCurrentMotor3;
	}
	public void setEvaLectureCurrentMotor3(Double evaLectureCurrentMotor3) {
		this.evaLectureCurrentMotor3 = evaLectureCurrentMotor3;
	}
	public Double getEvaLectureCurrentCompressor1() {
		return evaLectureCurrentCompressor1;
	}
	public void setEvaLectureCurrentCompressor1(Double evaLectureCurrentCompressor1) {
		this.evaLectureCurrentCompressor1 = evaLectureCurrentCompressor1;
	}
	public Double getEvaLectureCurrentCompressor2() {
		return evaLectureCurrentCompressor2;
	}
	public void setEvaLectureCurrentCompressor2(Double evaLectureCurrentCompressor2) {
		this.evaLectureCurrentCompressor2 = evaLectureCurrentCompressor2;
	}
	public Double getEvaLectureCurrentCompressor3() {
		return evaLectureCurrentCompressor3;
	}
	public void setEvaLectureCurrentCompressor3(Double evaLectureCurrentCompressor3) {
		this.evaLectureCurrentCompressor3 = evaLectureCurrentCompressor3;
	}
	public Double getEvaLectureCurrentHumidifier1() {
		return evaLectureCurrentHumidifier1;
	}
	public void setEvaLectureCurrentHumidifier1(Double evaLectureCurrentHumidifier1) {
		this.evaLectureCurrentHumidifier1 = evaLectureCurrentHumidifier1;
	}
	public Double getEvaLectureCurrentHumidifier2() {
		return evaLectureCurrentHumidifier2;
	}
	public void setEvaLectureCurrentHumidifier2(Double evaLectureCurrentHumidifier2) {
		this.evaLectureCurrentHumidifier2 = evaLectureCurrentHumidifier2;
	}
	public Double getEvaLectureCurrentHumidifier3() {
		return evaLectureCurrentHumidifier3;
	}
	public void setEvaLectureCurrentHumidifier3(Double evaLectureCurrentHumidifier3) {
		this.evaLectureCurrentHumidifier3 = evaLectureCurrentHumidifier3;
	}
	public Double getEvaLectureCurrentHeater1() {
		return evaLectureCurrentHeater1;
	}
	public void setEvaLectureCurrentHeater1(Double evaLectureCurrentHeater1) {
		this.evaLectureCurrentHeater1 = evaLectureCurrentHeater1;
	}
	public Double getEvaLectureCurrentHeater2() {
		return evaLectureCurrentHeater2;
	}
	public void setEvaLectureCurrentHeater2(Double evaLectureCurrentHeater2) {
		this.evaLectureCurrentHeater2 = evaLectureCurrentHeater2;
	}
	public Double getEvaLectureCurrentHeater3() {
		return evaLectureCurrentHeater3;
	}
	public void setEvaLectureCurrentHeater3(Double evaLectureCurrentHeater3) {
		this.evaLectureCurrentHeater3 = evaLectureCurrentHeater3;
	}
	public Boolean getEvaCheckFluidSensor() {
		return evaCheckFluidSensor;
	}
	public void setEvaCheckFluidSensor(Boolean evaCheckFluidSensor) {
		this.evaCheckFluidSensor = evaCheckFluidSensor;
	}
	public Boolean getEvaRequirMaintenance() {
		return evaRequirMaintenance;
	}
	public void setEvaRequirMaintenance(Boolean evaRequirMaintenance) {
		this.evaRequirMaintenance = evaRequirMaintenance;
	}
	public String getCondReview() {
		return condReview;
	}
	public void setCondReview(String condReview) {
		this.condReview = condReview;
	}
	public Boolean getCondCleanElectricSystem() {
		return condCleanElectricSystem;
	}
	public void setCondCleanElectricSystem(Boolean condCleanElectricSystem) {
		this.condCleanElectricSystem = condCleanElectricSystem;
	}
	public Boolean getCondClean() {
		return condClean;
	}
	public void setCondClean(Boolean condClean) {
		this.condClean = condClean;
	}
	public Double getCondLectureVoltageGroud() {
		return condLectureVoltageGroud;
	}
	public void setCondLectureVoltageGroud(Double condLectureVoltageGroud) {
		this.condLectureVoltageGroud = condLectureVoltageGroud;
	}
	public Double getCondLectureVoltagePhases() {
		return condLectureVoltagePhases;
	}
	public void setCondLectureVoltagePhases(Double condLectureVoltagePhases) {
		this.condLectureVoltagePhases = condLectureVoltagePhases;
	}
	public Double getCondLectureVoltageControl() {
		return condLectureVoltageControl;
	}
	public void setCondLectureVoltageControl(Double condLectureVoltageControl) {
		this.condLectureVoltageControl = condLectureVoltageControl;
	}
	public Double getCondLectureMotorCurrent() {
		return condLectureMotorCurrent;
	}
	public void setCondLectureMotorCurrent(Double condLectureMotorCurrent) {
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
}
