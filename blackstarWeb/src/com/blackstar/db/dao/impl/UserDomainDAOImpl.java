package com.blackstar.db.dao.impl;

import java.util.List;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.UserDomainDAO;
import com.blackstar.model.dto.EmployeeDTO;

@SuppressWarnings("unchecked")
public class UserDomainDAOImpl extends AbstractDAO implements UserDomainDAO {
	
  public List<EmployeeDTO> getStaff(){
	StringBuilder sqlBuilder = new StringBuilder("CALL GetDomainEmployees();");
	return (List<EmployeeDTO>) getJdbcTemplate().query(sqlBuilder.toString()
			                             , getMapperFor(EmployeeDTO.class));
  }

}
