package com.codex.model.dto;

public class CostCenterDTO {
	private int _id;
	private String costCenter;

	public CostCenterDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	public CostCenterDTO(int _id, String costCenter) {
		super();
		this._id = _id;
		this.costCenter = costCenter;
	}
	public int get_id() {
		return _id;
	}
	public void set_id(int _id) {
		this._id = _id;
	}
	public String getCostCenter() {
		return costCenter;
	}
	public void setCostCenter(String costCenter) {
		this.costCenter = costCenter;
	}
}
