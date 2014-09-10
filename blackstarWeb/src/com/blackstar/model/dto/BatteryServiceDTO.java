package com.blackstar.model.dto;

import java.util.ArrayList;
import java.util.List;

import com.blackstar.model.BatteryService;

public class BatteryServiceDTO {

	public BatteryServiceDTO()
	{
		this.setCells(new ArrayList<BatteryCellServiceDTO>(89));
	}

	
	public BatteryServiceDTO(BatteryServicePolicyDTO batteryService)
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
		this.cells = batteryService.getCells();
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
		this.cells = cells;
	}
	
	public BatteryServiceDTO(Integer bbServiceId, Integer serviceOrderId,
			Integer plugClean, String plugCleanStatus,
			String plugCleanComments, Integer coverClean,
			String coverCleanStatus, String coverCleanComments,
			Integer capClean, String capCleanStatus, String capCleanComments,
			Integer groundClean, String groundCleanStatus,
			String groundCleanComments, Integer rackClean,
			String rackCleanStatus, String rackCleanComments,
			String serialNoDateManufact, String batteryTemperature,
			String voltageBus, String temperature,
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
			Integer plugClean, String plugCleanStatus,
			String plugCleanComments, Integer coverClean,
			String coverCleanStatus, String coverCleanComments,
			Integer capClean, String capCleanStatus, String capCleanComments,
			Integer groundClean, String groundCleanStatus,
			String groundCleanComments, Integer rackClean,
			String rackCleanStatus, String rackCleanComments,
			String serialNoDateManufact, String batteryTemperature,
			String voltageBus, String temperature) {
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
	private Integer plugClean;
	private String plugCleanStatus;
	private String plugCleanComments;
	private Integer coverClean;
	private String coverCleanStatus;
	private String coverCleanComments;
	private Integer capClean;
	private String capCleanStatus;
	private String capCleanComments;
	private Integer groundClean;
	private String groundCleanStatus;
	private String groundCleanComments;
	private Integer rackClean;
	private String rackCleanStatus;
	private String rackCleanComments;
	private String serialNoDateManufact;
	private String batteryTemperature;
	private String voltageBus;
	private String temperature;

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


	public Integer getPlugClean() {
		return plugClean;
	}


	public void setPlugClean(Integer plugClean) {
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


	public Integer getCoverClean() {
		return coverClean;
	}


	public void setCoverClean(Integer coverClean) {
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


	public Integer getCapClean() {
		return capClean;
	}


	public void setCapClean(Integer capClean) {
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


	public Integer getGroundClean() {
		return groundClean;
	}


	public void setGroundClean(Integer groundClean) {
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


	public Integer getRackClean() {
		return rackClean;
	}


	public void setRackClean(Integer rackClean) {
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


	public String getVoltageBus() {
		return voltageBus;
	}


	public void setVoltageBus(String voltageBus) {
		this.voltageBus = voltageBus;
	}


	public String getTemperature() {
		return temperature;
	}


	public void setTemperature(String temperature) {
		this.temperature = temperature;
	}


	public List<BatteryCellServiceDTO> getCells() {
		return cells;
	}


	public void setCells(List<BatteryCellServiceDTO> cells) {
		this.cells = cells;
	}


}
