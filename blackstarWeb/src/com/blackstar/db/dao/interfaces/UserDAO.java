package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.User;

public interface UserDAO {
	
  public User getUserById(String id);
  public List<User> getDomainUserList();
  public User getUserById(Integer id);
	
}
