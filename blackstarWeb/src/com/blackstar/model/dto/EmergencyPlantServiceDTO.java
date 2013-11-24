package com.blackstar.model.dto;

import java.util.Date;

import com.blackstar.model.EmergencyPlantService;
import com.blackstar.model.EmergencyPlantServiceDynamicTest;
import com.blackstar.model.EmergencyPlantServiceLectures;
import com.blackstar.model.EmergencyPlantServiceParams;
import com.blackstar.model.EmergencyPlantServiceSurvey;
import com.blackstar.model.EmergencyPlantServiceTestProtection;
import com.blackstar.model.EmergencyPlantServiceTransferSwitch;
import com.blackstar.model.EmergencyPlantServiceWorkBasic;

public class EmergencyPlantServiceDTO {
	
	public EmergencyPlantServiceDTO()
	{}
	
	public EmergencyPlantServiceDTO(OrderserviceDTO serviceOrder, EmergencyPlantService emergencyPlantService, EmergencyPlantServiceSurvey emergencyPlantServiceSurvey, EmergencyPlantServiceWorkBasic emergencyPlantServiceWorkBasic, 
									EmergencyPlantServiceDynamicTest emergencyPlantServiceDynamicTest, EmergencyPlantServiceTestProtection emergencyPlantServiceTestProtection,
									EmergencyPlantServiceTransferSwitch emergencyPlantServiceTransferSwitch, EmergencyPlantServiceLectures emergencyPlantServiceLectures,
									EmergencyPlantServiceParams emergencyPlantServiceParams)
	{
		this.epServiceId = emergencyPlantService.getEpServiceId();
		this.serviceOrderId = emergencyPlantService.getServiceOrderId();
		
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
		
		this.brandPE = emergencyPlantService.getBrandPE();
		this.modelPE  = emergencyPlantService.getModelPE();
		this.serialPE  = emergencyPlantService.getSerialPE();
		this.transferType = emergencyPlantService.getTransferType();
		this.modelTransfer = emergencyPlantService.getModelTransfer();
		this.modelControl = emergencyPlantService.getModelControl();
		this.modelRegVoltage = emergencyPlantService.getModelRegVoltage();
		this.modelRegVelocity = emergencyPlantService.getModelRegVelocity();
		this.modelCharger = emergencyPlantService.getModelCharger();
		this.oilChange = emergencyPlantService.getOilChange();
		this.brandMotor = emergencyPlantService.getBrandMotor();
		this.modelMotor = emergencyPlantService.getModelMotor();
		this.serialMotor = emergencyPlantService.getSerialMotor();
		this.cplMotor = emergencyPlantService.getCplMotor();
		this.brandGenerator = emergencyPlantService.getBrandGenerator();
		this.modelGenerator = emergencyPlantService.getModelGenerator();
		this.serialGenerator = emergencyPlantService.getSerialGenerator();
		this.powerWattGenerator = emergencyPlantService.getPowerWattGenerator();
		this.tensionGenerator = emergencyPlantService.getTensionGenerator();
		this.tuningDate = emergencyPlantService.getTuningDate();
		this.tankCapacity = emergencyPlantService.getTankCapacity();
		this.pumpFuelModel = emergencyPlantService.getPumpFuelModel();
		this.filterFuelFlag = emergencyPlantService.getFilterFuelFlag();
		this.filterOilFlag = emergencyPlantService.getFilterOilFlag();
		this.filterWaterFlag = emergencyPlantService.getFilterWaterFlag();
		this.filterAirFlag = emergencyPlantService.getFilterAirFlag();
		this.brandGear = emergencyPlantService.getBrandGear();
		this.brandBattery = emergencyPlantService.getBrandBattery();
		this.clockLecture = emergencyPlantService.getClockLecture();
		this.serviceCorrective = emergencyPlantService.getServiceCorrective();
		this.observations = emergencyPlantService.getObservations();
		
		this.epServiceSurveyId = emergencyPlantServiceSurvey.getEpServiceSurveyId();
		this.levelOilFlag =  emergencyPlantServiceSurvey.getLevelOilFlag();
		this.levelWaterFlag =  emergencyPlantServiceSurvey.getLevelWaterFlag();
		this.levelBattery =  emergencyPlantServiceSurvey.getLevelBattery();
		this.tubeLeak =  emergencyPlantServiceSurvey.getTubeLeak();
		this.batteryCap =  emergencyPlantServiceSurvey.getBatteryCap();
		this.batterySulfate =  emergencyPlantServiceSurvey.getBatterySulfate();
		this.levelOil =  emergencyPlantServiceSurvey.getLevelOil();
		this.heatEngine =  emergencyPlantServiceSurvey.getHeatEngine();
		this.hoseOil =  emergencyPlantServiceSurvey.getHoseOil();
		this.hoseWater =  emergencyPlantServiceSurvey.getHoseWater();
		this.tubeValve =  emergencyPlantServiceSurvey.getTubeValve();
		this.stripBlades =  emergencyPlantServiceSurvey.getStripBlades();
		
		this.epServiceWorkBasicId = emergencyPlantServiceWorkBasic.getEpServiceWorkBasicId();
		this.washEngine = emergencyPlantServiceWorkBasic.getWashEngine();
		this.washRadiator = emergencyPlantServiceWorkBasic.getWashRadiator();
		this.cleanWorkArea = emergencyPlantServiceWorkBasic.getCleanWorkArea();
		this.conectionCheck = emergencyPlantServiceWorkBasic.getConectionCheck();
		this.cleanTransfer = emergencyPlantServiceWorkBasic.getCleanTransfer();
		this.cleanCardControl = emergencyPlantServiceWorkBasic.getCleanCardControl();
		this.checkConectionControl = emergencyPlantServiceWorkBasic.getCheckConectionControl();
		this.checkWinding = emergencyPlantServiceWorkBasic.getCheckWinding();
		this.batteryTests = emergencyPlantServiceWorkBasic.getBatteryTests();
		this.checkCharger = emergencyPlantServiceWorkBasic.getCheckCharger();
		this.checkPaint = emergencyPlantServiceWorkBasic.getCheckPaint();
		this.cleanGenerator = emergencyPlantServiceWorkBasic.getCleanGenerator();
		
		this.epServiceDynamicTestId = emergencyPlantServiceDynamicTest.getEpServiceDynamicTestId();
		this.vacuumFrequency = emergencyPlantServiceDynamicTest.getVacuumFrequency();
		this.chargeFrequency = emergencyPlantServiceDynamicTest.getChargeFrequency();
		this.bootTryouts = emergencyPlantServiceDynamicTest.getBootTryouts();
		this.vacuumVoltage = emergencyPlantServiceDynamicTest.getVacuumVoltage();
		this.chargeVoltage = emergencyPlantServiceDynamicTest.getChargeVoltage();
		this.qualitySmoke = emergencyPlantServiceDynamicTest.getQualitySmoke();
		this.startTime = emergencyPlantServiceDynamicTest.getStartTime();
		this.transferTime = emergencyPlantServiceDynamicTest.getTransferTime();
		this.stopTime = emergencyPlantServiceDynamicTest.getStopTime();
		
		this.epServiceTestProtectionId = emergencyPlantServiceTestProtection.getEpServiceTestProtectionId();
		this.tempSensor = emergencyPlantServiceTestProtection.getTempSensor();
		this.oilSensor = emergencyPlantServiceTestProtection.getOilSensor();
		this.voltageSensor = emergencyPlantServiceTestProtection.getVoltageSensor();
		this.overSpeedSensor = emergencyPlantServiceTestProtection.getOverSpeedSensor();
		this.oilPreasureSensor = emergencyPlantServiceTestProtection.getOilPreasureSensor();
		this.waterLevelSensor = emergencyPlantServiceTestProtection.getWaterLevelSensor();
		
		this.epServiceTransferSwitchId = emergencyPlantServiceTransferSwitch.getEpServiceTransferSwitchId();
		this.mechanicalStatus = emergencyPlantServiceTransferSwitch.getMechanicalStatus();
		this.boardClean = emergencyPlantServiceTransferSwitch.getBoardClean();
		this.screwAdjust = emergencyPlantServiceTransferSwitch.getScrewAdjust();
		this.conectionAdjust = emergencyPlantServiceTransferSwitch.getConectionAdjust();
		this.systemMotors = emergencyPlantServiceTransferSwitch.getSystemMotors();
		this.electricInterlock = emergencyPlantServiceTransferSwitch.getElectricInterlock();
		this.mechanicalInterlock = emergencyPlantServiceTransferSwitch.getMechanicalInterlock();
		this.capacityAmp = emergencyPlantServiceTransferSwitch.getCapacityAmp();
		
		this.epServiceLecturesId = emergencyPlantServiceLectures.getEpServiceLecturesId();
		this.voltageABAN = emergencyPlantServiceLectures.getVoltageABAN();
		this.voltageACCN = emergencyPlantServiceLectures.getVoltageACCN();
		this.voltageBCBN = emergencyPlantServiceLectures.getVoltageBCBN();
		this.voltageNT = emergencyPlantServiceLectures.getVoltageNT();
		this.currentA = emergencyPlantServiceLectures.getCurrentA();
		this.currentB = emergencyPlantServiceLectures.getCurrentB();
		this.currentC = emergencyPlantServiceLectures.getCurrentC();
		this.frequency = emergencyPlantServiceLectures.getFrequency();
		this.oilPreassure = emergencyPlantServiceLectures.getOilPreassure();
		this.temp = emergencyPlantServiceLectures.getTemp();
		
		this.epServiceParamsId = emergencyPlantServiceParams.getEpServiceParamsId();
		this.adjsutmentTherm = emergencyPlantServiceParams.getAdjsutmentTherm();
		this.current = emergencyPlantServiceParams.getCurrent();
		this.batteryCurrent = emergencyPlantServiceParams.getBatteryCurrent();
		this.clockStatus = emergencyPlantServiceParams.getClockStatus();
		this.trasnferTypeProtection = emergencyPlantServiceParams.getTrasnferTypeProtection();
		this.generatorTypeProtection = emergencyPlantServiceParams.getGeneratorTypeProtection();
	}
	
