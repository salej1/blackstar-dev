package com.codex.vo;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
	private String statusDescription;
	private String clientDescription;
	private String costCenter;
	private Float changeType;
	private Date created;
	private String contactName;
	private String location;
	private Float advance;
	private Integer timeLimit;
	private Integer settlementTimeLimit;
	private Integer deliveryTime;
	private String incoterm;
	private Integer productsNumber;
	private Integer financesNumber;
	private Integer servicesNumber;
	private Integer totalProjectNumber; 
	private List<ProjectEntryVO> entries = new ArrayList<ProjectEntryVO>();
	private String strEntries;
	private DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
	private String createdBy;
	private Integer createdByUsr;
	private Date modified;
	private String modifiedBy;
	private Integer modifiedByUsr;
	
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
	  try {
		  this.created = formatter.parse(formatter.format(created));
	  } catch (ParseException e) {
		  System.out.println("Unparsable date error: " + e);
		  this.created = created;
	  }
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
	public String getIncoterm() {
		return incoterm;
	}
	public void setIncoterm(String incoterm) {
		this.incoterm = incoterm;
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
	public String getStatusDescription() {
		return statusDescription;
	}
	public void setStatusDescription(String statusDescription) {
		this.statusDescription = statusDescription;
	}
	public String getClientDescription() {
		return clientDescription;
	}
	public void setClientDescription(String clientDescription) {
		this.clientDescription = clientDescription;
	}
	public String getStrEntries() {
		return strEntries;
	}
	public void setStrEntries(String strEntries) {
		this.strEntries = strEntries;
	}
	public DateFormat getFormatter() {
		return formatter;
	}
	public void setFormatter(DateFormat formatter) {
		this.formatter = formatter;
	}
	public String getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}
	public Integer getCreatedByUsr() {
		return createdByUsr;
	}
	public void setCreatedByUsr(Integer createdByUsr) {
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
	public Integer getModifiedByUsr() {
		return modifiedByUsr;
	}
	public void setModifiedByUsr(Integer modifiedByUsr) {
		this.modifiedByUsr = modifiedByUsr;
	}
	
}
