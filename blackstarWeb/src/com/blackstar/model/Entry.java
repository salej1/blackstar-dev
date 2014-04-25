package com.blackstar.model;

import java.io.Serializable;

public class Entry implements Serializable
{
	private static final long serialVersionUID = 1L;
	private int entryId;
	private String type;
	private String typeProject;
	private String reference;
	private String description;
	private Double amount;
	private Double unitPrice;
	private int discount;
	private Double total;
	private String observations;
	private Short serviceTypeId;
	
	public int getEntryId() {
		return entryId;
	}
	public void setEntryId(int entryId) {
		this.entryId = entryId;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getReference() {
		return reference;
	}
	public void setReference(String reference) {
		this.reference = reference;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Double getAmount() {
		return amount;
	}
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	public Double getUnitPrice() {
		return unitPrice;
	}
	public void setUnitPrice(Double unitPrice) {
		this.unitPrice = unitPrice;
	}
	public int getDiscount() {
		return discount;
	}
	public void setDiscount(int discount) {
		this.discount = discount;
	}
	public Double getTotal() {
		return total;
	}
	public void setTotal(Double total) {
		this.total = total;
	}
	public String getObservations() {
		return observations;
	}
	public void setObservations(String observations) {
		this.observations = observations;
	}
	public String getTypeProject() {
		return typeProject;
	}
	public void setTypeProject(String typeProject) {
		this.typeProject = typeProject;
	}
	public Short getServiceTypeId() {
		return serviceTypeId;
	}
	public void setServiceTypeId(Short serviceTypeId) {
		this.serviceTypeId = serviceTypeId;
	}
	
	

}
