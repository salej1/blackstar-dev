package com.blackstar.model.dto;

import java.io.Serializable;

public class IVADTO implements Serializable {
	private static final long serialVersionUID = -7350308791188154192L;

	private Integer ivaId;
	private Double percentage;

	public IVADTO() {
	}

	public Integer getIvaId() {
		return ivaId;
	}

	public void setIvaId(Integer ivaId) {
		this.ivaId = ivaId;
	}

	public Double getPercentage() {
		return percentage;
	}

	public void setPercentage(Double percentage) {
		this.percentage = percentage;
	}
}
