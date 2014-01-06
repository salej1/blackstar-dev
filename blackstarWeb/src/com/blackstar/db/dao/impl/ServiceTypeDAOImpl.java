package com.blackstar.db.dao.impl;

import java.util.List;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.ServiceTypeDAO;
import com.blackstar.model.Servicetype;
import com.blackstar.model.dto.ServiceTypeDTO;

public class ServiceTypeDAOImpl extends AbstractDAO implements ServiceTypeDAO{

	@Override
	public Servicetype getServiceTypeById(char id) {
		String sqlQuery = "CALL GetServiceTypeById(?);";
		return getJdbcTemplate().queryForObject(sqlQuery, new Object[]{id}, Servicetype.class);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ServiceTypeDTO> getServiceTypeList() {
		String sqlQuery = "CALL GetServiceTypeList();";
		return (List<ServiceTypeDTO>) getJdbcTemplate().query(sqlQuery, getMapperFor(ServiceTypeDTO.class));
	}

}
