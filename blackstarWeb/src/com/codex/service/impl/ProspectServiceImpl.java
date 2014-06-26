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
	  return input.replaceAll("á", "a").replaceAll("é", "e")
			      .replaceAll("í", "i").replaceAll("ó", "o")
			      .replaceAll("ú", "u").replaceAll("ñ", "n")
			      .replaceAll("Á", "A").replaceAll("É", "E")
			      .replaceAll("Í", "I").replaceAll("Ó", "O")
			      .replaceAll("Ú", "U").replaceAll("Ñ", "N");
  }
  
}
