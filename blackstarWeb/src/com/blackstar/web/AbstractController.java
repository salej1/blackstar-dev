package com.blackstar.web;

import com.blackstar.services.interfaces.UserDomainService;

public class AbstractController {

  protected UserDomainService udService;

  public void setUdService(UserDomainService udService) {
	this.udService = udService;
  }
	
}
