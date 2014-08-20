package com.blackstar.model.dto;

import com.blackstar.model.AirCoService;

public class AirCoServiceDTO {
	
	public AirCoServiceDTO()
	{
		
	}
	
	public AirCoServiceDTO(AirCoServicePolicyDTO  airCoServiceDTO)
	{
		this.aaServiceId = airCoServiceDTO.getAaServiceId();
		this.serviceOrderId = airCoServiceDTO.getServiceOrderId();
		this.evaDescription = airCoServiceDTO.getEvaDescription();
		this.evaValTemp = airCoServiceDTO.getEvaValTemp();
		this.evaValHum = airCoServiceDTO.getEvaValHum();
		this.evaSetpointTemp = airCoServiceDTO.getEvaSetpointTemp();
		this.evaSetpointHum = airCoServiceDTO.getEvaSetpointHum();
		this.evaFlagCalibration = airCoServiceDTO.getEvaFlagCalibration();
		this.evaReviewFilter = airCoServiceDTO.getEvaReviewFilter();
		this.evaReviewStrip = airCoServiceDTO.getEvaReviewStrip();
		this.evaCleanElectricSystem = airCoServiceDTO.getEvaCleanElectricSystem();
		this.evaCleanControlCard = airCoServiceDTO.getEvaCleanControlCard();
		this.evaCleanTray = airCoServiceDTO.getEvaCleanTray();
		this.evaLectrurePreasureHigh = airCoServiceDTO.getEvaLectrurePreasureHigh();
		this.evaLectrurePreasureLow = airCoServiceDTO.getEvaLectrurePreasureLow();
		this.evaLectureTemp = airCoServiceDTO.getEvaLectureTemp();
		this.evaLectureOilColor = airCoServiceDTO.getEvaLectureOilColor();
		this.evaLectureOilLevel = airCoServiceDTO.getEvaLectureOilLevel();
		this.evaLectureCoolerColor = airCoServiceDTO.getEvaLectureCoolerColor();
		this.evaLectureCoolerLevel = airCoServiceDTO.getEvaLectureCoolerLevel();
		this.evaCheckOperatation = airCoServiceDTO.getEvaCheckOperatation();
		this.evaCheckNoise = airCoServiceDTO.getEvaCheckNoise();
		this.evaCheckIsolated = airCoServiceDTO.getEvaCheckIsolated();
		this.evaLectureVoltageGroud = airCoServiceDTO.getEvaLectureVoltageGroud();
		this.evaLectureVoltagePhases = airCoServiceDTO.getEvaLectureVoltagePhases();
		this.evaLectureVoltageControl = airCoServiceDTO.getEvaLectureVoltageControl();
		this.evaLectureCurrentMotor1 = airCoServiceDTO.getEvaLectureCurrentMotor1();
		this.evaLectureCurrentMotor2 = airCoServiceDTO.getEvaLectureCurrentMotor2();
		this.evaLectureCurrentMotor3 = airCoServiceDTO.getEvaLectureCurrentMotor3();
		this.evaLectureCurrentCompressor1 = airCoServiceDTO.getEvaLectureCurrentCompressor1();
		this.evaLectureCurrentCompressor2 = airCoServiceDTO.getEvaLectureCurrentCompressor2();
		this.evaLectureCurrentCompressor3 = airCoServiceDTO.getEvaLectureCurrentCompressor3();
		this.evaLectureCurrentHumidifier1 = airCoServiceDTO.getEvaLectureCurrentHumidifier1();
		this.evaLectureCurrentHumidifier2 = airCoServiceDTO.getEvaLectureCurrentHumidifier2();
		this.evaLectureCurrentHumidifier3 = airCoServiceDTO.getEvaLectureCurrentHumidifier3();
		this.evaLectureCurrentHeater1 = airCoServiceDTO.getEvaLectureCurrentHeater1();
		this.evaLectureCurrentHeater2 = airCoServiceDTO.getEvaLectureCurrentHeater2();
		this.evaLectureCurrentHeater3 = airCoServiceDTO.getEvaLectureCurrentHeater3();
		this.evaCheckFluidSensor = airCoServiceDTO.getEvaCheckFluidSensor();
		this.evaRequirMaintenance = airCoServiceDTO.getEvaRequirMaintenance();
		this.condReview = airCoServiceDTO.getCondReview();
		this.condCleanElectricSystem = airCoServiceDTO.getCondCleanElectricSystem();
		this.condClean = airCoServiceDTO.getCondClean();
		this.condLectureVoltageGroud = airCoServiceDTO.getCondLectureVoltageGroud();
		this.condLectureVoltagePhases = airCoServiceDTO.getCondLectureVoltagePhases();
		this.condLectureVoltageControl = airCoServiceDTO.getCondLectureVoltageControl();
		this.condLectureMotorCurrent = airCoServiceDTO.getCondLectureMotorCurrent();
		this.condReviewThermostat = airCoServiceDTO.getCondReviewThermostat();
		this.condModel = airCoServiceDTO.getCondModel();
		this.condSerialNumber = airCoServiceDTO.getCondSerialNumber();
		this.condBrand = airCoServiceDTO.getCondBrand();
		this.observations = airCoServiceDTO.getObservations();
	}
	
