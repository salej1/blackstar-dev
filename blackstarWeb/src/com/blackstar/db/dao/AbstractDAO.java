package com.blackstar.db.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.ParameterizedBeanPropertyRowMapper;

public class AbstractDAO {
	
  private JdbcTemplate jdbcTemplate;

  protected final JdbcTemplate getJdbcTemplate() {
	return jdbcTemplate;
  }

  public final void setJdbcTemplate(final JdbcTemplate jdbcTemplate) {
	this.jdbcTemplate = jdbcTemplate;
  }
	  
  @SuppressWarnings({ "rawtypes", "unchecked" })
  protected ParameterizedBeanPropertyRowMapper<?> getMapperFor(Class type){
    return ParameterizedBeanPropertyRowMapper.newInstance(type);
  }	

}
