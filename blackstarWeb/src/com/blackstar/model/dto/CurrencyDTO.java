package com.blackstar.model.dto;

import java.io.Serializable;

public class CurrencyDTO implements Serializable {
	private static final long serialVersionUID = -7350308791188154192L;

	private String currencyId;
	private String pluralName;
	private String singularName;

	public CurrencyDTO() {
	}

	public String getCurrencyId() {
		return currencyId;
	}

	public void setCurrencyId(String currencyId) {
		this.currencyId = currencyId;
	}

	public String getPluralName() {
		return pluralName;
	}

	public String getSingularName() {
		return singularName;
	}

	public void setPluralName(String pluralName) {
		this.pluralName = pluralName;
	}

	public void setSingularName(String singularName) {
		this.singularName = singularName;
	}
}
