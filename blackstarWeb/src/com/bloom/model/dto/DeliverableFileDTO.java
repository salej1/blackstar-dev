package com.bloom.model.dto;

public class DeliverableFileDTO {
	
  private Integer id;
  private String name;
  private boolean delivered;
  
  public Integer getId() {
	return id;
  }
  public void setId(Integer id) {
	this.id = id;
  }
  public String getName() {
	return name;
  }
  public void setName(String name) {
	this.name = name;
  }
  public boolean isDelivered() {
	return delivered;
  }
  public void setDelivered(boolean delivered) {
	this.delivered = delivered;
  }
  
  public void setDelivered(Integer delivered) {
	this.delivered = delivered == 1 ? true :  false;
  }

}
