package com.blackstar.model;

public class BatteryCellService {
	
	public BatteryCellService(Integer bbCellServiceId, Integer bbServiceId,
			Integer cellNumber, String floatVoltage, String chargeVoltage) {
		this.bbCellServiceId = bbCellServiceId;
		this.bbServiceId = bbServiceId;
		this.cellNumber = cellNumber;
		this.floatVoltage = floatVoltage;
		this.chargeVoltage = chargeVoltage;
	}
	
	private Integer bbCellServiceId;
	private Integer bbServiceId;
	private Integer cellNumber;
	private String floatVoltage;
	private String chargeVoltage;
	
	public Integer getBbCellServiceId() {
		return bbCellServiceId;
	}
	public void setBbCellServiceId(Integer bbCellServiceId) {
		this.bbCellServiceId = bbCellServiceId;
	}
	public Integer getBbServiceId() {
		return bbServiceId;
	}
	public void setBbServiceId(Integer bbServiceId) {
		this.bbServiceId = bbServiceId;
	}
	public Integer getCellNumber() {
		return cellNumber;
	}
	public void setCellNumber(Integer cellNumber) {
		this.cellNumber = cellNumber;
	}
	public String getFloatVoltage() {
		return floatVoltage;
	}
	public void setFloatVoltage(String floatVoltage) {
		this.floatVoltage = floatVoltage;
	}
	public String getChargeVoltage() {
		return chargeVoltage;
	}
	public void setChargeVoltage(String chargeVoltage) {
		this.chargeVoltage = chargeVoltage;
	}
	
	
}