	public EmergencyPlantServiceDTO(Integer epServiceId, Integer serviceOrderId,
			String coordinator, String serviceOrderNo, String ticketNo,
			Integer ticketId, Integer policyId, String serviceTypeId,
			String equipmentTypeId, String customer, String equipmentAddress,
			Date serviceDate, String contactName, String contactPhone,
			String equipmentType, String equipmentBrand, String equipmentModel,
			String equipmentSerialNo, String failureDescription,
			String serviceType, String proyectNumber, String signCreated,
			String signReceivedBy, String receivedBy,
			String receivedByPosition, String responsible, Date closed,
			String transferType, String modelTransfer, String modelControl,
			String modelRegVoltage, String modelRegVelocity,
			String modelCharger, Date oilChange, String brandMotor,
			String modelMotor, String serialMotor, String cplMotor,
			String brandGenerator, String modelGenerator,
			String serialGenerator, Integer powerWattGenerator,
			Integer tensionGenerator, Date tuningDate, Integer tankCapacity,
			String pumpFuelModel, Boolean filterFuelFlag,
			Boolean filterOilFlag, Boolean filterWaterFlag,
			Boolean filterAirFlag, String brandGear, String brandBattery,
			String clockLecture, String serviceCorrective, String observations,
			Integer epServiceSurveyId, Boolean levelOilFlag,
			Boolean levelWaterFlag, Integer levelBattery, Boolean tubeLeak,
			String batteryCap, String batterySulfate, Integer levelOil,
			String heatEngine, String hoseOil, String hoseWater,
			String tubeValve, String stripBlades, Integer epServiceWorkBasicId,
			Boolean washEngine, Boolean washRadiator, Boolean cleanWorkArea,
			Boolean conectionCheck, Boolean cleanTransfer,
			Boolean cleanCardControl, Boolean checkConectionControl,
			Boolean checkWinding, Boolean batteryTests, Boolean checkCharger,
			Boolean checkPaint, Boolean cleanGenerator,
			Integer epServiceDynamicTestId, Double vacuumFrequency,
			Double chargeFrequency, Double bootTryouts, Double vacuumVoltage,
			Double chargeVoltage, Double qualitySmoke, Integer startTime,
			Integer transferTime, Integer stopTime,
			Integer epServiceTestProtectionId, Integer tempSensor,
			Integer oilSensor, Integer voltageSensor, Integer overSpeedSensor,
			Integer oilPreasureSensor, Integer waterLevelSensor,
			Integer epServiceTransferSwitchId, String mechanicalStatus,
			Boolean boardClean, Boolean screwAdjust, Boolean conectionAdjust,
			String systemMotors, String electricInterlock,
			String mechanicalInterlock, Integer capacityAmp,
			Integer epServiceLecturesId, Integer voltageABAN,
			Integer voltageACCN, Integer voltageBCBN, Integer voltageNT,
			Integer currentA, Integer currentB, Integer currentC,
			Integer frequency, Integer oilPreassure, Integer temp,
			Integer epServiceParamsId, String adjsutmentTherm, String current,
			String batteryCurrent, String clockStatus,
			String trasnferTypeProtection, String generatorTypeProtection, String brandPE, String modelPE , String serialPE ) {
		this.epServiceId = epServiceId;
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
		this.transferType = transferType;
		this.modelTransfer = modelTransfer;
		this.modelControl = modelControl;
		this.modelRegVoltage = modelRegVoltage;
		this.modelRegVelocity = modelRegVelocity;
		this.modelCharger = modelCharger;
		this.oilChange = oilChange;
		this.brandMotor = brandMotor;
		this.modelMotor = modelMotor;
		this.serialMotor = serialMotor;
		this.cplMotor = cplMotor;
		this.brandGenerator = brandGenerator;
		this.modelGenerator = modelGenerator;
		this.serialGenerator = serialGenerator;
		this.powerWattGenerator = powerWattGenerator;
		this.tensionGenerator = tensionGenerator;
		this.tuningDate = tuningDate;
		this.tankCapacity = tankCapacity;
		this.pumpFuelModel = pumpFuelModel;
		this.filterFuelFlag = filterFuelFlag;
		this.filterOilFlag = filterOilFlag;
		this.filterWaterFlag = filterWaterFlag;
		this.filterAirFlag = filterAirFlag;
		this.brandGear = brandGear;
		this.brandBattery = brandBattery;
		this.clockLecture = clockLecture;
		this.serviceCorrective = serviceCorrective;
		this.observations = observations;
		this.epServiceSurveyId = epServiceSurveyId;
		this.levelOilFlag = levelOilFlag;
		this.levelWaterFlag = levelWaterFlag;
		this.levelBattery = levelBattery;
		this.tubeLeak = tubeLeak;
		this.batteryCap = batteryCap;
		this.batterySulfate = batterySulfate;
		this.levelOil = levelOil;
		this.heatEngine = heatEngine;
		this.hoseOil = hoseOil;
		this.hoseWater = hoseWater;
		this.tubeValve = tubeValve;
		this.stripBlades = stripBlades;
		this.epServiceWorkBasicId = epServiceWorkBasicId;
		this.washEngine = washEngine;
		this.washRadiator = washRadiator;
		this.cleanWorkArea = cleanWorkArea;
		this.conectionCheck = conectionCheck;
		this.cleanTransfer = cleanTransfer;
		this.cleanCardControl = cleanCardControl;
		this.checkConectionControl = checkConectionControl;
		this.checkWinding = checkWinding;
		this.batteryTests = batteryTests;
		this.checkCharger = checkCharger;
		this.checkPaint = checkPaint;
		this.cleanGenerator = cleanGenerator;
		this.epServiceDynamicTestId = epServiceDynamicTestId;
		this.vacuumFrequency = vacuumFrequency;
		this.chargeFrequency = chargeFrequency;
		this.bootTryouts = bootTryouts;
		this.vacuumVoltage = vacuumVoltage;
		this.chargeVoltage = chargeVoltage;
		this.qualitySmoke = qualitySmoke;
		this.startTime = startTime;
		this.transferTime = transferTime;
		this.stopTime = stopTime;
		this.epServiceTestProtectionId = epServiceTestProtectionId;
		this.tempSensor = tempSensor;
		this.oilSensor = oilSensor;
		this.voltageSensor = voltageSensor;
		this.overSpeedSensor = overSpeedSensor;
		this.oilPreasureSensor = oilPreasureSensor;
		this.waterLevelSensor = waterLevelSensor;
		this.epServiceTransferSwitchId = epServiceTransferSwitchId;
		this.mechanicalStatus = mechanicalStatus;
		this.boardClean = boardClean;
		this.screwAdjust = screwAdjust;
		this.conectionAdjust = conectionAdjust;
		this.systemMotors = systemMotors;
		this.electricInterlock = electricInterlock;
		this.mechanicalInterlock = mechanicalInterlock;
		this.capacityAmp = capacityAmp;
		this.epServiceLecturesId = epServiceLecturesId;
		this.voltageABAN = voltageABAN;
		this.voltageACCN = voltageACCN;
		this.voltageBCBN = voltageBCBN;
		this.voltageNT = voltageNT;
		this.currentA = currentA;
		this.currentB = currentB;
		this.currentC = currentC;
		this.frequency = frequency;
		this.oilPreassure = oilPreassure;
		this.temp = temp;
		this.epServiceParamsId = epServiceParamsId;
		this.adjsutmentTherm = adjsutmentTherm;
		this.current = current;
		this.batteryCurrent = batteryCurrent;
		this.clockStatus = clockStatus;
		this.trasnferTypeProtection = trasnferTypeProtection;
		this.generatorTypeProtection = generatorTypeProtection;
		this.brandPE = brandPE;
		this.modelPE = modelPE;
		this.serialPE = serialPE;
		this.brandPE = brandPE;
		this.modelPE = modelPE;
		this.serialPE = serialPE;
	}
	
