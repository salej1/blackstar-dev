package com.blackstar.model;

// Generated 19/09/2013 02:56:42 AM by Hibernate Tools 3.4.0.CR1

/**
 * Equipmenttype generated by hbm2java
 */
public class Equipmenttype implements java.io.Serializable {

	private char equipmentTypeId;
	private String equipmentType;

	public Equipmenttype() {
	}

	public Equipmenttype(char equipmentTypeId, String equipmentType) {
		this.equipmentTypeId = equipmentTypeId;
		this.equipmentType = equipmentType;
	}

	public char getEquipmentTypeId() {
		return this.equipmentTypeId;
	}

	public void setEquipmentTypeId(char equipmentTypeId) {
		this.equipmentTypeId = equipmentTypeId;
	}

	public String getEquipmentType() {
		return this.equipmentType;
	}

	public void setEquipmentType(String equipmentType) {
		this.equipmentType = equipmentType;
	}

}
