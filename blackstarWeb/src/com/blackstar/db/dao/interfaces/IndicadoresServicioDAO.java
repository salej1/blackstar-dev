package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Servicecenter;
import com.blackstar.model.sp.GetConcurrentFailuresKPI;
import com.blackstar.model.sp.GetReportOSTableKPI;

public interface IndicadoresServicioDAO {
	
  public List<JSONObject> getTickets();
  public List<JSONObject> getPolicies();
  public List<GetConcurrentFailuresKPI> getConcurrentFailures();
  public List<JSONObject> getMaxPeportsByUser();
  public List<GetReportOSTableKPI> getReportOSTable();
  public List<JSONObject> getReportOSResume();
  public List<JSONObject> getOSResume();
  public List<JSONObject> getReportByEquipmentType();
  public List<JSONObject> getTicketsByServiceCenter();
  public List<JSONObject> getStatus(String servicecenterId);
  public List<Servicecenter> getServiceCenterIdList();
	
}
