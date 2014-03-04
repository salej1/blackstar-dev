package com.blackstar.model.dto;

import java.io.Serializable;
import java.util.Date;

public class WarrantProjectDTO implements Serializable
{
	private static final long serialVersionUID = -7082269088708599322L;
	 private Integer warrantProjectId;
	 private String status;
	 private Integer customerId;
	 private String costCenter;
	 private Double exchangeRate;
	 private Date updateDate;
	 private String contactName;
	 private String ubicationProject;
	 private Integer paymentTermsId;
	 private String deliveryTime;
	 private String intercom;
	 private Double totalProject;
	 private Integer bonds;
	 private Double totalProductsServices;
	 private Integer entryId;
	 
	public WarrantProjectDTO() 
	{
	}

	public Integer getWarrantProjectId() {
		return warrantProjectId;
	}

	public void setWarrantProjectId(Integer warrantProjectId) {
		this.warrantProjectId = warrantProjectId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Integer getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}

	public String getCostCenter() {
		return costCenter;
	}

	public void setCostCenter(String costCenter) {
		this.costCenter = costCenter;
	}

	public Double getExchangeRate() {
		return exchangeRate;
	}

	public void setExchangeRate(Double exchangeRate) {
		this.exchangeRate = exchangeRate;
	}

	

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	public String getContactName() {
		return contactName;
	}

	public void setContactName(String contactName) {
		this.contactName = contactName;
	}

	public String getUbicationProject() {
		return ubicationProject;
	}

	public void setUbicationProject(String ubicationProject) {
		this.ubicationProject = ubicationProject;
	}

	public Integer getPaymentTermsId() {
		return paymentTermsId;
	}

	public void setPaymentTermsId(Integer paymentTermsId) {
		this.paymentTermsId = paymentTermsId;
	}

	public String getDeliveryTime() {
		return deliveryTime;
	}

	public void setDeliveryTime(String deliveryTime) {
		this.deliveryTime = deliveryTime;
	}

	public String getIntercom() {
		return intercom;
	}

	public void setIntercom(String intercom) {
		this.intercom = intercom;
	}

	public Double getTotalProject() {
		return totalProject;
	}

	public void setTotalProject(Double totalProject) {
		this.totalProject = totalProject;
	}

	public Integer getBonds() {
		return bonds;
	}

	public void setBonds(Integer bonds) {
		this.bonds = bonds;
	}

	public Double getTotalProductsServices() {
		return totalProductsServices;
	}

	public void setTotalProductsServices(Double totalProductsServices) {
		this.totalProductsServices = totalProductsServices;
	}

	public Integer getEntryId() {
		return entryId;
	}

	public void setEntryId(Integer entryId) {
		this.entryId = entryId;
	}

	
	
	 
	 

}