	private Integer epServiceId;
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
	
	private String brandPE;
	private String modelPE;
	private String serialPE;
	private String transferType;
	private String modelTransfer;
	private String modelControl;
	private String modelRegVoltage;
	private String modelRegVelocity;
	private String modelCharger;
	private Date oilChange;
	private String brandMotor;
	private String modelMotor;
	private String serialMotor;
	private String cplMotor;
	private String brandGenerator;
	private String modelGenerator;
	private String serialGenerator;
	private Integer powerWattGenerator;
	private Integer tensionGenerator;
	private Date tuningDate;
	private Integer tankCapacity;
	private String pumpFuelModel;
	private Boolean filterFuelFlag;
	private Boolean filterOilFlag;
	private Boolean filterWaterFlag;
	private Boolean filterAirFlag;
	private String brandGear;
	private String brandBattery;
	private String clockLecture;
	private String serviceCorrective;
	private String observations;
	
	private Integer epServiceSurveyId;
	private Boolean levelOilFlag;
	private Boolean levelWaterFlag;
	private Integer levelBattery;
	private Boolean tubeLeak;
	private String batteryCap;
	private String batterySulfate;
	private Integer levelOil;
	private String heatEngine;
	private String hoseOil;
	private String hoseWater;
	private String tubeValve;
	private String stripBlades;

