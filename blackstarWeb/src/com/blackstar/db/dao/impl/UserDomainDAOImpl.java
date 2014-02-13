package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.UserDomainDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.dto.EmployeeDTO;

@SuppressWarnings("unchecked")
public class UserDomainDAOImpl extends AbstractDAO implements UserDomainDAO {
	
	public List<EmployeeDTO> getStaff(){
		StringBuilder sqlBuilder = new StringBuilder("CALL GetDomainEmployees();");
		return (List<EmployeeDTO>) getJdbcTemplate().query(sqlBuilder.toString()
				, getMapperFor(EmployeeDTO.class));
	}

	@Override
	public List<JSONObject> getStaffByGroupJson(String group) {
		String sql = "CALL GetAutocompleteEmployeeList(?)";
		return getJdbcTemplate().query(sql, new Object[]{group}, new JSONRowMapper());
	}
	
	public List<EmployeeDTO> getStaff(String group){
		StringBuilder sqlBuilder = new StringBuilder("CALL GetDomainEmployeesByGroup(?);");
		return (List<EmployeeDTO>) getJdbcTemplate().query(sqlBuilder.toString(), new Object[]{group}
				, getMapperFor(EmployeeDTO.class));
	}
}