package com.blackstar.model.dto;

import java.util.Date;

import com.blackstar.model.Employee;
import com.blackstar.model.OpenCustomer;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;

public class PlainServicePolicyDTO {
	
	public PlainServicePolicyDTO()
	{
		this.closed = new Date();
		this.serviceDate = new Date();
	}
	

	public PlainServicePolicyDTO(OpenCustomer customer)
	{
		this.customer = customer.getCustomerName();
		this.finalUser = customer.getContactEmail();
		this.project = "";
		this.equipmentTypeId = customer.getEquipmentTypeId().charAt(0);
		this.brand = customer.getBrand();
		this.model = customer.getModel();
		this.serialNumber = customer.getSerialNumber();
		this.capacity = customer.getCapacity();
		this.equipmentAddress = customer.getAddress();
		this.contactName = customer.getContactName();
		this.contactPhone = customer.getPhone();
		
		this.closed = new Date();
		this.serviceDate = new Date();
		
	}
	
	public PlainServicePolicyDTO(OpenCustomer customer, Serviceorder serviceOrder, PlainServiceDTO plainServiceDTO)
	{
		this.customer = customer.getCustomerName();
		this.finalUser = customer.getContactEmail();
		this.project = "";
		this.equipmentTypeId = customer.getEquipmentTypeId().charAt(0);
		this.brand = customer.getBrand();
		this.model = customer.getModel();
		this.serialNumber = customer.getSerialNumber();
		this.capacity = customer.getCapacity();
		this.equipmentAddress = customer.getAddress();
		this.contactName = customer.getContactName();
		this.contactPhone = customer.getPhone();
		
		this.closed = new Date();
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
		this.serviceTypeId = serviceOrder.getServiceTypeId().toString();
		this.isWrong = serviceOrder.getIsWrong()>0?true:false;
		this.receivedByEmail = serviceOrder.getReceivedByEmail();
		this.responsibleName = serviceOrder.getResponsibleName();
		this.plainServiceId = plainServiceDTO.getPlainServiceId();
		this.troubleDescription = plainServiceDTO.getTroubleDescription();
		this.techParam = plainServiceDTO.getTechParam();
		this.workDone = plainServiceDTO.getWorkDone();
		this.materialUsed = plainServiceDTO.getMaterialUsed();
		this.observations = plainServiceDTO.getObservations();
		if(serviceOrder.getEmployeeList().size() > 0){
			// Se reescriben responsible y responsibleName para las OS que tengan lista de empleados
			this.responsible = serviceOrder.getEmployeeListString();
			this.responsibleName = serviceOrder.getEmployeeNameListString();
		}
	}
	
	public PlainServicePolicyDTO(Policy policy, String equipmentType)
	{
		this.policyId = policy.getPolicyId();
		this.customer = policy.getCustomer();
		this.finalUser = policy.getFinalUser();
		this.project = policy.getProject();
		this.equipmentTypeId = policy.getEquipmentTypeId();
		this.equipmentType =equipmentType;
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
	}
	

	public PlainServicePolicyDTO(Policy policy, String equipmentType, Serviceorder serviceOrder)
	{
		this.policyId = policy.getPolicyId();
		this.customer = policy.getCustomer();
		this.finalUser = policy.getFinalUser();
		this.project = policy.getProject();
		this.equipmentTypeId = policy.getEquipmentTypeId();
		this.equipmentType =equipmentType;
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
		this.serviceTypeId = serviceOrder.getServiceTypeId().toString();
		this.isWrong = serviceOrder.getIsWrong()>0?true:false;
		this.receivedByEmail = serviceOrder.getReceivedByEmail();
		this.responsibleName = serviceOrder.getResponsible();
		if(serviceOrder.getEmployeeList().size() > 0){
			// Se reescriben responsible y responsibleName para las OS que tengan lista de empleados
			this.responsible = serviceOrder.getEmployeeListString();
			this.responsibleName = serviceOrder.getEmployeeNameListString();
		}
	}
	
	public PlainServicePolicyDTO(Policy policy, String equipmentType, Serviceorder serviceOrder,  PlainServiceDTO plainServiceDTO)
	{
		this.policyId = policy.getPolicyId();
		this.customer = policy.getCustomer();
		this.finalUser = policy.getFinalUser();
		this.project = policy.getProject();
		this.equipmentTypeId = policy.getEquipmentTypeId();
		this.equipmentType =equipmentType;
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
		this.serviceTypeId = serviceOrder.getServiceTypeId().toString();
		this.isWrong = serviceOrder.getIsWrong()>0?true:false;
		this.receivedByEmail = serviceOrder.getReceivedByEmail();
		this.responsibleName = serviceOrder.getResponsibleName();
		this.plainServiceId = plainServiceDTO.getPlainServiceId();
		this.troubleDescription = plainServiceDTO.getTroubleDescription();
		this.techParam = plainServiceDTO.getTechParam();
		this.workDone = plainServiceDTO.getWorkDone();
		this.materialUsed = plainServiceDTO.getMaterialUsed();
		this.observations = plainServiceDTO.getObservations();
		if(serviceOrder.getEmployeeList().size() > 0){
			// Se reescriben responsible y responsibleName para las OS que tengan lista de empleados
			this.responsible = serviceOrder.getEmployeeListString();
			this.responsibleName = serviceOrder.getEmployeeNameListString();
		}
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
	private String ticketNumber;
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
	private String receivedByEmail;
	private String serviceOrderNumber;
	private String serviceTypeId;
	private String serviceType;
    private Integer plainServiceId;	
	private String troubleDescription;
	private String techParam;
	private String workDone;
	private String materialUsed;
	private String observations;
	private Boolean isWrong;
	private String responsibleName;
	
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

	public Integer getPlainServiceId() {
		return plainServiceId;
	}

	public void setPlainServiceId(Integer plainServiceId) {
		this.plainServiceId = plainServiceId;
	}

	public String getTroubleDescription() {
		return troubleDescription;
	}

	public void setTroubleDescription(String troubleDescription) {
		this.troubleDescription = troubleDescription;
	}

	public String getTechParam() {
		return techParam;
	}

	public void setTechParam(String techParam) {
		this.techParam = techParam;
	}

	public String getWorkDone() {
		return workDone;
	}

	public void setWorkDone(String workDone) {
		this.workDone = workDone;
	}

	public String getMaterialUsed() {
		return materialUsed;
	}

	public void setMaterialUsed(String materialUsed) {
		this.materialUsed = materialUsed;
	}

	public String getObservations() {
		return observations;
	}

	public void setObservations(String observations) {
		this.observations = observations;
	}

	public String getServiceTypeId() {
		return serviceTypeId;
	}

	public void setServiceTypeId(String serviceTypeId) {
		this.serviceTypeId = serviceTypeId;
	}

	public Boolean getIsWrong() {
		return isWrong;
	}

	public void setIsWrong(Boolean isWrong) {
		this.isWrong = isWrong;
	}
	public String getServiceType() {
		return serviceType;
	}
	public void setServiceType(String serviceType) {
		this.serviceType = serviceType;
	}

	public String getTicketNumber() {
		return ticketNumber;
	}

	public void setTicketNumber(String ticketNumber) {
		this.ticketNumber = ticketNumber;
	}

	public String getReceivedByEmail() {
		return receivedByEmail;
	}

	public void setReceivedByEmail(String receivedByEmail) {
		this.receivedByEmail = receivedByEmail;
	}

	public String getResponsibleName() {
		return responsibleName;
	}

	public void setResponsibleName(String responsibleName) {
		this.responsibleName = responsibleName;
	}
}
