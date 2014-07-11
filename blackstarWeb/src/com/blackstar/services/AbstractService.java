package com.blackstar.services;

import com.blackstar.services.interfaces.GoogleDriveService;


public class AbstractService {
	
  protected GoogleDriveService gdService = null;

  public void setGdService(GoogleDriveService gdService) {
	this.gdService = gdService;
  }
  
  
  protected String encode(String input){
	  return input.replaceAll("�", "a").replaceAll("�", "e")
			      .replaceAll("�", "i").replaceAll("�", "o")
			      .replaceAll("�", "u").replaceAll("�", "n")
			      .replaceAll("�", "A").replaceAll("�", "E")
			      .replaceAll("�", "I").replaceAll("�", "O")
			      .replaceAll("�", "U").replaceAll("�", "N");
  }

}
