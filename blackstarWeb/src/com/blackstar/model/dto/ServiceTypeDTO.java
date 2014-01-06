package com.blackstar.model.dto;

public class ServiceTypeDTO {
	private Character serviceTypeId;
	private String serviceType;
	
	public ServiceTypeDTO(){
		
	}
	
	public ServiceTypeDTO(Character serviceTypeId, String serviceType){
		this.serviceTypeId = serviceTypeId;
		this.serviceType = serviceType;
	}
	public Character getServiceTypeId() {
		return serviceTypeId;
	}
	public void setServiceTypeId(Character serviceTypeId) {
		this.serviceTypeId = serviceTypeId;
	}
	public String getServiceType() {
		return serviceType;
	}
	public void setServiceType(String serviceType) {
		this.serviceType = serviceType;
	}
}
