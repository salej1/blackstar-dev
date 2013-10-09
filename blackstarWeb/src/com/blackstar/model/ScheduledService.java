package com.blackstar.model;

import java.util.Date;

public class ScheduledService {
	int scheduledServiceId;
	Date scheduledDate;
	String equipmentType;
	String customer;
	String serialNumber;
	String asignee;
	String additionalEmployees;
	
	public int getScheduledServiceId() {
		return scheduledServiceId;
	}
	public void setScheduledServiceId(int scheduledServiceId) {
		this.scheduledServiceId = scheduledServiceId;
	}
	public Date getScheduledDate() {
		return scheduledDate;
	}
	public void setScheduledDate(Date scheduledDate) {
		this.scheduledDate = scheduledDate;
	}
	public String getEquipmentType() {
		return equipmentType;
	}
	public void setEquipmentType(String equipmentType) {
		this.equipmentType = equipmentType;
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
	public String getAsignee() {
		return asignee;
	}
	public void setAsignee(String asignee) {
		this.asignee = asignee;
	}
	public String getAdditionalEmployees() {
		return additionalEmployees;
	}
	public void setAdditionalEmployees(String additionalEmployees) {
		this.additionalEmployees = additionalEmployees;
	}
	
	
}
