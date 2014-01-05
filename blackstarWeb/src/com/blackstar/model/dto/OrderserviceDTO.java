package com.blackstar.model.dto;

import java.util.Date;

public class OrderserviceDTO {

	
	public OrderserviceDTO()
	{
	}
	
	public OrderserviceDTO(String coordinator, Integer serviceOrderId, String serviceOrderNo, String ticketNo, Integer ticketId, 
							String customer, String equipmentAddress, String contactName, Date serviceDate, String contactPhone, 
							String equipmentType, String equipmentBrand, String equipmentModel, String equipmentSerialNo, String failureDescription, 
							String serviceType, String proyectNumber, String detailIssue, String detailWorkDone, String detailTechnicalJob, 
							String detailRequirments, String detailStatus, String signCreated, String signReceivedBy, String receivedBy, String responsible, Date closed, String receivedByPosition,
							Integer isWrong)
	{
		this.coordinator = coordinator;
		this.serviceOrderNo = serviceOrderNo;
		this.serviceOrderId = serviceOrderId;
		this.ticketNo = ticketNo;
		this.ticketId = ticketId;
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
		this.detailIssue = detailIssue;
		this.detailWorkDone = detailWorkDone;
		this.detailTechnicalJob = detailTechnicalJob;
		this.detailRequirments = detailRequirments;
		this.detailStatus = detailStatus;
		this.signCreated = signCreated;
		this.signReceivedBy = signReceivedBy;
		this.receivedBy = receivedBy;
		this.responsible = responsible;
		this.closed = closed;
		this.receivedByPosition = receivedByPosition;
		this.isWrong = isWrong;
	}
	
	
	private String coordinator;
	private String serviceOrderNo;
	private Integer serviceOrderId;
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
	private String detailIssue;
	private String detailWorkDone;
	private String detailTechnicalJob;
	private String detailRequirments;
	private String detailStatus;
	private String signCreated;
	private String signReceivedBy;
	private String receivedBy;
	private String receivedByPosition;
	private String responsible;
	private Date closed;
	private Integer isWrong;

    
    public String getServiceOrderNo() {
        return serviceOrderNo;
    }
    public void setServiceOrderNo(String serviceOrderNo) {
        this.serviceOrderNo = serviceOrderNo;
    }
    
    public Integer getServiceOrderId() {
        return serviceOrderId;
    }
    public void setServiceOrderId(Integer serviceOrderId) {
        this.serviceOrderId = serviceOrderId;
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
	public String getDetailIssue() {
		return detailIssue;
	}
	public void setDetailIssue(String detailIssue) {
		this.detailIssue = detailIssue;
	}
	public String getDetailWorkDone() {
		return detailWorkDone;
	}
	public void setDetailWorkDone(String detailWorkDone) {
		this.detailWorkDone = detailWorkDone;
	}
	public String getDetailTechnicalJob() {
		return detailTechnicalJob;
	}
	public void setDetailTechnicalJob(String detailTechnicalJob) {
		this.detailTechnicalJob = detailTechnicalJob;
	}
	public String getDetailRequirments() {
		return detailRequirments;
	}
	public void setDetailRequirments(String detailRequirments) {
		this.detailRequirments = detailRequirments;
	}
	public String getDetailStatus() {
		return detailStatus;
	}
	public void setDetailStatus(String detailStatus) {
		this.detailStatus = detailStatus;
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

	public String getReceivedByPosition() {
		return receivedByPosition;
	}

	public void setReceivedByPosition(String receivedByPosition) {
		this.receivedByPosition = receivedByPosition;
	}

	public String getCoordinator() {
		return coordinator;
	}

	public void setCoordinator(String coordinator) {
		this.coordinator = coordinator;
	}

	public Integer getIsWrong() {
		return isWrong;
	}
	
	public void setIsWrong(Integer isWrong) {
		this.isWrong = isWrong;
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
}
