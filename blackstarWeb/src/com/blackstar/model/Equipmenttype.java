package com.blackstar.model;

// Generated Sep 23, 2013 12:57:18 AM by Hibernate Tools 3.4.0.CR1

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Equipmenttype generated by hbm2java
 */
@Entity
@Table(name = "equipmenttype", catalog = "blackstarDb")
public class Equipmenttype implements java.io.Serializable {

	private char equipmentTypeId;
	private String equipmentType;

	public Equipmenttype() {
	}

	public Equipmenttype(char equipmentTypeId, String equipmentType) {
		this.equipmentTypeId = equipmentTypeId;
		this.equipmentType = equipmentType;
	}

	@Id
	@Column(name = "equipmentTypeId", unique = true, nullable = false, length = 1)
	public char getEquipmentTypeId() {
		return this.equipmentTypeId;
	}

	public void setEquipmentTypeId(char equipmentTypeId) {
		this.equipmentTypeId = equipmentTypeId;
	}

	@Column(name = "equipmentType", nullable = false, length = 50)
	public String getEquipmentType() {
		return this.equipmentType;
	}

	public void setEquipmentType(String equipmentType) {
		this.equipmentType = equipmentType;
	}

}
