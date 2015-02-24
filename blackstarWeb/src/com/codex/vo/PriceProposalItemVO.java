package com.codex.vo;

public class PriceProposalItemVO {
	
  private Integer id;
  private Integer priceProposalEntryId;
  private Integer itemTypeId;
  private String reference;
  private String description;
  private Float quantity;
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
  public Integer getPriceProposalEntryId() {
	return priceProposalEntryId;
  }
  public void setPriceProposalEntryId(Integer priceProposalEntryId) {
	this.priceProposalEntryId = priceProposalEntryId;
  }
  public Integer getItemTypeId() {
	return itemTypeId;
  }
  public void setItemTypeId(Integer itemTypeId) {
	this.itemTypeId = itemTypeId;
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
  public Float getQuantity() {
	return quantity;
  }
  public void setQuantity(Float quantity) {
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
