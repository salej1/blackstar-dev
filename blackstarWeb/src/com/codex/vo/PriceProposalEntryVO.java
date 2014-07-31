package com.codex.vo;

import java.util.ArrayList;
import java.util.List;

public class PriceProposalEntryVO {
	
  private Integer id;
  private Integer priceProposalId;
  private Integer entryTypeId;
  private String description;
  private Float discount;
  private Float totalPrice;
  private String comments;
  private List<PriceProposalItemVO> items = new ArrayList<PriceProposalItemVO>();
  
  public Integer getId() {
	return id;
  }
  public void setId(Integer id) {
	this.id = id;
  } 
  public Integer getPriceProposalId() {
	return priceProposalId;
  }
  public void setPriceProposalId(Integer priceProposalId) {
	this.priceProposalId = priceProposalId;
  }
  public Integer getEntryTypeId() {
	return entryTypeId;
  }
  public void setEntryTypeId(Integer entryTypeId) {
	this.entryTypeId = entryTypeId;
  }
  public String getDescription() {
	return description;
  }
  public void setDescription(String description) {
	this.description = description;
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
public List<PriceProposalItemVO> getItems() {
	return items;
}
public void setItems(List<PriceProposalItemVO> items) {
	this.items = items;
}
 
}