	private Integer epServiceWorkBasicId;
	private Boolean washEngine;
	private Boolean washRadiator;
	private Boolean cleanWorkArea;
	private Boolean conectionCheck;
	private Boolean cleanTransfer;
	private Boolean cleanCardControl;
	private Boolean checkConectionControl;
	private Boolean checkWinding;
	private Boolean batteryTests;
	private Boolean checkCharger;
	private Boolean checkPaint;
	private Boolean cleanGenerator;

	private Integer epServiceDynamicTestId;
	private Double vacuumFrequency;
	private Double chargeFrequency;
	private Double bootTryouts;
	private Double vacuumVoltage;
	private Double chargeVoltage;
	private Double qualitySmoke;
	private Integer startTime;
	private Integer transferTime;
	private Integer stopTime;

	private Integer epServiceTestProtectionId;
	private Integer tempSensor;
	private Integer oilSensor;
	private Integer voltageSensor;
	private Integer overSpeedSensor;
	private Integer oilPreasureSensor;
	private Integer waterLevelSensor;

	private Integer epServiceTransferSwitchId;
	private String mechanicalStatus;
	private Boolean boardClean;
	private Boolean screwAdjust;
	private Boolean conectionAdjust;
	private String systemMotors;
	private String electricInterlock;
	private String mechanicalInterlock;
	private Integer capacityAmp;

