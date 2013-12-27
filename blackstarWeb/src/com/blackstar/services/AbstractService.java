package com.blackstar.services;

import com.blackstar.services.interfaces.GoogleDriveService;


public class AbstractService {
	
  protected GoogleDriveService gdService = null;

  public void setGdService(GoogleDriveService gdService) {
	this.gdService = gdService;
  }

}
