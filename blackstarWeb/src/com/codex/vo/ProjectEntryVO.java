package com.codex.vo;

import java.util.ArrayList;
import java.util.List;

public class ProjectEntryVO {
	
	private Integer id;
	private Integer projectId;
	private Integer entryTypeId;
	private String entryTypeDescription;
	private String description;
	private Float discount;
	private Float totalPrice;
	private String comments;
	private List<ProjectEntryItemVO> items = new ArrayList<ProjectEntryItemVO>();
	
	
	public ProjectEntryVO (){
		
	}

    public ProjectEntryVO (Integer id, Integer projectId, Integer entryTypeId
    		   , String entryTypeDescription, String description, Float discount
    		                               , Float totalPrice, String comments){
		this.id = id;
		this.projectId = projectId;
		this.entryTypeId = entryTypeId;
		this. entryTypeDescription = entryTypeDescription;
		this.description = description;
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
	public Integer getProjectId() {
		return projectId;
	}
	public void setProjectId(Integer projectId) {
		this.projectId = projectId;
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
	public List<ProjectEntryItemVO> getItems() {
		return items;
	}
	public void setItems(List<ProjectEntryItemVO> items) {
		this.items = items;
	}
	public String getEntryTypeDescription() {
		return entryTypeDescription;
	}
	public void setEntryTypeDescription(String entryTypeDescription) {
		this.entryTypeDescription = entryTypeDescription;
	}

}
