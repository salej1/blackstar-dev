package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.dto.EmployeeDTO;

public interface UserDomainDAO {

	public List<EmployeeDTO> getStaff();
	public List<JSONObject> getStaffByGroupJson(String group);
}
