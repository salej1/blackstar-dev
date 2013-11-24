package com.blackstar.model.dto;

import java.util.List;

import com.blackstar.model.BatteryService;

public class BatteryServiceDTO {

	public BatteryServiceDTO()
	{
		
	}
	
	public BatteryServiceDTO(BatteryService batteryService, List<BatteryCellServiceDTO> cells )
	{
		this.bbServiceId = batteryService.getBbServiceId();
		this.serviceOrderId = batteryService.getServiceOrderId();		
		this.plugClean = batteryService.getPlugClean();
		this.plugCleanStatus = batteryService.getPlugCleanStatus();
		this.plugCleanComments = batteryService.getPlugCleanComments();
		this.coverClean = batteryService.getCoverClean();
		this.coverCleanStatus = batteryService.getCoverCleanStatus();
		this.coverCleanComments = batteryService.getCoverCleanComments();
		this.capClean = batteryService.getCapClean();
		this.capCleanStatus = batteryService.getCapCleanStatus();
		this.capCleanComments = batteryService.getCapCleanComments();
		this.groundClean = batteryService.getGroundClean();
		this.groundCleanStatus = batteryService.getGroundCleanStatus();
		this.groundCleanComments = batteryService.getGroundCleanComments();
		this.rackClean = batteryService.getRackClean();
		this.rackCleanStatus = batteryService.getRackCleanStatus();
		this.rackCleanComments = batteryService.getRackCleanComments();
		this.serialNoDateManufact = batteryService.getSerialNoDateManufact();
		this.batteryTemperature = batteryService.getBatteryTemperature();
		this.voltageBus = batteryService.getVoltageBus();
		this.temperature = batteryService.getTemperature();
	}
	
	public BatteryServiceDTO(Integer bbServiceId, Integer serviceOrderId,
			Boolean plugClean, String plugCleanStatus,
			String plugCleanComments, Boolean coverClean,
			String coverCleanStatus, String coverCleanComments,
			Boolean capClean, String capCleanStatus, String capCleanComments,
			Boolean groundClean, String groundCleanStatus,
			String groundCleanComments, Boolean rackClean,
			String rackCleanStatus, String rackCleanComments,
			String serialNoDateManufact, String batteryTemperature,
			Integer voltageBus, Integer temperature,
			List<BatteryCellServiceDTO> cells) {
		this.bbServiceId = bbServiceId;
		this.serviceOrderId = serviceOrderId;
		this.plugClean = plugClean;
		this.plugCleanStatus = plugCleanStatus;
		this.plugCleanComments = plugCleanComments;
		this.coverClean = coverClean;
		this.coverCleanStatus = coverCleanStatus;
		this.coverCleanComments = coverCleanComments;
		this.capClean = capClean;
		this.capCleanStatus = capCleanStatus;
		this.capCleanComments = capCleanComments;
		this.groundClean = groundClean;
		this.groundCleanStatus = groundCleanStatus;
		this.groundCleanComments = groundCleanComments;
		this.rackClean = rackClean;
		this.rackCleanStatus = rackCleanStatus;
		this.rackCleanComments = rackCleanComments;
		this.serialNoDateManufact = serialNoDateManufact;
		this.batteryTemperature = batteryTemperature;
		this.voltageBus = voltageBus;
		this.temperature = temperature;
		this.cells = cells;
	}
	
	public BatteryServiceDTO(Integer bbServiceId, Integer serviceOrderId,
			Boolean plugClean, String plugCleanStatus,
			String plugCleanComments, Boolean coverClean,
			String coverCleanStatus, String coverCleanComments,
			Boolean capClean, String capCleanStatus, String capCleanComments,
			Boolean groundClean, String groundCleanStatus,
			String groundCleanComments, Boolean rackClean,
			String rackCleanStatus, String rackCleanComments,
			String serialNoDateManufact, String batteryTemperature,
			Integer voltageBus, Integer temperature) {
		this.bbServiceId = bbServiceId;
		this.serviceOrderId = serviceOrderId;
		this.plugClean = plugClean;
		this.plugCleanStatus = plugCleanStatus;
		this.plugCleanComments = plugCleanComments;
		this.coverClean = coverClean;
		this.coverCleanStatus = coverCleanStatus;
		this.coverCleanComments = coverCleanComments;
		this.capClean = capClean;
		this.capCleanStatus = capCleanStatus;
		this.capCleanComments = capCleanComments;
		this.groundClean = groundClean;
		this.groundCleanStatus = groundCleanStatus;
		this.groundCleanComments = groundCleanComments;
		this.rackClean = rackClean;
		this.rackCleanStatus = rackCleanStatus;
		this.rackCleanComments = rackCleanComments;
		this.serialNoDateManufact = serialNoDateManufact;
		this.batteryTemperature = batteryTemperature;
		this.voltageBus = voltageBus;
		this.temperature = temperature;
	}

