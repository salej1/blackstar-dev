package com.blackstar.model;

public class UpsServiceParams {
	
	public UpsServiceParams(Integer upsServiceParamsId, Integer upsServiceId,
			String inputVoltagePhase, String inputVoltageNeutro,
			String inputVoltageNeutroGround, String percentCharge,
			String outputVoltagePhase, String outputVoltageNeutro,
			String inOutFrecuency, String busVoltage) {
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
	private String inputVoltagePhase;
	private String inputVoltageNeutro;
	private String inputVoltageNeutroGround;
	private String percentCharge;
	private String outputVoltagePhase;
	private String outputVoltageNeutro;
	private String inOutFrecuency;
	private String busVoltage;
	
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
	public String getInputVoltagePhase() {
		return inputVoltagePhase;
	}
	public void setInputVoltagePhase(String inputVoltagePhase) {
		this.inputVoltagePhase = inputVoltagePhase;
	}
	public String getInputVoltageNeutro() {
		return inputVoltageNeutro;
	}
	public void setInputVoltageNeutro(String inputVoltageNeutro) {
		this.inputVoltageNeutro = inputVoltageNeutro;
	}
	public String getInputVoltageNeutroGround() {
		return inputVoltageNeutroGround;
	}
	public void setInputVoltageNeutroGround(String inputVoltageNeutroGround) {
		this.inputVoltageNeutroGround = inputVoltageNeutroGround;
	}
	public String getPercentCharge() {
		return percentCharge;
	}
	public void setPercentCharge(String percentCharge) {
		this.percentCharge = percentCharge;
	}
	public String getOutputVoltagePhase() {
		return outputVoltagePhase;
	}
	public void setOutputVoltagePhase(String outputVoltagePhase) {
		this.outputVoltagePhase = outputVoltagePhase;
	}
	public String getOutputVoltageNeutro() {
		return outputVoltageNeutro;
	}
	public void setOutputVoltageNeutro(String outputVoltageNeutro) {
		this.outputVoltageNeutro = outputVoltageNeutro;
	}
	public String getInOutFrecuency() {
		return inOutFrecuency;
	}
	public void setInOutFrecuency(String inOutFrecuency) {
		this.inOutFrecuency = inOutFrecuency;
	}
	public String getBusVoltage() {
		return busVoltage;
	}
	public void setBusVoltage(String busVoltage) {
		this.busVoltage = busVoltage;
	}
	
	
}
