package com.blackstar.model.dto;

import java.text.ParseException;
import java.util.Date;

import com.blackstar.common.Globals;

public class TicketDTO {
	// Ticket part
	
	Integer ticketId;
	Integer policyId;
	Integer serviceOrderId;
	String ticketNumber;
	String user;
	String observations;
	String phoneResolved;
	String ticketStatusId;
	Integer realResponseTime;
	Integer responseTimeDeviationHr;
	Date arrival;
	String employee;
	String asignee;
	Date closed;
	Integer solutionTime;
	Integer solutionTimeDeviationHr;
	Date created;
	String createdBy;
	String createdByUsr;
	Date modified;
	String modifiedBy;
	String modifiedByUsr;
	String contact;
	String contactPhone;
	String contactEmail;
	String serviceOrderNumber;

	
	// Policy part
	String officeId;
	String customer;
	String project;
	String cst;
	String  equipmentType;
	String brand;
	String model;
	String serialNumber;
	String capacity;
	String equipmentAddress;
	String equipmentLocation;
	String contactName;
	Date startDate;
	Date endDate;
	Integer responseTimeHR;
	Integer solutionTimeHR;
	Integer includesParts;
	String 	exceptionParts;
	String serviceCenter;
	String serviceCenterEmail;
	String officeEmail;
	
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
	public Integer getServiceOrderId() {
		return serviceOrderId;
	}
	public void setServiceOrderId(Integer serviceOrderId) {
		this.serviceOrderId = serviceOrderId;
	}
	public String getTicketNumber() {
		return ticketNumber;
	}
	public void setTicketNumber(String ticketNumber) {
		this.ticketNumber = ticketNumber;
	}
	public String getUser() {
		return user;
	}
	public void setUser(String user) {
		this.user = user;
	}
	public String getObservations() {
		return observations;
	}
	public void setObservations(String observations) {
		this.observations = observations;
	}
	public String getPhoneResolved() {
		return phoneResolved;
	}
	public void setPhoneResolved(String phoneResolved) {
		this.phoneResolved = phoneResolved;
	}
	public String getTicketStatusId() {
		return ticketStatusId;
	}
	public void setTicketStatusId(String ticketStatusId) {
		this.ticketStatusId = ticketStatusId;
	}
	public Integer getRealResponseTime() {
		return realResponseTime;
	}
	public void setRealResponseTime(Integer realResponseTime) {
		this.realResponseTime = realResponseTime;
	}
	public Integer getResponseTimeDeviationHr() {
		return responseTimeDeviationHr;
	}
	public void setResponseTimeDeviationHr(Integer responseTimeDeviationHr) {
		this.responseTimeDeviationHr = responseTimeDeviationHr;
	}
	public Date getArrival() {
		return arrival;
	}
	public void setArrival(Date arrival) {
		this.arrival = arrival;
	}
	public String getEmployee() {
		return employee;
	}
	public void setEmployee(String employee) {
		this.employee = employee;
	}
	public String getAsignee() {
		return asignee;
	}
	public void setAsignee(String asignee) {
		this.asignee = asignee;
	}
	public Date getClosed() {
		return closed;
	}
	public void setClosed(Date closed) {
		this.closed = closed;
	}
	public Integer getSolutionTime() {
		return solutionTime;
	}
	public void setSolutionTime(Integer solutionTime) {
		this.solutionTime = solutionTime;
	}
	public Integer getSolutionTimeDeviationHr() {
		return solutionTimeDeviationHr;
	}
	public void setSolutionTimeDeviationHr(Integer solutionTimeDeviationHr) {
		this.solutionTimeDeviationHr = solutionTimeDeviationHr;
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
	public String getServiceOrderNumber() {
		return serviceOrderNumber;
	}
	public void setServiceOrderNumber(String serviceOrderNumber) {
		this.serviceOrderNumber = serviceOrderNumber;
	}
	public String getOfficeId() {
		return officeId;
	}
	public void setOfficeId(String officeId) {
		this.officeId = officeId;
	}
	public String getcustomer() {
		return customer;
	}
	public void setcustomer(String customer) {
		this.customer = customer;
	}
	public String getProject() {
		return project;
	}
	public void setProject(String project) {
		this.project = project;
	}
	public String getCst() {
		return cst;
	}
	public void setCst(String cst) {
		this.cst = cst;
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
	public String getEquipmentLocation() {
		return equipmentLocation;
	}
	public void setEquipmentLocation(String equipmentLocation) {
		this.equipmentLocation = equipmentLocation;
	}
	public String getContactName() {
		return contactName;
	}
	public void setContactName(String contactName) {
		this.contactName = contactName;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public Integer getResponseTimeHR() {
		return responseTimeHR;
	}
	public void setResponseTimeHR(Integer responseTimeHR) {
		this.responseTimeHR = responseTimeHR;
	}
	public Integer getSolutionTimeHR() {
		return solutionTimeHR;
	}
	public void setSolutionTimeHR(Integer solutionTimeHR) {
		this.solutionTimeHR = solutionTimeHR;
	}
	public Integer getIncludesParts() {
		return includesParts;
	}
	public void setIncludesParts(Integer includesParts) {
		this.includesParts = includesParts;
	}
	public String getExceptionParts() {
		return exceptionParts;
	}
	public void setExceptionParts(String exceptionParts) {
		this.exceptionParts = exceptionParts;
	}
	public String getServiceCenter() {
		return serviceCenter;
	}
	public void setServiceCenter(String serviceCenter) {
		this.serviceCenter = serviceCenter;
	}
	public String getCustomer() {
		return customer;
	}
	public void setCustomer(String customer) {
		this.customer = customer;
	}
	public String getServiceCenterEmail() {
		return serviceCenterEmail;
	}
	public void setServiceCenterEmail(String serviceCenterEmail) {
		this.serviceCenterEmail = serviceCenterEmail;
	}
	public String getOfficeEmail() {
		return officeEmail;
	}
	public void setOfficeEmail(String officeEmail) {
		this.officeEmail = officeEmail;
	}
	
	// manual
	public String getContractState(){
		if(endDate == null){
			return "";			
		}
		else{
			try {
				if(endDate.compareTo(Globals.getLocalTime()) <= 0){
					return "Vencido";
				}
				else{
					return "Activo";
				}
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return "";
	}

}
