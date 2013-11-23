package com.blackstar.web;

import com.blackstar.services.interfaces.GoogleDriveService;
import com.blackstar.services.interfaces.SecurityService;
import com.blackstar.services.interfaces.UserDomainService;

public class AbstractController {

  /**User Domain Service*/
  protected UserDomainService udService;
  /**Google Drive Service*/
  protected GoogleDriveService gdService = null;
  
  protected SecurityService secService = null;

  public void setUdService(UserDomainService udService) {
	this.udService = udService;
  }

  public void setGdService(GoogleDriveService gdService) {
	this.gdService = gdService;
  }

  public void setSecService(SecurityService secService) {
	this.secService = secService;
  }
	
}
