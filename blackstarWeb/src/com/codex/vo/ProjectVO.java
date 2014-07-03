package com.codex.vo;

import java.util.Date;
import java.util.List;

public class ProjectVO {

	
	private Integer id;
	private String projectNumber;
	private Integer clientId;
	private Integer taxesTypeId;
	private Integer statusId;
	private Integer paymentTypeId;
	private Integer currencyTypeId;
	private String costCenter;
	private Float changeType;
	private Date created;
	private String contactName;
	private String location;
	private Float advance;
	private Integer timeLimit;
	private Integer settlementTimeLimit;
	private Integer deliveryTime;
	private String intercom;
	private Integer productsNumber;
	private Integer financesNumber;
	private Integer servicesNumber;
	private Integer totalProjectNumber; 
	private List<ProjectEntryVO> entries;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getProjectNumber() {
		return projectNumber;
	}
	public void setProjectNumber(String projectNumber) {
		this.projectNumber = projectNumber;
	}
	public Integer getClientId() {
		return clientId;
	}
	public void setClientId(Integer clientId) {
		this.clientId = clientId;
	}
	public Integer getTaxesTypeId() {
		return taxesTypeId;
	}
	public void setTaxesTypeId(Integer taxesTypeId) {
		this.taxesTypeId = taxesTypeId;
	}
	public Integer getStatusId() {
		return statusId;
	}
	public void setStatusId(Integer statusId) {
		this.statusId = statusId;
	}
	public Integer getPaymentTypeId() {
		return paymentTypeId;
	}
	public void setPaymentTypeId(Integer paymentTypeId) {
		this.paymentTypeId = paymentTypeId;
	}
	public Integer getCurrencyTypeId() {
		return currencyTypeId;
	}
	public void setCurrencyTypeId(Integer currencyTypeId) {
		this.currencyTypeId = currencyTypeId;
	}
	public String getCostCenter() {
		return costCenter;
	}
	public void setCostCenter(String costCenter) {
		this.costCenter = costCenter;
	}
	public Float getChangeType() {
		return changeType;
	}
	public void setChangeType(Float changeType) {
		this.changeType = changeType;
	}
	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
	}
	public String getContactName() {
		return contactName;
	}
	public void setContactName(String contactName) {
		this.contactName = contactName;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public Float getAdvance() {
		return advance;
	}
	public void setAdvance(Float advance) {
		this.advance = advance;
	}
	public Integer getTimeLimit() {
		return timeLimit;
	}
	public void setTimeLimit(Integer timeLimit) {
		this.timeLimit = timeLimit;
	}
	public Integer getSettlementTimeLimit() {
		return settlementTimeLimit;
	}
	public void setSettlementTimeLimit(Integer settlementTimeLimit) {
		this.settlementTimeLimit = settlementTimeLimit;
	}
	public Integer getDeliveryTime() {
		return deliveryTime;
	}
	public void setDeliveryTime(Integer deliveryTime) {
		this.deliveryTime = deliveryTime;
	}
	public String getIntercom() {
		return intercom;
	}
	public void setIntercom(String intercom) {
		this.intercom = intercom;
	}
	public Integer getProductsNumber() {
		return productsNumber;
	}
	public void setProductsNumber(Integer productsNumber) {
		this.productsNumber = productsNumber;
	}
	public Integer getFinancesNumber() {
		return financesNumber;
	}
	public void setFinancesNumber(Integer financesNumber) {
		this.financesNumber = financesNumber;
	}
	public Integer getServicesNumber() {
		return servicesNumber;
	}
	public void setServicesNumber(Integer servicesNumber) {
		this.servicesNumber = servicesNumber;
	}
	public Integer getTotalProjectNumber() {
		return totalProjectNumber;
	}
	public void setTotalProjectNumber(Integer totalProjectNumber) {
		this.totalProjectNumber = totalProjectNumber;
	}
	public List<ProjectEntryVO> getEntries() {
		return entries;
	}
	public void setEntries(List<ProjectEntryVO> entries) {
		this.entries = entries;
	}
	
}
