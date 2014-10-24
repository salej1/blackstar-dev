package com.codex.vo;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.codex.model.CurrencyType;
import com.codex.model.dto.CstDTO;

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
	private Double productsNumber;
	private Double financesNumber;
	private Double servicesNumber;
	private Double discountNumber;
	private Double totalProjectNumber; 
	private List<ProjectEntryVO> entries = new ArrayList<ProjectEntryVO>();
	private String strEntries;
	private DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
	private String createdBy;
	private Integer createdByUsr;
	private Date modified;
	private String modifiedBy;
	private Integer modifiedByUsr;
	private String cstName;
	private String cstPhone;
	private String cstPhoneExt;
	private String cstMobile;
	private String cstEmail;
	private Integer cstAutoAuth;
	
	public ProjectVO(){
		
	}
	
	public ProjectVO(CstDTO cst) {
		super();
		this.cstName = cst.getName();
		this.cstPhone = cst.getPhone();
		this.cstPhoneExt = cst.getPhoneExt();
		this.cstMobile = cst.getMobile();
		this.cstEmail = cst.getEmail();
		this.cstAutoAuth = cst.getAutoAuthProjects();
	}
	
	public String getCurrencyCode(){
		if(this.currencyTypeId == CurrencyType.USD){
			return "USD";
		}
		else if(this.currencyTypeId == CurrencyType.MXN){
			return "MXN";
		}
		else return "";
	}
		
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
	public String getCstNane() {
		return cstName;
	}
	public void setCstNane(String cstNane) {
		this.cstName = cstNane;
	}
	public String getCstPhone() {
		return cstPhone;
	}
	public void setCstPhone(String cstPhone) {
		this.cstPhone = cstPhone;
	}
	public String getCstEmail() {
		return cstEmail;
	}
	public void setCstEmail(String cstEmail) {
		this.cstEmail = cstEmail;
	}
	public String getCstName() {
		return cstName;
	}
	public void setCstName(String cstName) {
		this.cstName = cstName;
	}
	public Integer getCstAutoAuth() {
		return cstAutoAuth;
	}
	public void setCstAutoAuth(Integer cstAutoAuth) {
		this.cstAutoAuth = cstAutoAuth;
	}
	public String getCstPhoneExt() {
		return cstPhoneExt;
	}
	public void setCstPhoneExt(String cstPhoneExt) {
		this.cstPhoneExt = cstPhoneExt;
	}
	public String getCstMobile() {
		return cstMobile;
	}
	public void setCstMobile(String cstMobile) {
		this.cstMobile = cstMobile;
	}

	public Double getDiscountNumber() {
		return discountNumber;
	}

	public void setDiscountNumber(Double discountNumber) {
		this.discountNumber = discountNumber;
	}
	
}
