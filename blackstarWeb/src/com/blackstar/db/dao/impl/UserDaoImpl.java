package com.blackstar.db.dao.impl;

import java.util.Iterator;
import java.util.List;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.UserDAO;
import com.blackstar.db.dao.mapper.UserRowMapper;
import com.blackstar.model.User;

public class UserDaoImpl extends AbstractDAO implements UserDAO{

	@Override
	public User getUserById(String id) {
		// Datos del usuario
		User retVal = (User) getJdbcTemplate().query("CALL GetUserData(?)", new Object[]{id}, new UserRowMapper());
		// Grupos a los que pertenece
		List<String> groups = getJdbcTemplate().queryForList("CALL GetUserGroups(?)", new Object[]{id}, String.class);
		// Asociacion de grupos
		Iterator<String> uit = groups.iterator();
		while(uit.hasNext()){
			retVal.addGroup(uit.next());
		}
		
		return retVal;
	}

	@Override
	public List<User> getDomainUserList() {
		return (List<User>)getJdbcTemplate().query("CALL GetDomainEmployees()", new UserRowMapper());
	}

}
