package com.blackstar.model.dto;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.blackstar.model.OpenCustomer;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;

public class BatteryServicePolicyDTO {
	
	public BatteryServicePolicyDTO()
	{
		this.closed = new Date();
		this.serviceDate = new Date();
		this.setCells(new ArrayList<BatteryCellServiceDTO>());
	}
	
	public BatteryServicePolicyDTO(Policy policy)
	{
		this.policyId = policy.getPolicyId();
		this.customer = policy.getCustomer();
		this.finalUser = policy.getFinalUser();
		this.project = policy.getProject();
		this.equipmentTypeId = policy.getEquipmentTypeId();
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
		
		this.setCells(new ArrayList<BatteryCellServiceDTO>());
	}
	
	public BatteryServicePolicyDTO(OpenCustomer customer){
		
		this.customer = customer.getCustomerName();
		this.finalUser = customer.getContactEmail();
		this.project = "";
		if(customer.getEquipmentTypeId() != null && customer.getEquipmentTypeId().length() > 0){
			this.equipmentTypeId = customer.getEquipmentTypeId().charAt(0);
		}
		this.brand = customer.getBrand();
		this.model = customer.getModel();
		this.serialNumber = customer.getSerialNumber();
		this.capacity = customer.getCapacity();
		this.equipmentAddress = customer.getAddress();
		if(customer.getOfficeId() != null && customer.getOfficeId().length() > 0){
			this.officeId = customer.getOfficeId().charAt(0);
		}
		this.contactName = customer.getContactName();
		this.contactPhone = customer.getPhone();
		
		this.serviceDate = new Date();
	}
	
	public BatteryServicePolicyDTO(Policy policy, Serviceorder serviceOrder)
	{
		this.policyId = policy.getPolicyId();
		this.customer = policy.getCustomer();
		this.finalUser = policy.getFinalUser();
		this.project = policy.getProject();
		this.equipmentTypeId = policy.getEquipmentTypeId();
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
		this.receivedByEmail = serviceOrder.getReceivedByEmail();
		this.responsibleName = serviceOrder.getEmployeeNameListString();
		this.isWrong = serviceOrder.getIsWrong()>0?true:false;
		this.serviceEndDate = serviceOrder.getServiceEndDate();
		
		this.setCells(new ArrayList<BatteryCellServiceDTO>());
		
	}
	
	public BatteryServicePolicyDTO(Policy policy, Serviceorder serviceOrder,  BatteryServiceDTO batteryServiceDTO)
	{
		this.policyId = policy.getPolicyId();
		this.customer = policy.getCustomer();
		this.finalUser = policy.getFinalUser();
		this.project = policy.getProject();
		this.equipmentTypeId = policy.getEquipmentTypeId();
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
		this.receivedByEmail = serviceOrder.getReceivedByEmail();
		this.responsibleName = serviceOrder.getEmployeeNameListString();
		this.isWrong = serviceOrder.getIsWrong()>0?true:false;
		this.serviceEndDate = serviceOrder.getServiceEndDate();
		
		this.bbServiceId = batteryServiceDTO.getBbServiceId();
		this.serviceOrderId = batteryServiceDTO.getServiceOrderId();		
		this.plugClean = batteryServiceDTO.getPlugClean();
		this.plugCleanStatus = batteryServiceDTO.getPlugCleanStatus();
		this.plugCleanComments = batteryServiceDTO.getPlugCleanComments();
		this.coverClean = batteryServiceDTO.getCoverClean();
		this.coverCleanStatus = batteryServiceDTO.getCoverCleanStatus();
		this.coverCleanComments = batteryServiceDTO.getCoverCleanComments();
		this.capClean = batteryServiceDTO.getCapClean();
		this.capCleanStatus = batteryServiceDTO.getCapCleanStatus();
		this.capCleanComments = batteryServiceDTO.getCapCleanComments();
		this.groundClean = batteryServiceDTO.getGroundClean();
		this.groundCleanStatus = batteryServiceDTO.getGroundCleanStatus();
		this.groundCleanComments = batteryServiceDTO.getGroundCleanComments();
		this.rackClean = batteryServiceDTO.getRackClean();
		this.rackCleanStatus = batteryServiceDTO.getRackCleanStatus();
		this.rackCleanComments = batteryServiceDTO.getRackCleanComments();
		this.serialNoDateManufact = batteryServiceDTO.getSerialNoDateManufact();
		this.batteryTemperature = batteryServiceDTO.getBatteryTemperature();
		this.voltageBus = batteryServiceDTO.getVoltageBus();
		this.temperature = batteryServiceDTO.getTemperature();
		this.cells = batteryServiceDTO.getCells();
	}
	
