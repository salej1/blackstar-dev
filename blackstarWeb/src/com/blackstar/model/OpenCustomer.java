package com.blackstar.model;

import java.util.Date;

public class OpenCustomer implements java.io.Serializable  {

	private static final long serialVersionUID = 5433674646669426202L;

	private Integer openCustomerId ;
	private String customerName ;
	private String address ;
	private String phone ;
	private String equipmentTypeId;
	private String brand ;
	private String model ;
	private String capacity ;
	private String serialNumber ;
	private String contactName ;
	private String contactEmail ;
	private Date created ;
	private String createdBy ;
	private String createdByUsr ;
	private Date modified ;
	private String modifiedBy ;
	private String modifiedByUsr ;
	private String officeId;
	private String project;
	
	public Integer getOpenCustomerId() {
		return openCustomerId;
	}
	public void setOpenCustomerId(Integer openCustomerId) {
		this.openCustomerId = openCustomerId;
	}
	public String getCustomerName() {
		return customerName;
	}
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
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
	public String getCapacity() {
		return capacity;
	}
	public void setCapacity(String capacity) {
		this.capacity = capacity;
	}
	public String getSerialNumber() {
		return serialNumber;
	}
	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}
	public String getContactName() {
		return contactName;
	}
	public void setContactName(String contactName) {
		this.contactName = contactName;
	}
	public String getContactEmail() {
		return contactEmail;
	}
	public void setContactEmail(String contactEmail) {
		this.contactEmail = contactEmail;
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
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getEquipmentTypeId() {
		return equipmentTypeId;
	}
	public void setEquipmentTypeId(String equipmentTypeId) {
		this.equipmentTypeId = equipmentTypeId;
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
	public String getOfficeId() {
		return officeId;
	}
	public void setOfficeId(String officeId) {
		if(officeId != null && officeId.length() > 0){
			this.officeId = officeId.substring(0, 1);
		}
	}
	public String getProject() {
		return project;
	}
	public void setProject(String project) {
		this.project = project;
	}
}
