/**
 * 
 */
package com.blackstar.model.dto;

import java.util.Date;

public class PlainServiceDTO {
		
	public PlainServiceDTO(Integer plainServiceId, Integer serviceOrderId,
			String troubleDescription, String techParam, String workDone,
			String materialUsed, String observations) {
		this.plainServiceId = plainServiceId;
		this.serviceOrderId = serviceOrderId;
		this.troubleDescription = troubleDescription;
		this.techParam = techParam;
		this.workDone = workDone;
		this.materialUsed = materialUsed;
		this.observations = observations;
	}
	
	public PlainServiceDTO() {
		// TODO Auto-generated constructor stub
	}

	private Integer plainServiceId;
	private Integer serviceOrderId;
	
	private String troubleDescription;
	private String techParam;
	private String workDone;
	private String materialUsed;
	private String observations;
	
	public Integer getPlainServiceId() {
		return plainServiceId;
	}
	public void setPlainServiceId(Integer plainServiceId) {
		this.plainServiceId = plainServiceId;
	}
	public Integer getServiceOrderId() {
		return serviceOrderId;
	}
	public void setServiceOrderId(Integer serviceOrderId) {
		this.serviceOrderId = serviceOrderId;
	}
	public String getTroubleDescription() {
		return troubleDescription;
	}
	public void setTroubleDescription(String troubleDescription) {
		this.troubleDescription = troubleDescription;
	}
	public String getTechParam() {
		return techParam;
	}
	public void setTechParam(String techParam) {
		this.techParam = techParam;
	}
	public String getWorkDone() {
		return workDone;
	}
	public void setWorkDone(String workDone) {
		this.workDone = workDone;
	}
	public String getMaterialUsed() {
		return materialUsed;
	}
	public void setMaterialUsed(String materialUsed) {
		this.materialUsed = materialUsed;
	}
	public String getObservations() {
		return observations;
	}
	public void setObservations(String observations) {
		this.observations = observations;
	}

}