	private Integer epServiceLecturesId;
	private Integer voltageABAN;
	private Integer voltageACCN;
	private Integer voltageBCBN;
	private Integer voltageNT;
	private Integer currentA;
	private Integer currentB;
	private Integer currentC;
	private Integer frequency;
	private Integer oilPreassure;
	private Integer temp;

	private Integer epServiceParamsId;
	private String adjsutmentTherm;
	private String current;
	private String batteryCurrent;
	private String clockStatus;
	private String trasnferTypeProtection;
	private String generatorTypeProtection;
	
	public Integer getEpServiceId() {
		return epServiceId;
	}
	public void setEpServiceId(Integer epServiceId) {
		this.epServiceId = epServiceId;
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
	public String getTransferType() {
		return transferType;
	}
	public void setTransferType(String transferType) {
		this.transferType = transferType;
	}
	public String getModelTransfer() {
		return modelTransfer;
	}
	public void setModelTransfer(String modelTransfer) {
		this.modelTransfer = modelTransfer;
	}
	public String getModelControl() {
		return modelControl;
	}
	public void setModelControl(String modelControl) {
		this.modelControl = modelControl;
	}
	public String getModelRegVoltage() {
		return modelRegVoltage;
	}
	public void setModelRegVoltage(String modelRegVoltage) {
		this.modelRegVoltage = modelRegVoltage;
	}
	public String getModelRegVelocity() {
		return modelRegVelocity;
	}
	public void setModelRegVelocity(String modelRegVelocity) {
		this.modelRegVelocity = modelRegVelocity;
	}
	public String getModelCharger() {
		return modelCharger;
	}
	public void setModelCharger(String modelCharger) {
		this.modelCharger = modelCharger;
	}
	public Date getOilChange() {
		return oilChange;
	}
	public void setOilChange(Date oilChange) {
		this.oilChange = oilChange;
	}
	public String getBrandMotor() {
		return brandMotor;
	}
	public void setBrandMotor(String brandMotor) {
		this.brandMotor = brandMotor;
	}
	public String getModelMotor() {
		return modelMotor;
	}
	public void setModelMotor(String modelMotor) {
		this.modelMotor = modelMotor;
	}
	public String getSerialMotor() {
		return serialMotor;
	}
	public void setSerialMotor(String serialMotor) {
		this.serialMotor = serialMotor;
	}
	public String getCplMotor() {
		return cplMotor;
	}
	public void setCplMotor(String cplMotor) {
		this.cplMotor = cplMotor;
	}
	public String getBrandGenerator() {
		return brandGenerator;
	}
	public void setBrandGenerator(String brandGenerator) {
		this.brandGenerator = brandGenerator;
	}
	public String getModelGenerator() {
		return modelGenerator;
	}
	public void setModelGenerator(String modelGenerator) {
		this.modelGenerator = modelGenerator;
	}
	public String getSerialGenerator() {
		return serialGenerator;
	}
	public void setSerialGenerator(String serialGenerator) {
		this.serialGenerator = serialGenerator;
	}
	public Integer getPowerWattGenerator() {
		return powerWattGenerator;
	}
	public void setPowerWattGenerator(Integer powerWattGenerator) {
		this.powerWattGenerator = powerWattGenerator;
	}
	public Integer getTensionGenerator() {
		return tensionGenerator;
	}
	public void setTensionGenerator(Integer tensionGenerator) {
		this.tensionGenerator = tensionGenerator;
	}
	public Date getTuningDate() {
		return tuningDate;
	}
	public void setTuningDate(Date tuningDate) {
		this.tuningDate = tuningDate;
	}
	public Integer getTankCapacity() {
		return tankCapacity;
	}
	public void setTankCapacity(Integer tankCapacity) {
		this.tankCapacity = tankCapacity;
	}
	public String getPumpFuelModel() {
		return pumpFuelModel;
	}
	public void setPumpFuelModel(String pumpFuelModel) {
		this.pumpFuelModel = pumpFuelModel;
	}
	public Boolean getFilterFuelFlag() {
		return filterFuelFlag;
	}
	public void setFilterFuelFlag(Boolean filterFuelFlag) {
		this.filterFuelFlag = filterFuelFlag;
	}
	public Boolean getFilterOilFlag() {
		return filterOilFlag;
	}
	public void setFilterOilFlag(Boolean filterOilFlag) {
		this.filterOilFlag = filterOilFlag;
	}
	public Boolean getFilterWaterFlag() {
		return filterWaterFlag;
	}
	public void setFilterWaterFlag(Boolean filterWaterFlag) {
		this.filterWaterFlag = filterWaterFlag;
	}
	public Boolean getFilterAirFlag() {
		return filterAirFlag;
	}
	public void setFilterAirFlag(Boolean filterAirFlag) {
		this.filterAirFlag = filterAirFlag;
	}
	public String getBrandGear() {
		return brandGear;
	}
	public void setBrandGear(String brandGear) {
		this.brandGear = brandGear;
	}
	public String getBrandBattery() {
		return brandBattery;
	}
	public void setBrandBattery(String brandBattery) {
		this.brandBattery = brandBattery;
	}
	public String getClockLecture() {
		return clockLecture;
	}
	public void setClockLecture(String clockLecture) {
		this.clockLecture = clockLecture;
	}
	public String getServiceCorrective() {
		return serviceCorrective;
	}
	public void setServiceCorrective(String serviceCorrective) {
		this.serviceCorrective = serviceCorrective;
	}
	public String getObservations() {
		return observations;
	}
	public void setObservations(String observations) {
		this.observations = observations;
	}
	public Integer getEpServiceSurveyId() {
		return epServiceSurveyId;
	}
	public void setEpServiceSurveyId(Integer epServiceSurveyId) {
		this.epServiceSurveyId = epServiceSurveyId;
	}
	public Boolean getLevelOilFlag() {
		return levelOilFlag;
	}
	public void setLevelOilFlag(Boolean levelOilFlag) {
		this.levelOilFlag = levelOilFlag;
	}
	public Boolean getLevelWaterFlag() {
		return levelWaterFlag;
	}
	public void setLevelWaterFlag(Boolean levelWaterFlag) {
		this.levelWaterFlag = levelWaterFlag;
	}
	public Integer getLevelBattery() {
		return levelBattery;
	}
	public void setLevelBattery(Integer levelBattery) {
		this.levelBattery = levelBattery;
	}
	public Boolean getTubeLeak() {
		return tubeLeak;
	}
	public void setTubeLeak(Boolean tubeLeak) {
		this.tubeLeak = tubeLeak;
	}
	public String getBatteryCap() {
		return batteryCap;
	}
	public void setBatteryCap(String batteryCap) {
		this.batteryCap = batteryCap;
	}
	public String getBatterySulfate() {
		return batterySulfate;
	}
	public void setBatterySulfate(String batterySulfate) {
		this.batterySulfate = batterySulfate;
	}
	public Integer getLevelOil() {
		return levelOil;
	}
	public void setLevelOil(Integer levelOil) {
		this.levelOil = levelOil;
	}
	public String getHeatEngine() {
		return heatEngine;
	}
	public void setHeatEngine(String heatEngine) {
		this.heatEngine = heatEngine;
	}
	public String getHoseOil() {
		return hoseOil;
	}
	public void setHoseOil(String hoseOil) {
		this.hoseOil = hoseOil;
	}
	public String getHoseWater() {
		return hoseWater;
	}
	public void setHoseWater(String hoseWater) {
		this.hoseWater = hoseWater;
	}
	public String getTubeValve() {
		return tubeValve;
	}
	public void setTubeValve(String tubeValve) {
		this.tubeValve = tubeValve;
	}
	public String getStripBlades() {
		return stripBlades;
	}
	public void setStripBlades(String stripBlades) {
		this.stripBlades = stripBlades;
	}
	public Integer getEpServiceWorkBasicId() {
		return epServiceWorkBasicId;
	}
	public void setEpServiceWorkBasicId(Integer epServiceWorkBasicId) {
		this.epServiceWorkBasicId = epServiceWorkBasicId;
	}
	public Boolean getWashEngine() {
		return washEngine;
	}
	public void setWashEngine(Boolean washEngine) {
		this.washEngine = washEngine;
	}
	public Boolean getWashRadiator() {
		return washRadiator;
	}
	public void setWashRadiator(Boolean washRadiator) {
		this.washRadiator = washRadiator;
	}
	public Boolean getCleanWorkArea() {
		return cleanWorkArea;
	}
	public void setCleanWorkArea(Boolean cleanWorkArea) {
		this.cleanWorkArea = cleanWorkArea;
	}
	public Boolean getConectionCheck() {
		return conectionCheck;
	}
	public void setConectionCheck(Boolean conectionCheck) {
		this.conectionCheck = conectionCheck;
	}
	public Boolean getCleanTransfer() {
		return cleanTransfer;
	}
	public void setCleanTransfer(Boolean cleanTransfer) {
		this.cleanTransfer = cleanTransfer;
	}
	public Boolean getCleanCardControl() {
		return cleanCardControl;
	}
	public void setCleanCardControl(Boolean cleanCardControl) {
		this.cleanCardControl = cleanCardControl;
	}
	public Boolean getCheckConectionControl() {
		return checkConectionControl;
	}
	public void setCheckConectionControl(Boolean checkConectionControl) {
		this.checkConectionControl = checkConectionControl;
	}
	public Boolean getCheckWinding() {
		return checkWinding;
	}
	public void setCheckWinding(Boolean checkWinding) {
		this.checkWinding = checkWinding;
	}
	public Boolean getBatteryTests() {
		return batteryTests;
	}
	public void setBatteryTests(Boolean batteryTests) {
		this.batteryTests = batteryTests;
	}
	public Boolean getCheckCharger() {
		return checkCharger;
	}
	public void setCheckCharger(Boolean checkCharger) {
		this.checkCharger = checkCharger;
	}
	public Boolean getCheckPaint() {
		return checkPaint;
	}
	public void setCheckPaint(Boolean checkPaint) {
		this.checkPaint = checkPaint;
	}
	public Boolean getCleanGenerator() {
		return cleanGenerator;
	}
	public void setCleanGenerator(Boolean cleanGenerator) {
		this.cleanGenerator = cleanGenerator;
	}
	public Integer getEpServiceDynamicTestId() {
		return epServiceDynamicTestId;
	}
	public void setEpServiceDynamicTestId(Integer epServiceDynamicTestId) {
		this.epServiceDynamicTestId = epServiceDynamicTestId;
	}
	public Double getVacuumFrequency() {
		return vacuumFrequency;
	}
	public void setVacuumFrequency(Double vacuumFrequency) {
		this.vacuumFrequency = vacuumFrequency;
	}
	public Double getChargeFrequency() {
		return chargeFrequency;
	}
	public void setChargeFrequency(Double chargeFrequency) {
		this.chargeFrequency = chargeFrequency;
	}
	public Double getBootTryouts() {
		return bootTryouts;
	}
	public void setBootTryouts(Double bootTryouts) {
		this.bootTryouts = bootTryouts;
	}
	public Double getVacuumVoltage() {
		return vacuumVoltage;
	}
	public void setVacuumVoltage(Double vacuumVoltage) {
		this.vacuumVoltage = vacuumVoltage;
	}
	public Double getChargeVoltage() {
		return chargeVoltage;
	}
	public void setChargeVoltage(Double chargeVoltage) {
		this.chargeVoltage = chargeVoltage;
	}
	public Double getQualitySmoke() {
		return qualitySmoke;
	}
	public void setQualitySmoke(Double qualitySmoke) {
		this.qualitySmoke = qualitySmoke;
	}
	public Integer getStartTime() {
		return startTime;
	}
	public void setStartTime(Integer startTime) {
		this.startTime = startTime;
	}
	public Integer getTransferTime() {
		return transferTime;
	}
	public void setTransferTime(Integer transferTime) {
		this.transferTime = transferTime;
	}
	public Integer getStopTime() {
		return stopTime;
	}
	public void setStopTime(Integer stopTime) {
		this.stopTime = stopTime;
	}
	public Integer getEpServiceTestProtectionId() {
		return epServiceTestProtectionId;
	}
	public void setEpServiceTestProtectionId(Integer epServiceTestProtectionId) {
		this.epServiceTestProtectionId = epServiceTestProtectionId;
	}
	public Integer getTempSensor() {
		return tempSensor;
	}
	public void setTempSensor(Integer tempSensor) {
		this.tempSensor = tempSensor;
	}
	public Integer getOilSensor() {
		return oilSensor;
	}
	public void setOilSensor(Integer oilSensor) {
		this.oilSensor = oilSensor;
	}
	public Integer getVoltageSensor() {
		return voltageSensor;
	}
	public void setVoltageSensor(Integer voltageSensor) {
		this.voltageSensor = voltageSensor;
	}
	public Integer getOverSpeedSensor() {
		return overSpeedSensor;
	}
	public void setOverSpeedSensor(Integer overSpeedSensor) {
		this.overSpeedSensor = overSpeedSensor;
	}
	public Integer getOilPreasureSensor() {
		return oilPreasureSensor;
	}
	public void setOilPreasureSensor(Integer oilPreasureSensor) {
		this.oilPreasureSensor = oilPreasureSensor;
	}
	public Integer getWaterLevelSensor() {
		return waterLevelSensor;
	}
	public void setWaterLevelSensor(Integer waterLevelSensor) {
		this.waterLevelSensor = waterLevelSensor;
	}
	public Integer getEpServiceTransferSwitchId() {
		return epServiceTransferSwitchId;
	}
	public void setEpServiceTransferSwitchId(Integer epServiceTransferSwitchId) {
		this.epServiceTransferSwitchId = epServiceTransferSwitchId;
	}
	public String getMechanicalStatus() {
		return mechanicalStatus;
	}
	public void setMechanicalStatus(String mechanicalStatus) {
		this.mechanicalStatus = mechanicalStatus;
	}
	public Boolean getBoardClean() {
		return boardClean;
	}
	public void setBoardClean(Boolean boardClean) {
		this.boardClean = boardClean;
	}
	public Boolean getScrewAdjust() {
		return screwAdjust;
	}
	public void setScrewAdjust(Boolean screwAdjust) {
		this.screwAdjust = screwAdjust;
	}
	public Boolean getConectionAdjust() {
		return conectionAdjust;
	}
	public void setConectionAdjust(Boolean conectionAdjust) {
		this.conectionAdjust = conectionAdjust;
	}
	public String getSystemMotors() {
		return systemMotors;
	}
	public void setSystemMotors(String systemMotors) {
		this.systemMotors = systemMotors;
	}
	public String getElectricInterlock() {
		return electricInterlock;
	}
	public void setElectricInterlock(String electricInterlock) {
		this.electricInterlock = electricInterlock;
	}
	public String getMechanicalInterlock() {
		return mechanicalInterlock;
	}
	public void setMechanicalInterlock(String mechanicalInterlock) {
		this.mechanicalInterlock = mechanicalInterlock;
	}
	public Integer getCapacityAmp() {
		return capacityAmp;
	}
	public void setCapacityAmp(Integer capacityAmp) {
		this.capacityAmp = capacityAmp;
	}
	public Integer getEpServiceLecturesId() {
		return epServiceLecturesId;
	}
	public void setEpServiceLecturesId(Integer epServiceLecturesId) {
		this.epServiceLecturesId = epServiceLecturesId;
	}
	public Integer getVoltageABAN() {
		return voltageABAN;
	}
	public void setVoltageABAN(Integer voltageABAN) {
		this.voltageABAN = voltageABAN;
	}
	public Integer getVoltageACCN() {
		return voltageACCN;
	}
	public void setVoltageACCN(Integer voltageACCN) {
		this.voltageACCN = voltageACCN;
	}
	public Integer getVoltageBCBN() {
		return voltageBCBN;
	}
	public void setVoltageBCBN(Integer voltageBCBN) {
		this.voltageBCBN = voltageBCBN;
	}
	public Integer getVoltageNT() {
		return voltageNT;
	}
	public void setVoltageNT(Integer voltageNT) {
		this.voltageNT = voltageNT;
	}
	public Integer getCurrentA() {
		return currentA;
	}
	public void setCurrentA(Integer currentA) {
		this.currentA = currentA;
	}
	public Integer getCurrentB() {
		return currentB;
	}
	public void setCurrentB(Integer currentB) {
		this.currentB = currentB;
	}
	public Integer getCurrentC() {
		return currentC;
	}
	public void setCurrentC(Integer currentC) {
		this.currentC = currentC;
	}
	public Integer getFrequency() {
		return frequency;
	}
	public void setFrequency(Integer frequency) {
		this.frequency = frequency;
	}
	public Integer getOilPreassure() {
		return oilPreassure;
	}
	public void setOilPreassure(Integer oilPreassure) {
		this.oilPreassure = oilPreassure;
	}
	public Integer getTemp() {
		return temp;
	}
	public void setTemp(Integer temp) {
		this.temp = temp;
	}
	public Integer getEpServiceParamsId() {
		return epServiceParamsId;
	}
	public void setEpServiceParamsId(Integer epServiceParamsId) {
		this.epServiceParamsId = epServiceParamsId;
	}
	public String getAdjsutmentTherm() {
		return adjsutmentTherm;
	}
	public void setAdjsutmentTherm(String adjsutmentTherm) {
		this.adjsutmentTherm = adjsutmentTherm;
	}
	public String getCurrent() {
		return current;
	}
	public void setCurrent(String current) {
		this.current = current;
	}
	public String getBatteryCurrent() {
		return batteryCurrent;
	}
	public void setBatteryCurrent(String batteryCurrent) {
		this.batteryCurrent = batteryCurrent;
	}
	public String getClockStatus() {
		return clockStatus;
	}
	public void setClockStatus(String clockStatus) {
		this.clockStatus = clockStatus;
	}
	public String getTrasnferTypeProtection() {
		return trasnferTypeProtection;
	}
	public void setTrasnferTypeProtection(String trasnferTypeProtection) {
		this.trasnferTypeProtection = trasnferTypeProtection;
	}
	public String getGeneratorTypeProtection() {
		return generatorTypeProtection;
	}
	public void setGeneratorTypeProtection(String generatorTypeProtection) {
		this.generatorTypeProtection = generatorTypeProtection;
	}

	public String getBrandPE() {
		return brandPE;
	}

	public void setBrandPE(String brandPE) {
		this.brandPE = brandPE;
	}

	public String getModelPE() {
		return modelPE;
	}

	public void setModelPE(String modelPE) {
		this.modelPE = modelPE;
	}

	public String getSerialPE() {
		return serialPE;
	}

	public void setSerialPE(String serialPE) {
		this.serialPE = serialPE;
	}
	
}
