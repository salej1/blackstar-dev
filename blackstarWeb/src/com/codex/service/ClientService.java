package com.codex.service;

import java.util.List;

import com.blackstar.model.User;
import com.codex.vo.ClientOriginTypesVO;
import com.codex.vo.ClientTypesVO;
import com.codex.vo.LocationVO;
import com.codex.vo.ClientVO;

public interface ClientService {

  public List<LocationVO> getAllStates();
  public List<ClientTypesVO> getAllClientTypes();
  public List<ClientOriginTypesVO> getAllOriginTypes();
  public List<User> getUsersByGroup(String groupName);
  public String getLocationsJSONByZipCode(String zipCode);
  public void insertClient(ClientVO client);
  public String getNextclientId();
  public String getClientList(boolean isProspect);
  public List<ClientVO> getAllClients();
  public ClientVO getClientById(Integer clientId);
  
}
