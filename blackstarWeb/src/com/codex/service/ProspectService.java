package com.codex.service;

import java.util.List;

import com.blackstar.model.User;
import com.codex.vo.ClientOriginTypes;
import com.codex.vo.ClientTypes;
import com.codex.vo.LocationVO;

public interface ProspectService {

  public List<LocationVO> getAllStates();
  public List<ClientTypes> getAllClientTypes();
  public List<ClientOriginTypes> getAllOriginTypes();
  public List<User> getUsersByGroup(String groupName);
  public String getLocationsJSONByZipCode(String zipCode) ;
  
}
