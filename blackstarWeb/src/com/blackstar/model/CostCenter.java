package com.blackstar.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "costcenter", catalog = "blackstarDb")
public class CostCenter implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String costCenterId;
	private String officeId;

	public CostCenter() {
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
