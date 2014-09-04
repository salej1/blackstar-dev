package com.codex.vo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class PriceProposalVO {
	
	private Integer id;
	private Integer projectId;
	private Integer clientId;
	private Integer taxesTypeId;
	private Integer paymentTypeId;
	private Integer currencyTypeId;
	private String costCenter;
	private Float changeType;
	private String location;
	private Float advance;
	private Integer timeLimit;
	private Integer settlementTimeLimit;
	private Integer deliveryTime;
	private String incoterm;
	private String contactName;
	private Double productsNumber;
	private Double financesNumber;
	private Double servicesNumber;
	private Double totalProjectNumber;
	private Date created;
	private String priceProposalNumber;
	private List<PriceProposalEntryVO> entries = new ArrayList<PriceProposalEntryVO>();
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getProjectId() {
		return projectId;
	}
	public void setProjectId(Integer projectId) {
		this.projectId = projectId;
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
	public String getIncoterm() {
		return incoterm;
	}
	public void setIncoterm(String incoterm) {
		this.incoterm = incoterm;
	}
	public Double getProductsNumber() {
		return productsNumber;
	}
	public void setProductsNumber(Double productsNumber) {
		this.productsNumber = productsNumber;
	}
	public Double getFinancesNumber() {
		return financesNumber;
	}
	public void setFinancesNumber(Double financesNumber) {
		this.financesNumber = financesNumber;
	}
	public Double getServicesNumber() {
		return servicesNumber;
	}
	public void setServicesNumber(Double servicesNumber) {
		this.servicesNumber = servicesNumber;
	}
	public Double getTotalProjectNumber() {
		return totalProjectNumber;
	}
	public void setTotalProjectNumber(Double totalProjectNumber) {
		this.totalProjectNumber = totalProjectNumber;
	}
	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
	}
	public String getPriceProposalNumber() {
		return priceProposalNumber;
	}
	public void setPriceProposalNumber(String priceProposalNumber) {
		this.priceProposalNumber = priceProposalNumber;
	}
	public String getContactName() {
		return contactName;
	}
	public void setContactName(String contactName) {
		this.contactName = contactName;
	}
	public List<PriceProposalEntryVO> getEntries() {
		return entries;
	}
	public void setEntries(List<PriceProposalEntryVO> entries) {
		this.entries = entries;
	}

}
