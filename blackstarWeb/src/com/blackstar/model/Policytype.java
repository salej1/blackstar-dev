package com.blackstar.model;

// Generated 19/09/2013 02:56:42 AM by Hibernate Tools 3.4.0.CR1

/**
 * Policytype generated by hbm2java
 */
public class Policytype implements java.io.Serializable {

	private char policyTypeId;
	private String policyType;

	public Policytype() {
	}

	public Policytype(char policyTypeId, String policyType) {
		this.policyTypeId = policyTypeId;
		this.policyType = policyType;
	}

	public char getPolicyTypeId() {
		return this.policyTypeId;
	}

	public void setPolicyTypeId(char policyTypeId) {
		this.policyTypeId = policyTypeId;
	}

	public String getPolicyType() {
		return this.policyType;
	}

	public void setPolicyType(String policyType) {
		this.policyType = policyType;
	}

}
