package com.blackstar.model.dto;

import java.io.Serializable;

public class PaymentTermsDTO implements Serializable
{
	private static final long serialVersionUID = -7350308791188154192L;

	private Integer paymentTermsId;
	private String name;

	public PaymentTermsDTO()
	{
	}

	public Integer getPaymentTermsId() {
		return paymentTermsId;
	}
	
	public void setPaymentTermsId(Integer paymentTermsId) {
		this.paymentTermsId = paymentTermsId;
	}

	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
}