	public BatteryServicePolicyDTO(OpenCustomer customer, Serviceorder serviceOrder,  BatteryServiceDTO batteryServiceDTO){
		this.customer = customer.getCustomerName();
		this.finalUser = customer.getContactEmail();
		this.project = "";
		if(customer.getEquipmentTypeId() != null && customer.getEquipmentTypeId().length() > 0){
			this.equipmentTypeId = customer.getEquipmentTypeId().charAt(0);
		}
		this.brand = customer.getBrand();
		this.model = customer.getModel();
		this.serialNumber = customer.getSerialNumber();
		this.capacity = customer.getCapacity();
		this.equipmentAddress = customer.getAddress();
		this.contactName = customer.getContactName();
		this.contactPhone = customer.getPhone();
		if(customer.getOfficeId() != null && customer.getOfficeId().length() > 0){
			this.officeId = customer.getOfficeId().charAt(0);
		}
		
		this.serviceDate = new Date();
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
		this.receivedByEmail = serviceOrder.getReceivedByEmail();
		this.responsibleName = serviceOrder.getEmployeeNameListString();
		this.isWrong = serviceOrder.getIsWrong()>0?true:false;
		this.serviceEndDate = serviceOrder.getServiceEndDate();
		
		this.bbServiceId = batteryServiceDTO.getBbServiceId();
		this.serviceOrderId = batteryServiceDTO.getServiceOrderId();		
		this.plugClean = batteryServiceDTO.getPlugClean();
		this.plugCleanStatus = batteryServiceDTO.getPlugCleanStatus();
		this.plugCleanComments = batteryServiceDTO.getPlugCleanComments();
		this.coverClean = batteryServiceDTO.getCoverClean();
		this.coverCleanStatus = batteryServiceDTO.getCoverCleanStatus();
		this.coverCleanComments = batteryServiceDTO.getCoverCleanComments();
		this.capClean = batteryServiceDTO.getCapClean();
		this.capCleanStatus = batteryServiceDTO.getCapCleanStatus();
		this.capCleanComments = batteryServiceDTO.getCapCleanComments();
		this.groundClean = batteryServiceDTO.getGroundClean();
		this.groundCleanStatus = batteryServiceDTO.getGroundCleanStatus();
		this.groundCleanComments = batteryServiceDTO.getGroundCleanComments();
		this.rackClean = batteryServiceDTO.getRackClean();
		this.rackCleanStatus = batteryServiceDTO.getRackCleanStatus();
		this.rackCleanComments = batteryServiceDTO.getRackCleanComments();
		this.serialNoDateManufact = batteryServiceDTO.getSerialNoDateManufact();
		this.batteryTemperature = batteryServiceDTO.getBatteryTemperature();
		this.voltageBus = batteryServiceDTO.getVoltageBus();
		this.temperature = batteryServiceDTO.getTemperature();
		this.cells = batteryServiceDTO.getCells();
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
	private String serviceTypeId;
	
	private Integer bbServiceId;	
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
	private String receivedByEmail;
	private List<BatteryCellServiceDTO> cells;
	private String responsibleName;
	private Boolean isWrong;
	private Integer openCustomerId;
	private Date serviceEndDate;
	
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
	public Integer getBbServiceId() {
		return bbServiceId;
	}
	public void setBbServiceId(Integer bbServiceId) {
		this.bbServiceId = bbServiceId;
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

	public String getReceivedByEmail() {
		return receivedByEmail;
	}

	public void setReceivedByEmail(String receivedByEmail) {
		this.receivedByEmail = receivedByEmail;
	}

	public String getServiceTypeId() {
		return serviceTypeId;
	}

	public void setServiceTypeId(String serviceTypeId) {
		this.serviceTypeId = serviceTypeId;
	}

	public String getResponsibleName() {
		return responsibleName;
	}

	public void setResponsibleName(String responsibleName) {
		this.responsibleName = responsibleName;
	}

	public Boolean getIsWrong() {
		return isWrong;
	}

	public void setIsWrong(Boolean isWrong) {
		this.isWrong = isWrong;
	}

	public Integer getOpenCustomerId() {
		return openCustomerId;
	}

	public void setOpenCustomerId(Integer openCustomerId) {
		this.openCustomerId = openCustomerId;
	}

	public Date getServiceEndDate() {
		return serviceEndDate;
	}

	public void setServiceEndDate(Date serviceEndDate) {
		this.serviceEndDate = serviceEndDate;
	}
	
	

}
