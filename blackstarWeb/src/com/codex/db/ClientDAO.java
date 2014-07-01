package com.codex.db;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.User;
import com.codex.vo.ClientVO;
import com.codex.vo.ClientOriginTypes;
import com.codex.vo.ClientTypes;
import com.codex.vo.LocationVO;

public interface ClientDAO {
	
	
  public List<LocationVO> getAllStates();
  public List<ClientTypes> getAllClientTypes();
  public List<ClientOriginTypes> getAllOriginTypes();
  public List<User> getUsersByGroup(String groupName);
  public List<JSONObject> getLocationsJSONByZipCode(String zipCode);
  public void insertClient(ClientVO client);
  public String getNextclientId();
  public List<JSONObject> getClientList(boolean isProspect);

}
