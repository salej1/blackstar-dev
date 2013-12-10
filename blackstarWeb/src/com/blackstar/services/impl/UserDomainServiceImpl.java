package com.blackstar.services.impl;

import java.util.List;

import com.blackstar.db.dao.interfaces.UserDomainDAO;
import com.blackstar.model.dto.EmployeeDTO;
import com.blackstar.services.interfaces.UserDomainService;

public class UserDomainServiceImpl implements UserDomainService {

  private UserDomainDAO dao = null;

  public UserDomainDAO getDao() {
	return dao;
  }

  public void setDao(UserDomainDAO dao) {
	this.dao = dao;
  }
  
  public List<EmployeeDTO> getStaff(){
	 return dao.getStaff();
  }
  
}