	public AirCoServiceDTO(AirCoService airCoServiceModel )
	{
		this.aaServiceId = airCoServiceModel.getAaServiceId();
		this.serviceOrderId = airCoServiceModel.getServiceOrderId();
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
			String evaDescription, String evaValTemp, String evaValHum,
			String evaSetpointTemp, String evaSetpointHum,
			Boolean evaFlagCalibration, Boolean evaReviewFilter,
			Boolean evaReviewStrip, Boolean evaCleanElectricSystem,
			Boolean evaCleanControlCard, Boolean evaCleanTray,
			String evaLectrurePreasureHigh, String evaLectrurePreasureLow,
			String evaLectureTemp, String evaLectureOilColor,
			String evaLectureOilLevel, String evaLectureCoolerColor,
			String evaLectureCoolerLevel, String evaCheckOperatation,
			String evaCheckNoise, String evaCheckIsolated,
			String evaLectureVoltageGroud, String evaLectureVoltagePhases,
			String evaLectureVoltageControl, String evaLectureCurrentMotor1,
			String evaLectureCurrentMotor2, String evaLectureCurrentMotor3,
			String evaLectureCurrentCompressor1,
			String evaLectureCurrentCompressor2,
			String evaLectureCurrentCompressor3,
			String evaLectureCurrentHumidifier1,
			String evaLectureCurrentHumidifier2,
			String evaLectureCurrentHumidifier3,
			String evaLectureCurrentHeater1, String evaLectureCurrentHeater2,
			String evaLectureCurrentHeater3, Boolean evaCheckFluidSensor,
			Boolean evaRequirMaintenance, String condReview,
			Boolean condCleanElectricSystem, Boolean condClean,
			String condLectureVoltageGroud, String condLectureVoltagePhases,
			String condLectureVoltageControl, String condLectureMotorCurrent,
			String condReviewThermostat, String condModel,
			String condSerialNumber, String condBrand, String observations) {
		this.aaServiceId = aaServiceId;
		this.serviceOrderId = serviceOrderId;
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
	
	private String evaDescription;
	private String evaValTemp;
	private String evaValHum;
	private String evaSetpointTemp;
	private String evaSetpointHum;
	private Boolean evaFlagCalibration;
	private Boolean evaReviewFilter;
	private Boolean evaReviewStrip;
	private Boolean evaCleanElectricSystem;
	private Boolean evaCleanControlCard;
	private Boolean evaCleanTray;
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
	private Boolean evaCheckFluidSensor;
	private Boolean evaRequirMaintenance;
	private String condReview;
	private Boolean condCleanElectricSystem;
	private Boolean condClean;
	private String condLectureVoltageGroud;
	private String condLectureVoltagePhases;
	private String condLectureVoltageControl;
	private String condLectureMotorCurrent;
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
	
}
