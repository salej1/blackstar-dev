package com.blackstar.services;

import com.blackstar.services.interfaces.GoogleDriveService;


public class AbstractService {
	
  protected GoogleDriveService gdService = null;

  public void setGdService(GoogleDriveService gdService) {
	this.gdService = gdService;
  }
  
  
  protected String encode(String input){
	  return input.replaceAll("á", "a").replaceAll("é", "e")
			      .replaceAll("í", "i").replaceAll("ó", "o")
			      .replaceAll("ú", "u").replaceAll("ñ", "n")
			      .replaceAll("Á", "A").replaceAll("É", "E")
			      .replaceAll("Í", "I").replaceAll("Ó", "O")
			      .replaceAll("Ú", "U").replaceAll("Ñ", "N");
  }

}
