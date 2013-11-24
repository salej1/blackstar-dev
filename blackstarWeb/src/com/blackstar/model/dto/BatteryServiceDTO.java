package com.blackstar.model.dto;

import java.util.Date;
import java.util.List;

import com.blackstar.model.BatteryService;

public class BatteryServiceDTO {

	public BatteryServiceDTO()
	{
		
	}
	
	public BatteryServiceDTO(OrderserviceDTO serviceOrder, BatteryService batteryService, List<BatteryCellServiceDTO> cells )
	{
		this.bbServiceId = batteryService.getBbServiceId();
		this.serviceOrderId = batteryService.getServiceOrderId();
		
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
			String coordinator, String serviceOrderNo, String ticketNo,
			Integer ticketId, Integer policyId, String serviceTypeId,
			String equipmentTypeId, String customer, String equipmentAddress,
			Date serviceDate, String contactName, String contactPhone,
			String equipmentType, String equipmentBrand, String equipmentModel,
			String equipmentSerialNo, String failureDescription,
			String serviceType, String proyectNumber, String signCreated,
			String signReceivedBy, String receivedBy,
			String receivedByPosition, String responsible, Date closed,
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

	private Integer bbServiceId;
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
