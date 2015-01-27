package com.blackstar.model.sp;

import java.util.Date;

public class GetConcurrentFailuresKPI {
	
	private String employee;
	private String customer;
	private String equipmentTypeId;
	private String brand;
	private String serialNumber;
	private String observations;
	private String asignee;
	private String ticketNumber;
	private Date created;
	private String lastTicketNumber;
	private String lastTicketClosed;
	private String lastServiceNumber;
	
	public GetConcurrentFailuresKPI(){
		
	}
	
	public GetConcurrentFailuresKPI(String employee){
		this.employee = employee;
	}
	
	public String getEmployee() {
		return employee;
	}
	public void setEmployee(String employee) {
		this.employee = employee;
	}
	public String getCustomer() {
		return customer;
	}
	public void setCustomer(String customer) {
		this.customer = customer;
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
	public String getSerialNumber() {
		return serialNumber;
	}
	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}
	public String getObservations() {
		return observations;
	}
	public void setObservations(String observations) {
		this.observations = observations;
	}
	public String getAsignee() {
		return asignee;
	}
	public void setAsignee(String asignee) {
		this.asignee = asignee;
	}
	public String getTicketNumber() {
		return ticketNumber;
	}
	public void setTicketNumber(String ticketNumber) {
		this.ticketNumber = ticketNumber;
	}
	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
	}
	public String getLastTicketNumber() {
		return lastTicketNumber;
	}

	public void setLastTicketNumber(String lastTicketNumber) {
		this.lastTicketNumber = lastTicketNumber;
	}

	public String getLastTicketClosed() {
		return lastTicketClosed;
	}

	public void setLastTicketClosed(String lastTicketClosed) {
		this.lastTicketClosed = lastTicketClosed;
	}

	public String getLastServiceNumber() {
		return lastServiceNumber;
	}

	public void setLastServiceNumber(String lastServiceNumber) {
		this.lastServiceNumber = lastServiceNumber;
	}
}
