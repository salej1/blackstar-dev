package com.blackstar.model.dto;

import java.io.Serializable;

public class CustomerListDTO implements Serializable
{
	private static final long serialVersionUID = 2137363773585926710L;

	private Integer customerId;
	private String city;
	private String companyName;
	private String contactEmail;
	private String contactPerson;

	public CustomerListDTO()
	{
	}

	public Integer getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getCity() {
		return city;
	}
	
	public void setCity(String city) {
		this.city = city;
	}
	
	public String getContactEmail() {
		return contactEmail;
	}
	
	public void setContactEmail(String contactEmail) {
		this.contactEmail = contactEmail;
	}
	
	public String getContactPerson() {
		return contactPerson;
	}
	
	public void setContactPerson(String contactPerson) {
		this.contactPerson = contactPerson;
	}
}
