package com.codex.service.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.User;
import com.blackstar.services.AbstractService;
import com.codex.db.ProspectDAO;
import com.codex.service.ProspectService;
import com.codex.vo.ClientOriginTypes;
import com.codex.vo.ClientTypes;
import com.codex.vo.LocationVO;

public class ProspectServiceImpl extends AbstractService 
                                 implements ProspectService {

	
  private ProspectDAO dao;

  public void setDao(ProspectDAO dao) {
	this.dao = dao;
  }
  
  @Override
  public List<LocationVO> getAllStates(){
	 return dao.getAllStates();
  }
  
  @Override
  public List<ClientTypes> getAllClientTypes(){
	return dao.getAllClientTypes();	  
  }
  
  @Override
  public List<ClientOriginTypes> getAllOriginTypes(){
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
  
  private String encode(String input){
	  return input.replaceAll("�", "a").replaceAll("�", "e")
			      .replaceAll("�", "i").replaceAll("�", "o")
			      .replaceAll("�", "u").replaceAll("�", "n")
			      .replaceAll("�", "A").replaceAll("�", "E")
			      .replaceAll("�", "I").replaceAll("�", "O")
			      .replaceAll("�", "U").replaceAll("�", "N");
  }
  
}
