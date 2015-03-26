package com.blackstar.model.dto;

import java.io.Serializable;

public class CostCenterDTO implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String costCenterId;
	private String officeId;
	
	public CostCenterDTO() {
	}

	public String getCostCenterId() {
		return costCenterId;
	}

	public void setCostCenterId(String costCenterId) {
		this.costCenterId = costCenterId;
	}

	public String getOfficeId() {
		return officeId;
	}

	public void setOfficeId(String officeId) {
		this.officeId = officeId;
	}

}
