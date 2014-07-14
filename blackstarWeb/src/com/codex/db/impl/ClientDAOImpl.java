package com.codex.db.impl;

import java.util.List;






import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.User;
import com.codex.db.ClientDAO;
import com.codex.vo.ClientOriginTypesVO;
import com.codex.vo.ClientTypesVO;
import com.codex.vo.LocationVO;
import com.codex.vo.ClientVO;

@SuppressWarnings("unchecked")
public class ClientDAOImpl extends AbstractDAO 
                             implements ClientDAO {

  
  @Override
  public List<LocationVO> getAllStates() {
	String sqlQuery = "CALL CodexGetAllStates()";
	return (List<LocationVO>) getJdbcTemplate().query(sqlQuery
			                , getMapperFor(LocationVO.class));
  }
  
  @Override 
  public List<ClientVO> getAllClients(){
	String sqlQuery = "CALL CodexGetAllClients()";
	return (List<ClientVO>) getJdbcTemplate().query(sqlQuery
			                , getMapperFor(ClientVO.class));
  }
  
  @Override
  public List<ClientTypesVO> getAllClientTypes() {
	String sqlQuery = "CALL CodexGetAllClientTypes()";
	return (List<ClientTypesVO>) getJdbcTemplate().query(sqlQuery
			                , getMapperFor(ClientTypesVO.class));
  }
  
  @Override
  public List<ClientOriginTypesVO> getAllOriginTypes() {
	String sqlQuery = "CALL CodexGetAllOriginTypes()";
	return (List<ClientOriginTypesVO>) getJdbcTemplate().query(sqlQuery
			                , getMapperFor(ClientOriginTypesVO.class));
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
  
  @Override
  public void insertClient(ClientVO client) {
	String sqlQuery = "CALL CodexInsertProspect(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	Object [] params = new Object[]{client.getClientTypeId(), client.getClientOriginId()
			                      , client.getSellerId(), client.isProspect()
			                      , client.getRfc(), client.getCorporateName()
			                      , client.getTradeName(), client.getPhoneArea()
			                      , client.getPhoneNumber(), client.getPhoneExtension()
			                      , client.getPhoneAreaAlt(), client.getPhoneNumberAlt()
			                      , client.getPhoneExtensionAlt(), client.getEmail()
			                      , client.getEmailAlt(), client.getStreet()
			                      , client.getIntNumber(), client.getExtNumber()
			                      , client.getZipCode(), client.getCountry()
			                      , client.getState(), client.getMunicipality()
			                      , client.getCity(), client.getNeighborhood()
			                      , client.getContactName(), client.getCurp()
			                      , client.getRetention()};
	getJdbcTemplate().update(sqlQuery, params);
  }
  
  @Override
  public String getNextclientId(){
	String sqlQuery = "CALL CodexGetNextClientId()";
	return getJdbcTemplate().queryForObject(sqlQuery, String.class);
  }
  
  @Override
  public List<JSONObject> getClientList(boolean isProspect){
	String sqlQuery = "CALL CodexGetClientList(?)";
	return getJdbcTemplate().query(sqlQuery, new Object[]{isProspect ? 0 : 1} , new JSONRowMapper());
  }
 
}
