package com.codex.vo;

public class ProjectEntryItemVO {
	
	private Integer id;
	private Integer entryId;
	private Integer itemTypeId;
	private String reference;
	private String description;
	private Integer quantity;
	private Float priceByUnit;
	private Float discount;
	private Float totalPrice;
	private String comments;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getEntryId() {
		return entryId;
	}
	public void setEntryId(Integer entryId) {
		this.entryId = entryId;
	}
	public Integer getItemTypeId() {
		return itemTypeId;
	}
	public void setItemTypeId(Integer itemTypeId) {
		this.itemTypeId = itemTypeId;
	}
	public String getReferenceId() {
		return reference;
	}
	public void setReferenceId(String reference) {
		this.reference = reference;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Integer getQuantity() {
		return quantity;
	}
	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}
	public Float getPriceByUnit() {
		return priceByUnit;
	}
	public void setPriceByUnit(Float priceByUnit) {
		this.priceByUnit = priceByUnit;
	}
	public Float getDiscount() {
		return discount;
	}
	public void setDiscount(Float discount) {
		this.discount = discount;
	}
	public Float getTotalPrice() {
		return totalPrice;
	}
	public void setTotalPrice(Float totalPrice) {
		this.totalPrice = totalPrice;
	}
	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}

}
