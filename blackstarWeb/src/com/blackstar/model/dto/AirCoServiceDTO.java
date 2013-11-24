package com.blackstar.model.dto;

import java.util.Date;

import com.blackstar.model.AirCoService;


public class AirCoServiceDTO {
	
	public AirCoServiceDTO()
	{
		
	}
	
	public AirCoServiceDTO(OrderserviceDTO serviceOrder, AirCoService airCoServiceModel )
	{
		this.aaServiceId = airCoServiceModel.getAaServiceId();
		this.serviceOrderId = airCoServiceModel.getServiceOrderId();
		
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
		
		this.evaDescription = airCoServiceModel.getEvaDescription();
		this.evaValTemp = airCoServiceModel.getEvaValTemp();
		this.evaValHum = airCoServiceModel.getEvaValHum();
		this.evaSetpointTemp = airCoServiceModel.getEvaSetpointTemp();
		this.evaSetpointHum = airCoServiceModel.getEvaSetpointHum();
		this.evaFlagCalibration = airCoServiceModel.getEvaFlagCalibration();
		this.evaReviewFilter = airCoServiceModel.getEvaReviewFilter();
		this.evaReviewStrip = airCoServiceModel.getEvaReviewStrip();
		this.evaCleanElectricSystem = airCoServiceModel.getEvaCleanElectricSystem();
		this.evaCleanControlCard = airCoServiceModel.getEvaCleanControlCard();
		this.evaCleanTray = airCoServiceModel.getEvaCleanTray();
		this.evaLectrurePreasureHigh = airCoServiceModel.getEvaLectrurePreasureHigh();
		this.evaLectrurePreasureLow = airCoServiceModel.getEvaLectrurePreasureLow();
		this.evaLectureTemp = airCoServiceModel.getEvaLectureTemp();
		this.evaLectureOilColor = airCoServiceModel.getEvaLectureOilColor();
		this.evaLectureOilLevel = airCoServiceModel.getEvaLectureOilLevel();
		this.evaLectureCoolerColor = airCoServiceModel.getEvaLectureCoolerColor();
		this.evaLectureCoolerLevel = airCoServiceModel.getEvaLectureCoolerLevel();
		this.evaCheckOperatation = airCoServiceModel.getEvaCheckOperatation();
		this.evaCheckNoise = airCoServiceModel.getEvaCheckNoise();
		this.evaCheckIsolated = airCoServiceModel.getEvaCheckIsolated();
		this.evaLectureVoltageGroud = airCoServiceModel.getEvaLectureVoltageGroud();
		this.evaLectureVoltagePhases = airCoServiceModel.getEvaLectureVoltagePhases();
		this.evaLectureVoltageControl = airCoServiceModel.getEvaLectureVoltageControl();
		this.evaLectureCurrentMotor1 = airCoServiceModel.getEvaLectureCurrentMotor1();
		this.evaLectureCurrentMotor2 = airCoServiceModel.getEvaLectureCurrentMotor2();
		this.evaLectureCurrentMotor3 = airCoServiceModel.getEvaLectureCurrentMotor3();
		this.evaLectureCurrentCompressor1 = airCoServiceModel.getEvaLectureCurrentCompressor1();
		this.evaLectureCurrentCompressor2 = airCoServiceModel.getEvaLectureCurrentCompressor2();
		this.evaLectureCurrentCompressor3 = airCoServiceModel.getEvaLectureCurrentCompressor3();
		this.evaLectureCurrentHumidifier1 = airCoServiceModel.getEvaLectureCurrentHumidifier1();
		this.evaLectureCurrentHumidifier2 = airCoServiceModel.getEvaLectureCurrentHumidifier2();
		this.evaLectureCurrentHumidifier3 = airCoServiceModel.getEvaLectureCurrentHumidifier3();
		this.evaLectureCurrentHeater1 = airCoServiceModel.getEvaLectureCurrentHeater1();
		this.evaLectureCurrentHeater2 = airCoServiceModel.getEvaLectureCurrentHeater2();
		this.evaLectureCurrentHeater3 = airCoServiceModel.getEvaLectureCurrentHeater3();
		this.evaCheckFluidSensor = airCoServiceModel.getEvaCheckFluidSensor();
		this.evaRequirMaintenance = airCoServiceModel.getEvaRequirMaintenance();
		this.condReview = airCoServiceModel.getCondReview();
		this.condCleanElectricSystem = airCoServiceModel.getCondCleanElectricSystem();
		this.condClean = airCoServiceModel.getCondClean();
		this.condLectureVoltageGroud = airCoServiceModel.getCondLectureVoltageGroud();
		this.condLectureVoltagePhases = airCoServiceModel.getCondLectureVoltagePhases();
		this.condLectureVoltageControl = airCoServiceModel.getCondLectureVoltageControl();
		this.condLectureMotorCurrent = airCoServiceModel.getCondLectureMotorCurrent();
		this.condReviewThermostat = airCoServiceModel.getCondReviewThermostat();
		this.condModel = airCoServiceModel.getCondModel();
		this.condSerialNumber = airCoServiceModel.getCondSerialNumber();
		this.condBrand = airCoServiceModel.getCondBrand();
		this.observations = airCoServiceModel.getObservations();
	}
	
