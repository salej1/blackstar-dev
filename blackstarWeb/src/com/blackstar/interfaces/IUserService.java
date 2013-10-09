package com.blackstar.interfaces;

import java.util.List;
import java.util.Map;

public interface IUserService {
	String getCurrentUserId();

	String getCurrentUserName();

	List<String> getCurrentUserGroups();
	
	Map<String, String> getEmployeeList();
}
