package com.blackstar.services.interfaces;

import java.util.List;

import com.blackstar.model.dto.EmployeeDTO;

public interface UserDomainService {
	
	public List<EmployeeDTO> getStaff();
	
	// Lista de empleados por grupo - JSON
	public String getStaffByGroupJson(String group);
}
