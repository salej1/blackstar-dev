package com.blackstar.model;

import java.util.Date;

public class EmergencyPlantService {

	public EmergencyPlantService(Integer epServiceId, Integer serviceOrderId,
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
			String clockLecture, Date serviceCorrective, String observations,
			Date created, String createdBy, String createdByUsr, Date modified,
			String modifiedBy, String modifiedByUsr, String brandPE, String modelPE , String serialPE) {
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
		this.created = created;
		this.createdBy = createdBy;
		this.createdByUsr = createdByUsr;
		this.modified = modified;
		this.modifiedBy = modifiedBy;
		this.modifiedByUsr = modifiedByUsr;
		this.brandPE=brandPE;
		this.modelPE=modelPE;
		this.serialPE=serialPE;
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
	private Date serviceCorrective;
	private String observations;
	private Date created;
	private String createdBy;
	private String createdByUsr;
	private Date modified;
	private String modifiedBy;
	private String modifiedByUsr;
	
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
