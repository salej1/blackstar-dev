package com.codex.service;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.User;
import com.codex.vo.ClientOriginTypes;
import com.codex.vo.ClientTypes;
import com.codex.vo.LocationVO;
import com.codex.vo.ClientVO;

public interface ClientService {

  public List<LocationVO> getAllStates();
  public List<ClientTypes> getAllClientTypes();
  public List<ClientOriginTypes> getAllOriginTypes();
  public List<User> getUsersByGroup(String groupName);
  public String getLocationsJSONByZipCode(String zipCode);
  public void insertClient(ClientVO client);
  public String getNextclientId();
  public String getClientList(boolean isProspect);
  
}
