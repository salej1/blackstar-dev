package com.blackstar.model;

public class UpsServiceParams {
	
	public UpsServiceParams(Integer upsServiceParamsId, Integer upsServiceId,
			Double inputVoltagePhase, Double inputVoltageNeutro,
			Double inputVoltageNeutroGround, Double percentCharge,
			Double outputVoltagePhase, Double outputVoltageNeutro,
			Double inOutFrecuency, Double busVoltage) {
		this.upsServiceParamsId = upsServiceParamsId;
		this.upsServiceId = upsServiceId;
		this.inputVoltagePhase = inputVoltagePhase;
		this.inputVoltageNeutro = inputVoltageNeutro;
		this.inputVoltageNeutroGround = inputVoltageNeutroGround;
		this.percentCharge = percentCharge;
		this.outputVoltagePhase = outputVoltagePhase;
		this.outputVoltageNeutro = outputVoltageNeutro;
		this.inOutFrecuency = inOutFrecuency;
		this.busVoltage = busVoltage;
	}
	
	private Integer upsServiceParamsId;
	private Integer upsServiceId;
	private Double inputVoltagePhase;
	private Double inputVoltageNeutro;
	private Double inputVoltageNeutroGround;
	private Double percentCharge;
	private Double outputVoltagePhase;
	private Double outputVoltageNeutro;
	private Double inOutFrecuency;
	private Double busVoltage;
	
	public Integer getUpsServiceParamsId() {
		return upsServiceParamsId;
	}
	public void setUpsServiceParamsId(Integer upsServiceParamsId) {
		this.upsServiceParamsId = upsServiceParamsId;
	}
	public Integer getUpsServiceId() {
		return upsServiceId;
	}
	public void setUpsServiceId(Integer upsServiceId) {
		this.upsServiceId = upsServiceId;
	}
	public Double getInputVoltagePhase() {
		return inputVoltagePhase;
	}
	public void setInputVoltagePhase(Double inputVoltagePhase) {
		this.inputVoltagePhase = inputVoltagePhase;
	}
	public Double getInputVoltageNeutro() {
		return inputVoltageNeutro;
	}
	public void setInputVoltageNeutro(Double inputVoltageNeutro) {
		this.inputVoltageNeutro = inputVoltageNeutro;
	}
	public Double getInputVoltageNeutroGround() {
		return inputVoltageNeutroGround;
	}
	public void setInputVoltageNeutroGround(Double inputVoltageNeutroGround) {
		this.inputVoltageNeutroGround = inputVoltageNeutroGround;
	}
	public Double getPercentCharge() {
		return percentCharge;
	}
	public void setPercentCharge(Double percentCharge) {
		this.percentCharge = percentCharge;
	}
	public Double getOutputVoltagePhase() {
		return outputVoltagePhase;
	}
	public void setOutputVoltagePhase(Double outputVoltagePhase) {
		this.outputVoltagePhase = outputVoltagePhase;
	}
	public Double getOutputVoltageNeutro() {
		return outputVoltageNeutro;
	}
	public void setOutputVoltageNeutro(Double outputVoltageNeutro) {
		this.outputVoltageNeutro = outputVoltageNeutro;
	}
	public Double getInOutFrecuency() {
		return inOutFrecuency;
	}
	public void setInOutFrecuency(Double inOutFrecuency) {
		this.inOutFrecuency = inOutFrecuency;
	}
	public Double getBusVoltage() {
		return busVoltage;
	}
	public void setBusVoltage(Double busVoltage) {
		this.busVoltage = busVoltage;
	}
	
	

}
