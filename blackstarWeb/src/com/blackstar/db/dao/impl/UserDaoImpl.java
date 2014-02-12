package com.blackstar.db.dao.impl;

import java.util.List;

import org.springframework.dao.EmptyResultDataAccessException;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.UserDAO;
import com.blackstar.db.dao.mapper.UserRowMapper;
import com.blackstar.model.User;

public class UserDaoImpl extends AbstractDAO implements UserDAO{

  
  @Override
  public User getUserById(String id) {
	User user = null;
	List<String> groups = null;
	try{
		user = (User) getJdbcTemplate().queryForObject("CALL GetUserData(?)"
	                          , new Object[]{id}, getMapperFor(User.class));
	} catch(EmptyResultDataAccessException ignored){
		return null;
	}
	groups = getJdbcTemplate().queryForList("CALL GetUserGroups(?)"
                                 , new Object[]{id}, String.class);
	for(String group:  groups){
	  user.addGroup(group);
	}
    return user;
  }

  @Override
  public List<User> getDomainUserList() {
	return (List<User>)getJdbcTemplate().query("CALL GetDomainEmployees()"
			                                       , new UserRowMapper());
  }

}
