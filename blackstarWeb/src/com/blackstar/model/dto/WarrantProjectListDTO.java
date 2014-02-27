package com.blackstar.model.dto;

import java.io.Serializable;
import java.util.Date;

public class WarrantProjectListDTO implements Serializable 
{
	private static final long serialVersionUID = -6488240101013598468L;
	private int warrantProjectId;
	private Date date;
	 
	public WarrantProjectListDTO()
	{
	}

	public int getWarrantProjectId() {
		return warrantProjectId;
	}

	public void setWarrantProjectId(int warrantProjectId) {
		this.warrantProjectId = warrantProjectId;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}
	
	
	 

}
