package com.blackstar.interfaces;

import java.util.List;
import com.blackstar.model.User;

public interface IUserService {
	User gerUserById(String id);
	List<User> getEmployeeList();
}
