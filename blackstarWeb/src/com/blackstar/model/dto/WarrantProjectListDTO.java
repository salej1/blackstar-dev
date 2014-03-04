package com.blackstar.model.dto;

import java.io.Serializable;
import java.util.Date;

public class WarrantProjectListDTO implements Serializable 
{
	private static final long serialVersionUID = -6488240101013598468L;
	private Integer warrantProjectId;
	private Date updateDate;
	private String customer;
	private Double totalProject;
	
	

	public String getCustomer() {
		return customer;
	}

	public void setCustomer(String customer) {
		this.customer = customer;
	}

	public Double getTotalProject() {
		return totalProject;
	}

	public void setTotalProject(Double totalProject) {
		this.totalProject = totalProject;
	}

	public WarrantProjectListDTO()
	{
	}


	public Integer getWarrantProjectId() {
		return warrantProjectId;
	}

	public void setWarrantProjectId(Integer warrantProjectId) {
		this.warrantProjectId = warrantProjectId;
	}

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}
}
