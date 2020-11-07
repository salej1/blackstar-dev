package com.blackstar.model.dto;

public class CustomerDTO {
	private Double advance;
	private Double retention;
	private Integer cityId;
	private Integer classificationId;
	private Integer customerId;
	private Integer governmentId;
	private Integer ivaId;
	private Integer originId;
	private Integer paymentTermsId;
	private Integer seller;
	private String colony;
	private String companyName;
	private String contactPerson;
	private String country;
	private String curp;
	private String currencyId;
	private String customerType;
	private String email1;
	private String email2;
	private String extension1;
	private String extension2;
	private String externalNumber;
	private String internalNumber;
	private String phone1;
	private String phone2;
	private String phoneCode1;
	private String phoneCode2;
	private String postcode;
	private String rfc;
	private String settlementTimeLimit;
	private String street;
	private String timeLimit;
	private String town;
	private String tradeName;

	public CustomerDTO() {
	}

	public CustomerDTO(String customerType, String rfc, String companyName,
			String tradeName, String phoneCode1, String phoneCode2,
			String phone1, String phone2, String extension1, String extension2,
			String email1, String email2, String street, String externalNumber,
			String internalNumber, String colony, String town, String country,
			String postcode, Double advance, String timeLimit,
			String settlementTimeLimit, String curp, String contactPerson,
			Double retention, Integer cityId, Integer paymentTermsId,
			String currencyId, Integer ivaId, Integer classificationId,
			Integer originId, Integer seller) {
		super();
		this.customerType = customerType;
		this.rfc = rfc;
		this.companyName = companyName;
		this.tradeName = tradeName;
		this.phoneCode1 = phoneCode1;
		this.phoneCode2 = phoneCode2;
		this.phone1 = phone1;
		this.phone2 = phone2;
		this.extension1 = extension1;
		this.extension2 = extension2;
		this.email1 = email1;
		this.email2 = email2;
		this.street = street;
		this.externalNumber = externalNumber;
		this.internalNumber = internalNumber;
		this.colony = colony;
		this.town = town;
		this.country = country;
		this.postcode = postcode;
		this.advance = advance;
		this.timeLimit = timeLimit;
		this.settlementTimeLimit = settlementTimeLimit;
		this.curp = curp;
		this.contactPerson = contactPerson;
		this.retention = retention;
		this.cityId = cityId;
		this.paymentTermsId = paymentTermsId;
		this.currencyId = currencyId;
		this.ivaId = ivaId;
		this.classificationId = classificationId;
		this.originId = originId;
		this.seller = seller;
	}

	public Integer getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Integer customerId) {
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

	public Integer getCityId() {
		return cityId;
	}

	public void setCityId(Integer cityId) {
		this.cityId = cityId;
	}

	public Integer getPaymentTermsId() {
		return paymentTermsId;
	}

	public void setPaymentTermsId(Integer paymentTermsId) {
		this.paymentTermsId = paymentTermsId;
	}

	public String getCurrencyId() {
		return currencyId;
	}

	public void setCurrencyId(String currencyId) {
		this.currencyId = currencyId;
	}

	public Integer getIvaId() {
		return ivaId;
	}

	public void setIvaId(Integer ivaId) {
		this.ivaId = ivaId;
	}

	public Integer getClassificationId() {
		return classificationId;
	}

	public void setClassificationId(Integer classificationId) {
		this.classificationId = classificationId;
	}

	public Integer getOriginId() {
		return originId;
	}

	public void setOriginId(Integer originId) {
		this.originId = originId;
	}

	public Integer getSeller() {
		return seller;
	}

	public void setSeller(Integer seller) {
		this.seller = seller;
	}

	public Integer getGovernmentId() {
		return governmentId;
	}

	public void setGovernmentId(Integer governmentId) {
		this.governmentId = governmentId;
	}
}
