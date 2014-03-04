package com.blackstar.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "warrantProject",catalog = "blackstarDb")
public class WarrantProject implements Serializable
{
	 private static final long serialVersionUID = 1L;
	 private int warrantProjectId;
	 private String status;
	 private int customerId;
	 private String costCenter;
	 private Double exchangeRate;
	 private Date updateDate;
	 private String contactName;
	 private String ubicationProject;
	 private int paymentTermsId;
	 private String deliveryTime;
	 private String intercom;
	 private Double totalProject;
	 private int bonds;
	 private Double totalProductsServices;
	 private int entryId;
	 
	public int getWarrantProjectId() {
		return warrantProjectId;
	}
	public void setWarrantProjectId(int warrantProjectId) {
		this.warrantProjectId = warrantProjectId;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public int getCustomerId() {
		return customerId;
	}
	public void setCustomerId(int customerId) {
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
	public int getPaymentTermsId() {
		return paymentTermsId;
	}
	public void setPaymentTermsId(int paymentTermsId) {
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
	public int getBonds() {
		return bonds;
	}
	public void setBonds(int bonds) {
		this.bonds = bonds;
	}
	public Double getTotalProductsServices() {
		return totalProductsServices;
	}
	public void setTotalProductsServices(Double totalProductsServices) {
		this.totalProductsServices = totalProductsServices;
	}
	public int getEntryId() {
		return entryId;
	}
	public void setEntryId(int entryId) {
		this.entryId = entryId;
	} 
	 
	 

}
