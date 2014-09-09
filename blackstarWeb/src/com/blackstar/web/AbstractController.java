package com.blackstar.web;

import java.text.SimpleDateFormat;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;

import com.blackstar.model.ServiceCheckOption;
import com.blackstar.services.interfaces.GoogleDriveService;
import com.blackstar.services.interfaces.SecurityService;
import com.blackstar.services.interfaces.UserDomainService;

public class AbstractController {

  /**User Domain Service*/
  protected UserDomainService udService;
  /**Google Drive Service*/
  protected GoogleDriveService gdService = null;
  
  protected SecurityService secService = null;
  
  protected List<ServiceCheckOption> checkOptions;

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
  
  
  protected JSONObject requestParamsToJSON(HttpServletRequest req) {
      JSONObject jsonObj = new JSONObject();
      Map<String, String[]> params = req.getParameterMap();
      
      try{
          for (Map.Entry<String, String[]> entry : params.entrySet()) {
              String v[] = entry.getValue();
              Object o = (v.length == 1) ? v[0] : v;
              jsonObj.put(entry.getKey(), o);
          }
    	  
      }catch(JSONException e){
    	  
      }
      
      return jsonObj;
  }

  public List<ServiceCheckOption> getCheckOptions() {
	  if(checkOptions == null){
		  ServiceCheckOption si = new ServiceCheckOption("1", "SI");
		  ServiceCheckOption no = new ServiceCheckOption("2", "NO");
		  ServiceCheckOption na = new ServiceCheckOption("", "N/A");
		  
		  checkOptions = new ArrayList<ServiceCheckOption>();
		  checkOptions.add(si);
		  checkOptions.add(no);
		  checkOptions.add(na);
	  }
	  return checkOptions;
  }
}
