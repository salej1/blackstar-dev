package com.blackstar.services.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.IndicadoresServicioDAO;
import com.blackstar.model.IndServConcurrentFailures;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.IndicadoresServicioService;

@SuppressWarnings("serial")
public class IndicadoresServicioServiceImpl extends AbstractService 
                            implements IndicadoresServicioService {
	
  private IndicadoresServicioDAO dao = null;
	public static final Map<String , String> MONTHS = new HashMap<String , String>() {{
        put("01", "lbl-ENERO");
        put("02", "lbl-FEBRERO");
        put("03", "lbl-MARZO");
        put("04", "lbl-ABRIL");
        put("05", "lbl-MAYO");
        put("06", "lbl-JUNIO");
        put("07", "lbl-JULIO");
        put("08", "lbl-AGOSTO");
        put("09", "lbl-SEPTIEMBRE");
        put("10", "lbl-OCTUBRE");
        put("11", "lbl-NOVIEMBRE");
        put("12", "lbl-DICIEMBRE");
}};
  
  public void setDao(IndicadoresServicioDAO dao) {
	this.dao = dao;
  }
  
  public String getTickets() throws Exception{
	List<JSONObject> jsonData = dao.getTickets();
	String month = "";
	String lastMonth = "";
	Map <String, String> map = new HashMap<String , String>() {{
        put("DT_RowId", "1");
        put("ticketNumber", "");
        put("created", "");
        put("customer", "");
        put("equipmentType", "");
        put("ticketStatus", "");
        put("asignee", "");
        put("equipmentLocation", "");
        put("equipmentBrand", "");
        put("arrival", "");
        put("closed", "");
    }};
	for(int i = 0; i < jsonData.size();i++){
	  month = jsonData.get(i).get("created").toString().substring(5,7);
	  if(! month.equals(lastMonth)){
		  lastMonth = month;
		  map.put("ticketNumber", MONTHS.get(month));
		  jsonData.add(i, new JSONObject(map));
	  }
    }
	return jsonData != null ? jsonData.toString() : "";
  }
  
  public String getPolicies() throws Exception{
	List<JSONObject> jsonData = dao.getPolicies();
	return jsonData != null ? jsonData.toString() : "";
  }
  
  public List<IndServConcurrentFailures> getConcurrentFailures() throws Exception{
	List<IndServConcurrentFailures> data = dao.getConcurrentFailures();
	String month = "";
	String lastMonth = "";
	for(int i = 0; i < data.size();i++){
		  month = data.get(i).getCreated().toString().substring(5,7);
		  if(! month.equals(lastMonth)){
			  lastMonth = month;
			  data.add(i, new  IndServConcurrentFailures(MONTHS.get(month)));
		  }
	    }
	return data;
  }

}
