package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.dto.EmployeeDTO;

public interface UserDomainDAO {

	public List<EmployeeDTO> getStaff();
}
