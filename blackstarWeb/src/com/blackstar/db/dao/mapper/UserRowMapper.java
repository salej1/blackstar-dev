package com.blackstar.db.dao.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.blackstar.model.User;

public class UserRowMapper implements RowMapper<User> {

	@Override
	public User mapRow(ResultSet rs, int index) throws SQLException {
		User user = new User(
				rs.getInt("blackstarUserId"),
				rs.getString("email"),
				rs.getString("name")
			);
		
		return user;
	}

}