	public AirCoServiceDTO(Integer aaServiceId, Integer serviceOrderId,
			String coordinator, String serviceOrderNo, String ticketNo,
			Integer ticketId, Integer policyId, String serviceTypeId,
			String equipmentTypeId, String customer, String equipmentAddress,
			Date serviceDate, String contactName, String contactPhone,
			String equipmentType, String equipmentBrand, String equipmentModel,
			String equipmentSerialNo, String failureDescription,
			String serviceType, String proyectNumber,  String signCreated,
			String signReceivedBy, String receivedBy,
			String receivedByPosition, String responsible, Date closed,
			String evaDescription, Double evaValTemp, Double evaValHum,
			Double evaSetpointTemp, Double evaSetpointHum,
			Boolean evaFlagCalibration, Boolean evaReviewFilter,
			Boolean evaReviewStrip, Boolean evaCleanElectricSystem,
			Boolean evaCleanControlCard, Boolean evaCleanTray,
			Double evaLectrurePreasureHigh, Double evaLectrurePreasureLow,
			Double evaLectureTemp, String evaLectureOilColor,
			Double evaLectureOilLevel, String evaLectureCoolerColor,
			Double evaLectureCoolerLevel, String evaCheckOperatation,
			String evaCheckNoise, String evaCheckIsolated,
			Double evaLectureVoltageGroud, Double evaLectureVoltagePhases,
			Double evaLectureVoltageControl, Double evaLectureCurrentMotor1,
			Double evaLectureCurrentMotor2, Double evaLectureCurrentMotor3,
			Double evaLectureCurrentCompressor1,
			Double evaLectureCurrentCompressor2,
			Double evaLectureCurrentCompressor3,
			Double evaLectureCurrentHumidifier1,
			Double evaLectureCurrentHumidifier2,
			Double evaLectureCurrentHumidifier3,
			Double evaLectureCurrentHeater1, Double evaLectureCurrentHeater2,
			Double evaLectureCurrentHeater3, Boolean evaCheckFluidSensor,
			Boolean evaRequirMaintenance, String condReview,
			Boolean condCleanElectricSystem, Boolean condClean,
			Double condLectureVoltageGroud, Double condLectureVoltagePhases,
			Double condLectureVoltageControl, Double condLectureMotorCurrent,
			String condReviewThermostat, String condModel,
			String condSerialNumber, String condBrand, String observations) {
		this.aaServiceId = aaServiceId;
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
		this.signCreated = signCreated;
		this.signReceivedBy = signReceivedBy;
		this.receivedBy = receivedBy;
		this.receivedByPosition = receivedByPosition;
		this.responsible = responsible;
		this.closed = closed;		
		this.evaDescription = evaDescription;
		this.evaValTemp = evaValTemp;
		this.evaValHum = evaValHum;
		this.evaSetpointTemp = evaSetpointTemp;
		this.evaSetpointHum = evaSetpointHum;
		this.evaFlagCalibration = evaFlagCalibration;
		this.evaReviewFilter = evaReviewFilter;
		this.evaReviewStrip = evaReviewStrip;
		this.evaCleanElectricSystem = evaCleanElectricSystem;
		this.evaCleanControlCard = evaCleanControlCard;
		this.evaCleanTray = evaCleanTray;
		this.evaLectrurePreasureHigh = evaLectrurePreasureHigh;
		this.evaLectrurePreasureLow = evaLectrurePreasureLow;
		this.evaLectureTemp = evaLectureTemp;
		this.evaLectureOilColor = evaLectureOilColor;
		this.evaLectureOilLevel = evaLectureOilLevel;
		this.evaLectureCoolerColor = evaLectureCoolerColor;
		this.evaLectureCoolerLevel = evaLectureCoolerLevel;
		this.evaCheckOperatation = evaCheckOperatation;
		this.evaCheckNoise = evaCheckNoise;
		this.evaCheckIsolated = evaCheckIsolated;
		this.evaLectureVoltageGroud = evaLectureVoltageGroud;
		this.evaLectureVoltagePhases = evaLectureVoltagePhases;
		this.evaLectureVoltageControl = evaLectureVoltageControl;
		this.evaLectureCurrentMotor1 = evaLectureCurrentMotor1;
		this.evaLectureCurrentMotor2 = evaLectureCurrentMotor2;
		this.evaLectureCurrentMotor3 = evaLectureCurrentMotor3;
		this.evaLectureCurrentCompressor1 = evaLectureCurrentCompressor1;
		this.evaLectureCurrentCompressor2 = evaLectureCurrentCompressor2;
		this.evaLectureCurrentCompressor3 = evaLectureCurrentCompressor3;
		this.evaLectureCurrentHumidifier1 = evaLectureCurrentHumidifier1;
		this.evaLectureCurrentHumidifier2 = evaLectureCurrentHumidifier2;
		this.evaLectureCurrentHumidifier3 = evaLectureCurrentHumidifier3;
		this.evaLectureCurrentHeater1 = evaLectureCurrentHeater1;
		this.evaLectureCurrentHeater2 = evaLectureCurrentHeater2;
		this.evaLectureCurrentHeater3 = evaLectureCurrentHeater3;
		this.evaCheckFluidSensor = evaCheckFluidSensor;
		this.evaRequirMaintenance = evaRequirMaintenance;
		this.condReview = condReview;
		this.condCleanElectricSystem = condCleanElectricSystem;
		this.condClean = condClean;
		this.condLectureVoltageGroud = condLectureVoltageGroud;
		this.condLectureVoltagePhases = condLectureVoltagePhases;
		this.condLectureVoltageControl = condLectureVoltageControl;
		this.condLectureMotorCurrent = condLectureMotorCurrent;
		this.condReviewThermostat = condReviewThermostat;
		this.condModel = condModel;
		this.condSerialNumber = condSerialNumber;
		this.condBrand = condBrand;
		this.observations = observations;
	}
	
	
	private Integer aaServiceId;
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
	private String signCreated;
	private String signReceivedBy;
	private String receivedBy;
	private String receivedByPosition;
	private String responsible;
	private Date closed;
	
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
	public Integer getAaServiceId() {
		return aaServiceId;
	}
	public void setAaServiceId(Integer aaServiceId) {
		this.aaServiceId = aaServiceId;
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
}
