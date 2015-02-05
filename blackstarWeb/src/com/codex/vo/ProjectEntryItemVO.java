package com.codex.vo;

public class ProjectEntryItemVO {
	
	private Integer id;
	private Integer entryId;
	private Integer itemTypeId;
	private String itemTypeDescription;
	private String reference;
	private String description;
	private Integer quantity;
	private Float priceByUnit;
	private Float discount;
	private Float totalPrice;
	private String comments;
	
	
	public ProjectEntryItemVO (){
		
	}
	
	public ProjectEntryItemVO(Integer id, Integer entryId, Integer itemTypeId
			, String itemTypeDescription, String reference, String description
			, Integer quantity, Float priceByUnit, Float discount, Float totalPrice
			, String comments){
		this.id = id;
		this.entryId = entryId;
		this.itemTypeId = itemTypeId;
		this.itemTypeDescription = itemTypeDescription;
		this.reference = reference;
		this.description = description;
		this.quantity = quantity;
		this.priceByUnit = priceByUnit;
		this.discount = discount;
		this.totalPrice = totalPrice;
		this.comments = comments;
	}
	
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
	public String getReference() {
		return reference;
	}
	public void setReference(String reference) {
		this.reference = reference;
	}
	public String getDescription() {
		if(description != null){
			return description.replace("'", "\\'");
		}
		else{
			return description;
		}
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
	public String getCommentsDisplay() {
		return comments.replace("\r\n", "\\r\\n");
	}
	public void setComments(String comments) {
		this.comments = comments;
	}
	public String getItemTypeDescription() {
		return itemTypeDescription;
	}
	public void setItemTypeDescription(String itemTypeDescription) {
		this.itemTypeDescription = itemTypeDescription;
	}

}
