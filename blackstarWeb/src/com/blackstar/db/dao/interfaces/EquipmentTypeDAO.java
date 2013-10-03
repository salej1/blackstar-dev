package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Equipmenttype;

public interface EquipmentTypeDAO {

	public Equipmenttype findEquipmentType();
	public List<Equipmenttype> selectAllEquipmentType();
	public Equipmenttype getEquipmentTypeById(char id);
	public int insertEquipmentType();
	public boolean updateEquipmentType();
}
