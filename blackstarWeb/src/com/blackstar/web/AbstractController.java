package com.blackstar.web;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;

import com.blackstar.common.Globals;
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
	
  @InitBinder
  private void dateBinder(WebDataBinder binder) {
              //The date format to parse or output your dates
      SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
              //Create a new CustomDateEditor
      CustomDateEditor editor = new CustomDateEditor(dateFormat, true);
              //Register it as custom editor for the Date type
      binder.registerCustomEditor(Date.class, editor);
  }
}
