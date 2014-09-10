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
	
	
	
	public EmergencyPlantServiceDTO(EmergencyPlantServicePolicyDTO emergencyPlantService)
	{
		this.serviceOrderId = emergencyPlantService.getServiceOrderId();
		this.epServiceId = emergencyPlantService.getEpServiceId();
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
		
		this.epServiceSurveyId = emergencyPlantService.getEpServiceSurveyId();
		this.levelOilFlag =  emergencyPlantService.getLevelOilFlag();
		this.levelWaterFlag =  emergencyPlantService.getLevelWaterFlag();
		this.levelBattery =  emergencyPlantService.getLevelBattery();
		this.tubeLeak =  emergencyPlantService.getTubeLeak();
		this.batteryCap =  emergencyPlantService.getBatteryCap();
		this.batterySulfate =  emergencyPlantService.getBatterySulfate();
		this.levelOil =  emergencyPlantService.getLevelOil();
		this.heatEngine =  emergencyPlantService.getHeatEngine();
		this.hoseOil =  emergencyPlantService.getHoseOil();
		this.hoseWater =  emergencyPlantService.getHoseWater();
		this.tubeValve =  emergencyPlantService.getTubeValve();
		this.stripBlades =  emergencyPlantService.getStripBlades();
		
		this.epServiceWorkBasicId = emergencyPlantService.getEpServiceWorkBasicId();
		this.washEngine = emergencyPlantService.getWashEngine();
		this.washRadiator = emergencyPlantService.getWashRadiator();
		this.cleanWorkArea = emergencyPlantService.getCleanWorkArea();
		this.conectionCheck = emergencyPlantService.getConectionCheck();
		this.cleanTransfer = emergencyPlantService.getCleanTransfer();
		this.cleanCardControl = emergencyPlantService.getCleanCardControl();
		this.checkConectionControl = emergencyPlantService.getCheckConectionControl();
		this.checkWinding = emergencyPlantService.getCheckWinding();
		this.batteryTests = emergencyPlantService.getBatteryTests();
		this.checkCharger = emergencyPlantService.getCheckCharger();
		this.checkPaint = emergencyPlantService.getCheckPaint();
		this.cleanGenerator = emergencyPlantService.getCleanGenerator();
		
		this.epServiceDynamicTestId = emergencyPlantService.getEpServiceDynamicTestId();
		this.vacuumFrequency = emergencyPlantService.getVacuumFrequency();
		this.chargeFrequency = emergencyPlantService.getChargeFrequency();
		this.bootTryouts = emergencyPlantService.getBootTryouts();
		this.vacuumVoltage = emergencyPlantService.getVacuumVoltage();
		this.chargeVoltage = emergencyPlantService.getChargeVoltage();
		this.qualitySmoke = emergencyPlantService.getQualitySmoke();
		this.startTime = emergencyPlantService.getStartTime();
		this.transferTime = emergencyPlantService.getTransferTime();
		this.stopTime = emergencyPlantService.getStopTime();
		
		this.epServiceTestProtectionId = emergencyPlantService.getEpServiceTestProtectionId();
		this.tempSensor = emergencyPlantService.getTempSensor();
		this.oilSensor = emergencyPlantService.getOilSensor();
		this.voltageSensor = emergencyPlantService.getVoltageSensor();
		this.overSpeedSensor = emergencyPlantService.getOverSpeedSensor();
		this.oilPreasureSensor = emergencyPlantService.getOilPreasureSensor();
		this.waterLevelSensor = emergencyPlantService.getWaterLevelSensor();
		
		this.epServiceTransferSwitchId = emergencyPlantService.getEpServiceTransferSwitchId();
		this.mechanicalStatus = emergencyPlantService.getMechanicalStatus();
		this.boardClean = emergencyPlantService.getBoardClean();
		this.lampTest = emergencyPlantService.getLampTest();
		this.screwAdjust = emergencyPlantService.getScrewAdjust();
		this.conectionAdjust = emergencyPlantService.getConectionAdjust();
		this.systemMotors = emergencyPlantService.getSystemMotors();
		this.electricInterlock = emergencyPlantService.getElectricInterlock();
		this.mechanicalInterlock = emergencyPlantService.getMechanicalInterlock();
		this.capacityAmp = emergencyPlantService.getCapacityAmp();
		
		this.epServiceLecturesId = emergencyPlantService.getEpServiceLecturesId();
		this.voltageABAN = emergencyPlantService.getVoltageABAN();
		this.voltageACCN = emergencyPlantService.getVoltageACCN();
		this.voltageBCBN = emergencyPlantService.getVoltageBCBN();
		this.voltageNT = emergencyPlantService.getVoltageNT();
		this.currentA = emergencyPlantService.getCurrentA();
		this.currentB = emergencyPlantService.getCurrentB();
		this.currentC = emergencyPlantService.getCurrentC();
		this.frequency = emergencyPlantService.getFrequency();
		this.oilPreassure = emergencyPlantService.getOilPreassure();
		this.temp = emergencyPlantService.getTemp();
		
		this.epServiceParamsId = emergencyPlantService.getEpServiceParamsId();
		this.adjsutmentTherm = emergencyPlantService.getAdjsutmentTherm();
		this.current = emergencyPlantService.getCurrent();
		this.batteryCurrent = emergencyPlantService.getBatteryCurrent();
		this.clockStatus = emergencyPlantService.getClockStatus();
		this.trasnferTypeProtection = emergencyPlantService.getTrasnferTypeProtection();
		this.generatorTypeProtection = emergencyPlantService.getGeneratorTypeProtection();
	}
	
	
	
	
	public EmergencyPlantServiceDTO( EmergencyPlantService emergencyPlantService, EmergencyPlantServiceSurvey emergencyPlantServiceSurvey, EmergencyPlantServiceWorkBasic emergencyPlantServiceWorkBasic, 
									EmergencyPlantServiceDynamicTest emergencyPlantServiceDynamicTest, EmergencyPlantServiceTestProtection emergencyPlantServiceTestProtection,
									EmergencyPlantServiceTransferSwitch emergencyPlantServiceTransferSwitch, EmergencyPlantServiceLectures emergencyPlantServiceLectures,
									EmergencyPlantServiceParams emergencyPlantServiceParams)
	{
		this.epServiceId = emergencyPlantService.getEpServiceId();
		this.serviceOrderId = emergencyPlantService.getServiceOrderId();
		
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
		this.lampTest = emergencyPlantServiceTransferSwitch.getLampTest();
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
			String transferType, String modelTransfer, String modelControl,
			String modelRegVoltage, String modelRegVelocity,
			String modelCharger, Date oilChange, String brandMotor,
			String modelMotor, String serialMotor, String cplMotor,
			String brandGenerator, String modelGenerator,
			String serialGenerator, String powerWattGenerator,
			String tensionGenerator, Date tuningDate, String tankCapacity,
			String pumpFuelModel, Integer filterFuelFlag,
			Integer filterOilFlag, Integer filterWaterFlag,
			Integer filterAirFlag, String brandGear, String brandBattery,
			String clockLecture, Date serviceCorrective, String observations,
			Integer epServiceSurveyId, Integer levelOilFlag,
			Integer levelWaterFlag, String levelBattery, Integer tubeLeak,
			String batteryCap, String batterySulfate, String levelOil,
			String heatEngine, String hoseOil, String hoseWater,
			String tubeValve, String stripBlades, Integer epServiceWorkBasicId,
			Integer washEngine, Integer washRadiator, Integer cleanWorkArea,
			Integer conectionCheck, Integer cleanTransfer,
			Integer cleanCardControl, Integer checkConectionControl,
			Integer checkWinding, Integer batteryTests, Integer checkCharger,
			Integer checkPaint, Integer cleanGenerator,
			Integer epServiceDynamicTestId, String vacuumFrequency,
			String chargeFrequency, String bootTryouts, String vacuumVoltage,
			String chargeVoltage, String qualitySmoke, String startTime,
			String transferTime, String stopTime,
			Integer epServiceTestProtectionId, String tempSensor,
			String oilSensor, String voltageSensor, String overSpeedSensor,
			String oilPreasureSensor, String waterLevelSensor,
			Integer epServiceTransferSwitchId, String mechanicalStatus,
			Integer boardClean, Integer screwAdjust, Integer conectionAdjust,
			String systemMotors, String electricInterlock,
			String mechanicalInterlock, String capacityAmp,
			Integer epServiceLecturesId, String voltageABAN,
			String voltageACCN, String voltageBCBN, String voltageNT,
			String currentA, String currentB, String currentC,
			String frequency, String oilPreassure, String temp,
			Integer epServiceParamsId, String adjsutmentTherm, String current,
			String batteryCurrent, String clockStatus,
			String trasnferTypeProtection, String generatorTypeProtection, String brandPE, String modelPE , String serialPE , Integer lampTest) {
		this.epServiceId = epServiceId;
		this.serviceOrderId = serviceOrderId;
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
		this.lampTest =lampTest;
	}
	
	private Integer epServiceId;
	private Integer serviceOrderId;

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
	private String powerWattGenerator;
	private String tensionGenerator;
	private Date tuningDate;
	private String tankCapacity;
	private String pumpFuelModel;
	private Integer filterFuelFlag;
	private Integer filterOilFlag;
	private Integer filterWaterFlag;
	private Integer filterAirFlag;
	private String brandGear;
	private String brandBattery;
	private String clockLecture;
	private Date serviceCorrective;
	private String observations;
	
	private Integer epServiceSurveyId;
	private Integer levelOilFlag;
	private Integer levelWaterFlag;
	private String levelBattery;
	private Integer tubeLeak;
	private String batteryCap;
	private String batterySulfate;
	private String levelOil;
	private String heatEngine;
	private String hoseOil;
	private String hoseWater;
	private String tubeValve;
	private String stripBlades;

	private Integer epServiceWorkBasicId;
	private Integer washEngine;
	private Integer washRadiator;
	private Integer cleanWorkArea;
	private Integer conectionCheck;
	private Integer cleanTransfer;
	private Integer cleanCardControl;
	private Integer checkConectionControl;
	private Integer checkWinding;
	private Integer batteryTests;
	private Integer checkCharger;
	private Integer checkPaint;
	private Integer cleanGenerator;

	private Integer epServiceDynamicTestId;
	private String vacuumFrequency;
	private String chargeFrequency;
	private String bootTryouts;
	private String vacuumVoltage;
	private String chargeVoltage;
	private String qualitySmoke;
	private String startTime;
	private String transferTime;
	private String stopTime;

	private Integer epServiceTestProtectionId;
	private String tempSensor;
	private String oilSensor;
	private String voltageSensor;
	private String overSpeedSensor;
	private String oilPreasureSensor;
	private String waterLevelSensor;

	private Integer epServiceTransferSwitchId;
	private String mechanicalStatus;
	private Integer boardClean;
	private Integer lampTest;
	private Integer screwAdjust;
	private Integer conectionAdjust;
	private String systemMotors;
	private String electricInterlock;
	private String mechanicalInterlock;
	private String capacityAmp;

	private Integer epServiceLecturesId;
	private String voltageABAN;
	private String voltageACCN;
	private String voltageBCBN;
	private String voltageNT;
	private String currentA;
	private String currentB;
	private String currentC;
	private String frequency;
	private String oilPreassure;
	private String temp;

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



	public String getPowerWattGenerator() {
		return powerWattGenerator;
	}



	public void setPowerWattGenerator(String powerWattGenerator) {
		this.powerWattGenerator = powerWattGenerator;
	}



	public String getTensionGenerator() {
		return tensionGenerator;
	}



	public void setTensionGenerator(String tensionGenerator) {
		this.tensionGenerator = tensionGenerator;
	}



	public Date getTuningDate() {
		return tuningDate;
	}



	public void setTuningDate(Date tuningDate) {
		this.tuningDate = tuningDate;
	}



	public String getTankCapacity() {
		return tankCapacity;
	}



	public void setTankCapacity(String tankCapacity) {
		this.tankCapacity = tankCapacity;
	}



	public String getPumpFuelModel() {
		return pumpFuelModel;
	}



	public void setPumpFuelModel(String pumpFuelModel) {
		this.pumpFuelModel = pumpFuelModel;
	}



	public Integer getFilterFuelFlag() {
		return filterFuelFlag;
	}



	public void setFilterFuelFlag(Integer filterFuelFlag) {
		this.filterFuelFlag = filterFuelFlag;
	}



	public Integer getFilterOilFlag() {
		return filterOilFlag;
	}



	public void setFilterOilFlag(Integer filterOilFlag) {
		this.filterOilFlag = filterOilFlag;
	}



	public Integer getFilterWaterFlag() {
		return filterWaterFlag;
	}



	public void setFilterWaterFlag(Integer filterWaterFlag) {
		this.filterWaterFlag = filterWaterFlag;
	}



	public Integer getFilterAirFlag() {
		return filterAirFlag;
	}



	public void setFilterAirFlag(Integer filterAirFlag) {
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



	public Date getServiceCorrective() {
		return serviceCorrective;
	}



	public void setServiceCorrective(Date serviceCorrective) {
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



	public Integer getLevelOilFlag() {
		return levelOilFlag;
	}



	public void setLevelOilFlag(Integer levelOilFlag) {
		this.levelOilFlag = levelOilFlag;
	}



	public Integer getLevelWaterFlag() {
		return levelWaterFlag;
	}



	public void setLevelWaterFlag(Integer levelWaterFlag) {
		this.levelWaterFlag = levelWaterFlag;
	}



	public String getLevelBattery() {
		return levelBattery;
	}



	public void setLevelBattery(String levelBattery) {
		this.levelBattery = levelBattery;
	}



	public Integer getTubeLeak() {
		return tubeLeak;
	}



	public void setTubeLeak(Integer tubeLeak) {
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



	public String getLevelOil() {
		return levelOil;
	}



	public void setLevelOil(String levelOil) {
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



	public Integer getWashEngine() {
		return washEngine;
	}



	public void setWashEngine(Integer washEngine) {
		this.washEngine = washEngine;
	}



	public Integer getWashRadiator() {
		return washRadiator;
	}



	public void setWashRadiator(Integer washRadiator) {
		this.washRadiator = washRadiator;
	}



	public Integer getCleanWorkArea() {
		return cleanWorkArea;
	}



	public void setCleanWorkArea(Integer cleanWorkArea) {
		this.cleanWorkArea = cleanWorkArea;
	}



	public Integer getConectionCheck() {
		return conectionCheck;
	}



	public void setConectionCheck(Integer conectionCheck) {
		this.conectionCheck = conectionCheck;
	}



	public Integer getCleanTransfer() {
		return cleanTransfer;
	}



	public void setCleanTransfer(Integer cleanTransfer) {
		this.cleanTransfer = cleanTransfer;
	}



	public Integer getCleanCardControl() {
		return cleanCardControl;
	}



	public void setCleanCardControl(Integer cleanCardControl) {
		this.cleanCardControl = cleanCardControl;
	}



	public Integer getCheckConectionControl() {
		return checkConectionControl;
	}



	public void setCheckConectionControl(Integer checkConectionControl) {
		this.checkConectionControl = checkConectionControl;
	}



	public Integer getCheckWinding() {
		return checkWinding;
	}



	public void setCheckWinding(Integer checkWinding) {
		this.checkWinding = checkWinding;
	}



	public Integer getBatteryTests() {
		return batteryTests;
	}



	public void setBatteryTests(Integer batteryTests) {
		this.batteryTests = batteryTests;
	}



	public Integer getCheckCharger() {
		return checkCharger;
	}



	public void setCheckCharger(Integer checkCharger) {
		this.checkCharger = checkCharger;
	}



	public Integer getCheckPaint() {
		return checkPaint;
	}



	public void setCheckPaint(Integer checkPaint) {
		this.checkPaint = checkPaint;
	}



	public Integer getCleanGenerator() {
		return cleanGenerator;
	}



	public void setCleanGenerator(Integer cleanGenerator) {
		this.cleanGenerator = cleanGenerator;
	}



	public Integer getEpServiceDynamicTestId() {
		return epServiceDynamicTestId;
	}



	public void setEpServiceDynamicTestId(Integer epServiceDynamicTestId) {
		this.epServiceDynamicTestId = epServiceDynamicTestId;
	}



	public String getVacuumFrequency() {
		return vacuumFrequency;
	}



	public void setVacuumFrequency(String vacuumFrequency) {
		this.vacuumFrequency = vacuumFrequency;
	}



	public String getChargeFrequency() {
		return chargeFrequency;
	}



	public void setChargeFrequency(String chargeFrequency) {
		this.chargeFrequency = chargeFrequency;
	}



	public String getBootTryouts() {
		return bootTryouts;
	}



	public void setBootTryouts(String bootTryouts) {
		this.bootTryouts = bootTryouts;
	}



	public String getVacuumVoltage() {
		return vacuumVoltage;
	}



	public void setVacuumVoltage(String vacuumVoltage) {
		this.vacuumVoltage = vacuumVoltage;
	}



	public String getChargeVoltage() {
		return chargeVoltage;
	}



	public void setChargeVoltage(String chargeVoltage) {
		this.chargeVoltage = chargeVoltage;
	}



	public String getQualitySmoke() {
		return qualitySmoke;
	}



	public void setQualitySmoke(String qualitySmoke) {
		this.qualitySmoke = qualitySmoke;
	}



	public String getStartTime() {
		return startTime;
	}



	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}



	public String getTransferTime() {
		return transferTime;
	}



	public void setTransferTime(String transferTime) {
		this.transferTime = transferTime;
	}



	public String getStopTime() {
		return stopTime;
	}



	public void setStopTime(String stopTime) {
		this.stopTime = stopTime;
	}



	public Integer getEpServiceTestProtectionId() {
		return epServiceTestProtectionId;
	}



	public void setEpServiceTestProtectionId(Integer epServiceTestProtectionId) {
		this.epServiceTestProtectionId = epServiceTestProtectionId;
	}



	public String getTempSensor() {
		return tempSensor;
	}



	public void setTempSensor(String tempSensor) {
		this.tempSensor = tempSensor;
	}



	public String getOilSensor() {
		return oilSensor;
	}



	public void setOilSensor(String oilSensor) {
		this.oilSensor = oilSensor;
	}



	public String getVoltageSensor() {
		return voltageSensor;
	}



	public void setVoltageSensor(String voltageSensor) {
		this.voltageSensor = voltageSensor;
	}



	public String getOverSpeedSensor() {
		return overSpeedSensor;
	}



	public void setOverSpeedSensor(String overSpeedSensor) {
		this.overSpeedSensor = overSpeedSensor;
	}



	public String getOilPreasureSensor() {
		return oilPreasureSensor;
	}



	public void setOilPreasureSensor(String oilPreasureSensor) {
		this.oilPreasureSensor = oilPreasureSensor;
	}



	public String getWaterLevelSensor() {
		return waterLevelSensor;
	}



	public void setWaterLevelSensor(String waterLevelSensor) {
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



	public Integer getBoardClean() {
		return boardClean;
	}



	public void setBoardClean(Integer boardClean) {
		this.boardClean = boardClean;
	}



	public Integer getLampTest() {
		return lampTest;
	}



	public void setLampTest(Integer lampTest) {
		this.lampTest = lampTest;
	}



	public Integer getScrewAdjust() {
		return screwAdjust;
	}



	public void setScrewAdjust(Integer screwAdjust) {
		this.screwAdjust = screwAdjust;
	}



	public Integer getConectionAdjust() {
		return conectionAdjust;
	}



	public void setConectionAdjust(Integer conectionAdjust) {
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



	public String getCapacityAmp() {
		return capacityAmp;
	}



	public void setCapacityAmp(String capacityAmp) {
		this.capacityAmp = capacityAmp;
	}



	public Integer getEpServiceLecturesId() {
		return epServiceLecturesId;
	}



	public void setEpServiceLecturesId(Integer epServiceLecturesId) {
		this.epServiceLecturesId = epServiceLecturesId;
	}



	public String getVoltageABAN() {
		return voltageABAN;
	}



	public void setVoltageABAN(String voltageABAN) {
		this.voltageABAN = voltageABAN;
	}



	public String getVoltageACCN() {
		return voltageACCN;
	}



	public void setVoltageACCN(String voltageACCN) {
		this.voltageACCN = voltageACCN;
	}



	public String getVoltageBCBN() {
		return voltageBCBN;
	}



	public void setVoltageBCBN(String voltageBCBN) {
		this.voltageBCBN = voltageBCBN;
	}



	public String getVoltageNT() {
		return voltageNT;
	}



	public void setVoltageNT(String voltageNT) {
		this.voltageNT = voltageNT;
	}



	public String getCurrentA() {
		return currentA;
	}



	public void setCurrentA(String currentA) {
		this.currentA = currentA;
	}



	public String getCurrentB() {
		return currentB;
	}



	public void setCurrentB(String currentB) {
		this.currentB = currentB;
	}



	public String getCurrentC() {
		return currentC;
	}



	public void setCurrentC(String currentC) {
		this.currentC = currentC;
	}



	public String getFrequency() {
		return frequency;
	}



	public void setFrequency(String frequency) {
		this.frequency = frequency;
	}



	public String getOilPreassure() {
		return oilPreassure;
	}



	public void setOilPreassure(String oilPreassure) {
		this.oilPreassure = oilPreassure;
	}



	public String getTemp() {
		return temp;
	}



	public void setTemp(String temp) {
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
	
	
}
