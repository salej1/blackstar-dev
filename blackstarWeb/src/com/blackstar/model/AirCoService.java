package com.blackstar.model;

import java.util.Date;

public class AirCoService {
	
	public AirCoService(Integer aaServiceId, Integer serviceOrderId,
			String evaDescription, String evaValTemp, String evaValHum,
			String evaSetpointTemp, String evaSetpointHum,
			Integer evaFlagCalibration, Integer evaReviewFilter,
			Integer evaReviewStrip, Integer evaCleanElectricSystem,
			Integer evaCleanControlCard, Integer evaCleanTray,
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
			String evaLectureCurrentHeater3, Integer evaCheckFluidSensor,
			Integer evaRequirMaintenance, String condReview,
			Integer condCleanElectricSystem, Integer condClean,
			String condLectureVoltageGroud, String condLectureVoltagePhases,
			String condLectureVoltageControl, String condLectureMotorCurrent,
			String condReviewThermostat, String condModel,
			String condSerialNumber, String condBrand, String observations,
			Date created, String createdBy, String createdByUsr, Date modified,
			String modifiedBy, String modifiedByUsr) {
		
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
		this.created = created;
		this.createdBy = createdBy;
		this.createdByUsr = createdByUsr;
		this.modified = modified;
		this.modifiedBy = modifiedBy;
		this.modifiedByUsr = modifiedByUsr;
	}
	
	private Integer aaServiceId;
	private Integer serviceOrderId;
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
	private Date created;
	private String createdBy;
	private String createdByUsr;
	private Date modified;
	private String modifiedBy;
	private String modifiedByUsr;
	
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
	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
	}
	public String getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}
	public String getCreatedByUsr() {
		return createdByUsr;
	}
	public void setCreatedByUsr(String createdByUsr) {
		this.createdByUsr = createdByUsr;
	}
	public Date getModified() {
		return modified;
	}
	public void setModified(Date modified) {
		this.modified = modified;
	}
	public String getModifiedBy() {
		return modifiedBy;
	}
	public void setModifiedBy(String modifiedBy) {
		this.modifiedBy = modifiedBy;
	}
	public String getModifiedByUsr() {
		return modifiedByUsr;
	}
	public void setModifiedByUsr(String modifiedByUsr) {
		this.modifiedByUsr = modifiedByUsr;
	}


}
