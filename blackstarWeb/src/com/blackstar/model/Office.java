package com.blackstar.model;

// Generated 19/09/2013 02:56:42 AM by Hibernate Tools 3.4.0.CR1

/**
 * Office generated by hbm2java
 */
public class Office implements java.io.Serializable {

	private char officeId;
	private String officeName;

	public Office() {
	}

	public Office(char officeId) {
		this.officeId = officeId;
	}

	public Office(char officeId, String officeName) {
		this.officeId = officeId;
		this.officeName = officeName;
	}

	public char getOfficeId() {
		return this.officeId;
	}

	public void setOfficeId(char officeId) {
		this.officeId = officeId;
	}

	public String getOfficeName() {
		return this.officeName;
	}

	public void setOfficeName(String officeName) {
		this.officeName = officeName;
	}

}
