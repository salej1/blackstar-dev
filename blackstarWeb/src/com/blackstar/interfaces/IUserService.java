package com.blackstar.interfaces;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

public interface IUserService {
	String getCurrentUserId(HttpServletResponse resp);
	String getCurrentUserName(HttpServletResponse resp);
	List<String> getCurrentUserGroups(HttpServletResponse resp);
	Map<String, String> getEmployeeList();
	Map<String, String> getEmployeeListByGroup(String group);
}
