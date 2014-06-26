package com.codex.db.impl;

import java.util.List;





import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.User;
import com.codex.db.ProspectDAO;
import com.codex.vo.ClientOriginTypes;
import com.codex.vo.ClientTypes;
import com.codex.vo.LocationVO;

@SuppressWarnings("unchecked")
public class ProspectDAOImpl extends AbstractDAO 
                             implements ProspectDAO {

  
  @Override
  public List<LocationVO> getAllStates() {
	String sqlQuery = "CALL CodexGetAllStates()";
	return (List<LocationVO>) getJdbcTemplate().query(sqlQuery
			                , getMapperFor(LocationVO.class));
  }
  
  @Override
  public List<ClientTypes> getAllClientTypes() {
	String sqlQuery = "CALL CodexGetAllClientTypes()";
	return (List<ClientTypes>) getJdbcTemplate().query(sqlQuery
			                , getMapperFor(ClientTypes.class));
  }
  
  @Override
  public List<ClientOriginTypes> getAllOriginTypes() {
	String sqlQuery = "CALL CodexGetAllOriginTypes()";
	return (List<ClientOriginTypes>) getJdbcTemplate().query(sqlQuery
			                , getMapperFor(ClientOriginTypes.class));
  }
  
  
  @Override
  public List<User> getUsersByGroup(String groupName) {
	String sqlQuery = "CALL GetUsersByGroup(?)";
	return (List<User>) getJdbcTemplate().query(sqlQuery,new Object[]{groupName} 
	                                                , getMapperFor(User.class));
  }
  
  @Override
  public List<JSONObject> getLocationsJSONByZipCode(String zipCode) {
	String sqlQuery = "CALL GetLocationsByZipCode(?)";
	return getJdbcTemplate().query(sqlQuery,new Object[]{zipCode} 
	                                      , new JSONRowMapper());
  }
}