	private Integer bbServiceId;
	private Integer serviceOrderId;	
	private Boolean plugClean;
	private String plugCleanStatus;
	private String plugCleanComments;
	private Boolean coverClean;
	private String coverCleanStatus;
	private String coverCleanComments;
	private Boolean capClean;
	private String capCleanStatus;
	private String capCleanComments;
	private Boolean groundClean;
	private String groundCleanStatus;
	private String groundCleanComments;
	private Boolean rackClean;
	private String rackCleanStatus;
	private String rackCleanComments;
	private String serialNoDateManufact;
	private String batteryTemperature;
	private Integer voltageBus;
	private Integer temperature;

	private List<BatteryCellServiceDTO> cells;

	public Integer getBbServiceId() {
		return bbServiceId;
	}

	public void setBbServiceId(Integer bbServiceId) {
		this.bbServiceId = bbServiceId;
	}

	public Integer getServiceOrderId() {
		return serviceOrderId;
	}

	public void setServiceOrderId(Integer serviceOrderId) {
		this.serviceOrderId = serviceOrderId;
	}

	public Boolean getPlugClean() {
		return plugClean;
	}

	public void setPlugClean(Boolean plugClean) {
		this.plugClean = plugClean;
	}

	public String getPlugCleanStatus() {
		return plugCleanStatus;
	}

	public void setPlugCleanStatus(String plugCleanStatus) {
		this.plugCleanStatus = plugCleanStatus;
	}

	public String getPlugCleanComments() {
		return plugCleanComments;
	}

	public void setPlugCleanComments(String plugCleanComments) {
		this.plugCleanComments = plugCleanComments;
	}

	public Boolean getCoverClean() {
		return coverClean;
	}

	public void setCoverClean(Boolean coverClean) {
		this.coverClean = coverClean;
	}

	public String getCoverCleanStatus() {
		return coverCleanStatus;
	}

	public void setCoverCleanStatus(String coverCleanStatus) {
		this.coverCleanStatus = coverCleanStatus;
	}

	public String getCoverCleanComments() {
		return coverCleanComments;
	}

	public void setCoverCleanComments(String coverCleanComments) {
		this.coverCleanComments = coverCleanComments;
	}

	public Boolean getCapClean() {
		return capClean;
	}

	public void setCapClean(Boolean capClean) {
		this.capClean = capClean;
	}

	public String getCapCleanStatus() {
		return capCleanStatus;
	}

	public void setCapCleanStatus(String capCleanStatus) {
		this.capCleanStatus = capCleanStatus;
	}

	public String getCapCleanComments() {
		return capCleanComments;
	}

	public void setCapCleanComments(String capCleanComments) {
		this.capCleanComments = capCleanComments;
	}

	public Boolean getGroundClean() {
		return groundClean;
	}

	public void setGroundClean(Boolean groundClean) {
		this.groundClean = groundClean;
	}

	public String getGroundCleanStatus() {
		return groundCleanStatus;
	}

	public void setGroundCleanStatus(String groundCleanStatus) {
		this.groundCleanStatus = groundCleanStatus;
	}

	public String getGroundCleanComments() {
		return groundCleanComments;
	}

	public void setGroundCleanComments(String groundCleanComments) {
		this.groundCleanComments = groundCleanComments;
	}

	public Boolean getRackClean() {
		return rackClean;
	}

	public void setRackClean(Boolean rackClean) {
		this.rackClean = rackClean;
	}

	public String getRackCleanStatus() {
		return rackCleanStatus;
	}

	public void setRackCleanStatus(String rackCleanStatus) {
		this.rackCleanStatus = rackCleanStatus;
	}

	public String getRackCleanComments() {
		return rackCleanComments;
	}

	public void setRackCleanComments(String rackCleanComments) {
		this.rackCleanComments = rackCleanComments;
	}

	public String getSerialNoDateManufact() {
		return serialNoDateManufact;
	}

	public void setSerialNoDateManufact(String serialNoDateManufact) {
		this.serialNoDateManufact = serialNoDateManufact;
	}

	public String getBatteryTemperature() {
		return batteryTemperature;
	}

	public void setBatteryTemperature(String batteryTemperature) {
		this.batteryTemperature = batteryTemperature;
	}

	public Integer getVoltageBus() {
		return voltageBus;
	}

	public void setVoltageBus(Integer voltageBus) {
		this.voltageBus = voltageBus;
	}

	public Integer getTemperature() {
		return temperature;
	}

	public void setTemperature(Integer temperature) {
		this.temperature = temperature;
	}

	public List<BatteryCellServiceDTO> getCells() {
		return cells;
	}

	public void setCells(List<BatteryCellServiceDTO> cells) {
		this.cells = cells;
	}
	
	

}
