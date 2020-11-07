/*
 Entity:Customer
 Author:Pichardo
 Date:18/02/2014
 */
package com.blackstar.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "customer",catalog = "blackstarDb")
public class Customer implements Serializable
{
	private static final long serialVersionUID = 1L;
	private int customerId;
	private String customerType;
	private String rfc;
	private String companyName;
	private String tradeName;
	private String phoneCode1;
	private String phoneCode2;
	private String phone1;
	private String phone2;
	private String extension1;
	private String extension2;
	private String email1;
	private String email2;
	private String street;
	private String externalNumber;
	private String internalNumber;
	private String colony;
	private String town;
	private String country;
	private String postcode;
	private Double advance;
	private String timeLimit;
	private String settlementTimeLimit;
	private String curp;
	private String contactPerson;
	private Double retention;
	private int cityId;
	private int paymentTermsId;
	private String currencyId;
	private int ivaId;
	private int classificationId;
	private int originId;
	private int seller;
	
	
	public Customer() {
		super();
	}
	public int getCustomerId() {
		return customerId;
	}
	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}
	public String getCustomerType() {
		return customerType;
	}
	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}
	public String getRfc() {
		return rfc;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public String getTradeName() {
		return tradeName;
	}
	public void setTradeName(String tradeName) {
		this.tradeName = tradeName;
	}
	public String getPhoneCode1() {
		return phoneCode1;
	}
	public void setPhoneCode1(String phoneCode1) {
		this.phoneCode1 = phoneCode1;
	}
	public String getPhoneCode2() {
		return phoneCode2;
	}
	public void setPhoneCode2(String phoneCode2) {
		this.phoneCode2 = phoneCode2;
	}
	public String getPhone1() {
		return phone1;
	}
	public void setPhone1(String phone1) {
		this.phone1 = phone1;
	}
	public String getPhone2() {
		return phone2;
	}
	public void setPhone2(String phone2) {
		this.phone2 = phone2;
	}
	public String getExtension1() {
		return extension1;
	}
	public void setExtension1(String extension1) {
		this.extension1 = extension1;
	}
	public String getExtension2() {
		return extension2;
	}
	public void setExtension2(String extension2) {
		this.extension2 = extension2;
	}
	public String getEmail1() {
		return email1;
	}
	public void setEmail1(String email1) {
		this.email1 = email1;
	}
	public String getEmail2() {
		return email2;
	}
	public void setEmail2(String email2) {
		this.email2 = email2;
	}
	public String getStreet() {
		return street;
	}
	public void setStreet(String street) {
		this.street = street;
	}
	public String getExternalNumber() {
		return externalNumber;
	}
	public void setExternalNumber(String externalNumber) {
		this.externalNumber = externalNumber;
	}
	public String getInternalNumber() {
		return internalNumber;
	}
	public void setInternalNumber(String internalNumber) {
		this.internalNumber = internalNumber;
	}
	public String getColony() {
		return colony;
	}
	public void setColony(String colony) {
		this.colony = colony;
	}
	public String getTown() {
		return town;
	}
	public void setTown(String town) {
		this.town = town;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public String getPostcode() {
		return postcode;
	}
	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}
	public Double getAdvance() {
		return advance;
	}
	public void setAdvance(Double advance) {
		this.advance = advance;
	}
	public String getTimeLimit() {
		return timeLimit;
	}
	public void setTimeLimit(String timeLimit) {
		this.timeLimit = timeLimit;
	}
	public String getSettlementTimeLimit() {
		return settlementTimeLimit;
	}
	public void setSettlementTimeLimit(String settlementTimeLimit) {
		this.settlementTimeLimit = settlementTimeLimit;
	}
	public String getCurp() {
		return curp;
	}
	public void setCurp(String curp) {
		this.curp = curp;
	}
	public String getContactPerson() {
		return contactPerson;
	}
	public void setContactPerson(String contactPerson) {
		this.contactPerson = contactPerson;
	}
	public Double getRetention() {
		return retention;
	}
	public void setRetention(Double retention) {
		this.retention = retention;
	}
	public int getCityId() {
		return cityId;
	}
	public void setCityId(int cityId) {
		this.cityId = cityId;
	}
	public int getPaymentTermsId() {
		return paymentTermsId;
	}
	public void setPaymentTermsId(int paymentTermsId) {
		this.paymentTermsId = paymentTermsId;
	}
	public String getCurrencyId() {
		return currencyId;
	}
	public void setCurrencyId(String currencyId) {
		this.currencyId = currencyId;
	}
	public int getIvaId() {
		return ivaId;
	}
	public void setIvaId(int ivaId) {
		this.ivaId = ivaId;
	}
	public int getClassificationId() {
		return classificationId;
	}
	public void setClassificationId(int classificationId) {
		this.classificationId = classificationId;
	}
	public int getOriginId() {
		return originId;
	}
	public void setOriginId(int originId) {
		this.originId = originId;
	}
	public int getSeller() {
		return seller;
	}
	public void setSeller(int seller) {
		this.seller = seller;
	}

}
