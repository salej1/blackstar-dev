package com.blackstar.db.dao.impl;

import java.util.List;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.EquipmentTypeDAO;
import com.blackstar.model.Equipmenttype;
import com.blackstar.model.dto.ServiceTypeDTO;

public class EquipmentTypeDAOImpl extends AbstractDAO implements EquipmentTypeDAO {

	@Override
	public Equipmenttype findEquipmentType() {
		// TODO Auto-generated method stub
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Equipmenttype> selectAllEquipmentType() {
		String sqlQuery = "CALL GetEquipmentTypeList();";
		return (List<Equipmenttype>) getJdbcTemplate().query(sqlQuery, getMapperFor(Equipmenttype.class));
	}

	@Override
	public Equipmenttype getEquipmentTypeById(char id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int insertEquipmentType() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean updateEquipmentType() {
		// TODO Auto-generated method stub
		return false;
	}

}
