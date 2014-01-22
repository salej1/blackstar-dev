package com.blackstar.services.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.IndicadoresServicioDAO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.IndicadoresServicioService;

public class IndicadoresServicioServiceImpl extends AbstractService 
                            implements IndicadoresServicioService {
	
  private IndicadoresServicioDAO dao = null;
  
  public void setDao(IndicadoresServicioDAO dao) {
	this.dao = dao;
  }
  
  public String getAllTickets(){
	List<JSONObject> data = dao.getAllTickets();
	return data != null ? data.toString() : "";
  }

}
