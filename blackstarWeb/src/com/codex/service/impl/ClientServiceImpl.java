package com.codex.service.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.User;
import com.blackstar.services.AbstractService;
import com.codex.db.ClientDAO;
import com.codex.service.ClientService;
import com.codex.vo.ClientOriginTypesVO;
import com.codex.vo.ClientTypesVO;
import com.codex.vo.LocationVO;
import com.codex.vo.ClientVO;

public class ClientServiceImpl extends AbstractService 
                                 implements ClientService {

	
  private ClientDAO dao;

  public void setDao(ClientDAO dao) {
	this.dao = dao;
  }
  
  @Override
  public List<LocationVO> getAllStates(){
	 return dao.getAllStates();
  }
  
  @Override
  public List<ClientTypesVO> getAllClientTypes(){
	return dao.getAllClientTypes();	  
  }
  
  @Override
  public List<ClientOriginTypesVO> getAllOriginTypes(){
	return dao.getAllOriginTypes();
  }
  
  @Override
  public List<User> getUsersByGroup(String groupName){
	  return dao.getUsersByGroup(groupName);
  }
  
  @Override
  public String getLocationsJSONByZipCode(String zipCode){
	List<JSONObject> locations = dao.getLocationsJSONByZipCode(zipCode);
	return locations != null ? encode(locations.toString()): "";
  }
  
  @Override
  public void insertClient(ClientVO client){
    dao.insertClient(client);
  }
  
  @Override
  public String getNextclientId(){
	  return dao.getNextclientId();
  }
  
  @Override
  public String getClientList(boolean isProspect){
	List<JSONObject> clientList = dao.getClientList(isProspect);
	return clientList != null ? encode(clientList.toString()): "";
  }
  
  @Override 
  public List<ClientVO> getAllClients(){
	return dao.getAllClients();
  }
  
  @Override
  public ClientVO getClientById(Integer clientId){
	return dao.getClientById(clientId);
  }
  
}
