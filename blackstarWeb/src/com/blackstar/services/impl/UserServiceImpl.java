package com.blackstar.services.impl;

import java.util.List;

import com.blackstar.db.dao.impl.UserDaoImpl;
import com.blackstar.db.dao.interfaces.UserDAO;
import com.blackstar.model.User;
import com.blackstar.services.AbstractService;
import com.blackstar.services.IUserService;

public class UserServiceImpl extends AbstractService implements IUserService {
	private UserDAO dao = new UserDaoImpl();

	public void setDao(UserDAO dao) {
		this.dao = dao;
	}

	@Override
	public User gerUserById(String id) {
		User retObj = dao.getUserById(id);
		return retObj;
	}

	@Override
	public List<User> getEmployeeList(){
		List<User> empList = null;
		
		empList = dao.getDomainUserList();
		
		return empList;
	}
}
