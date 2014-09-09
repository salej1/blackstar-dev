package com.blackstar.model;

public class ServiceCheckOption {
	String value;
	String label;
		
	public ServiceCheckOption(String value, String label) {
		super();
		this.value = value;
		this.label = label;
	}
	
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}
}
