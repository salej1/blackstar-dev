package com.blackstar.model.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import com.blackstar.model.OpenCustomer;
import com.blackstar.model.ScheduledService;

public class ScheduledServiceDTO implements Serializable {

	private static final long serialVersionUID = 8040775858579176641L;

	public ScheduledServiceDTO(){
		this.noPolicy = false;
	}
	
	public ScheduledServiceDTO(ScheduledService schService){
		this.scheduledServiceId = schService.getScheduledServiceId();
		this.serviceStatusId = schService.getServiceStatusId();
		this.description = schService.getDescription();
		this.created = schService.getCreated();
		this.createdBy = schService.getCreatedBy();
		this.createdByUsr = schService.getCreatedByUsr();
		this.modified = schService.getModified();
		this.modifiedBy = schService.getModifiedBy();
		this.modifiedByUsr = schService.getModifiedByUsr();
		this.project = schService.getProject();
		this.serviceContact = schService.getServiceContact();
		this.serviceContactEmail = schService.getServiceContactEmail();
		this.officeId = schService.getOfficeId();
	}
	
	public ScheduledServiceDTO(ScheduledService schService, OpenCustomer customer){
		this.scheduledServiceId = schService.getScheduledServiceId();
		this.serviceStatusId = schService.getServiceStatusId();
		this.created = schService.getCreated();
		this.createdBy = schService.getCreatedBy();
		this.createdByUsr = schService.getCreatedByUsr();
		this.modified = schService.getModified();
		this.modifiedBy = schService.getModifiedBy();
		this.modifiedByUsr = schService.getModifiedByUsr();
		this.project = schService.getProject();
		this.serviceContact = schService.getServiceContact();
		this.serviceContactEmail = schService.getServiceContactEmail();
		// customer
		this.openCustomerId = customer.getOpenCustomerId();
		this.customer = customer.getCustomerName();
		this.serialNumber = customer.getSerialNumber();
		this.contact = customer.getContactName();
		this.contactEmail = customer.getContactEmail();
		this.contactPhone = customer.getPhone();
		this.equipmentTypeId = customer.getEquipmentTypeId();
		this.brand = customer.getBrand();
		this.model = customer.getModel();
		this.noPolicy = true;
		this.officeId = schService.getOfficeId();
	}
	
	// Scheduled Service
	private Integer scheduledServiceId;
	private String serviceStatusId;
	private String description;
	private Date created;
	private String createdBy;
	private String createdByUsr;
	private Date modified;
	private String modifiedBy;
	private String modifiedByUsr;
	private String project;
	private String serviceContact;
	private String serviceContactEmail;
	
	// Policy
	private List<Integer> policyList;
	private String equipmentType;
	private String serialNumberList;
	// Employee
	private List<String> employeeList;
	private String employeeNamesString;
	private String defaultEmployee;
	// Open customer
	private Integer openCustomerId;
	private String customer;
	private String serialNumber;
	private String address;
	private String contact;
	private String contactPhone;
	private String contactEmail;
	private String equipmentTypeId;
	private String brand ;
	private String model ;
	private Date serviceStartDate;
	private Integer numDays;
	private Boolean noPolicy;
	private String officeId;
	
	public Integer getScheduledServiceId() {
		return scheduledServiceId;
	}
	public void setScheduledServiceId(Integer scheduledServiceId) {
		this.scheduledServiceId = scheduledServiceId;
	}
	public String getServiceStatusId() {
		return serviceStatusId;
	}
	public void setServiceStatusId(String serviceStatusId) {
		this.serviceStatusId = serviceStatusId;
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

	public List<Integer> getPolicyList() {
		return policyList;
	}

	public void setPolicyList(List<Integer> policyList) {
		this.policyList = policyList;
	}

	public List<String> getEmployeeList() {
		return employeeList;
	}

	public void setEmployeeList(List<String> employeeList) {
		this.employeeList = employeeList;
	}

	public String getCustomer() {
		return customer;
	}

	public void setCustomer(String customer) {
		this.customer = customer;
	}

	public String getSerialNumber() {
		return serialNumber;
	}

	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	public String getContactPhone() {
		return contactPhone;
	}

	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}

	public String getContactEmail() {
		return contactEmail;
	}

	public void setContactEmail(String contactEmail) {
		this.contactEmail = contactEmail;
	}

	public String getEquipmentTypeId() {
		return equipmentTypeId;
	}

	public void setEquipmentTypeId(String equipmentTypeId) {
		this.equipmentTypeId = equipmentTypeId;
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

	public String getEquipmentType() {
		return equipmentType;
	}

	public void setEquipmentType(String equipmentType) {
		this.equipmentType = equipmentType;
	}

	public Date getServiceStartDate() {
		return serviceStartDate;
	}

	public void setServiceStartDate(Date serviceStartDate) {
		this.serviceStartDate = serviceStartDate;
	}

	public Integer getNumDays() {
		return numDays;
	}

	public void setNumDays(Integer numDays) {
		this.numDays = numDays;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Integer getOpenCustomerId() {
		return openCustomerId;
	}

	public void setOpenCustomerId(Integer openCustomerId) {
		this.openCustomerId = openCustomerId;
	}

	public Boolean getNoPolicy() {
		return noPolicy;
	}

	public void setNoPolicy(Boolean noPolicy) {
		this.noPolicy = noPolicy;
	}

	public String getProject() {
		return project;
	}

	public void setProject(String project) {
		this.project = project;
	}

	public String getOfficeId() {
		if(officeId != null){
			return officeId.substring(0,1);
		}
		else{
			return null;
		}
	}

	public void setOfficeId(String officeId) {
		this.officeId = officeId;
	}

	public String getEmployeeNamesString() {
		return employeeNamesString;
	}

	public void setEmployeeNamesString(String employeeNamesString) {
		this.employeeNamesString = employeeNamesString;
	}

	public String getSerialNumberList() {
		return serialNumberList;
	}

	public void setSerialNumberList(String serialNumberList) {
		this.serialNumberList = serialNumberList;
	}

	public String getDefaultEmployee() {
		return defaultEmployee;
	}

	public void setDefaultEmployee(String defaultEmployee) {
		this.defaultEmployee = defaultEmployee;
	}

	public String getServiceContact() {
		return serviceContact;
	}

	public void setServiceContact(String serviceContact) {
		this.serviceContact = serviceContact;
	}

	public String getServiceContactEmail() {
		return serviceContactEmail;
	}

	public void setServiceContactEmail(String serviceContactEmail) {
		this.serviceContactEmail = serviceContactEmail;
	}
}
