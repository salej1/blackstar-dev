package com.blackstar.db.dao.interfaces;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Servicecenter;
import com.blackstar.model.sp.GetConcurrentFailuresKPI;
import com.blackstar.model.sp.GetReportOSTableKPI;
import com.blackstar.model.sp.GetStatisticsKPI;

public interface ServiceIndicatorsDAO {
	
  public List<JSONObject> getTickets();
  public List<JSONObject> getPolicies();
  public List<GetConcurrentFailuresKPI> getConcurrentFailures();
  public List<JSONObject> getMaxPeportsByUser();
  public List<GetReportOSTableKPI> getReportOSTable();
  public List<JSONObject> getReportOSResume();
  public List<JSONObject> getOSResume();
  public List<JSONObject> getReportByEquipmentType(String project, Date startDate, Date endDate);
  public List<JSONObject> getTicketsByServiceCenter(String project, Date startDate, Date endDate);
  public List<JSONObject> getStatus(String servicecenterId, String project, Date startDate, Date endDate);
  public List<Servicecenter> getServiceCenterIdList();
  public List<JSONObject> getUserAverage();
  public List<JSONObject> getGeneralAverage();
  public List<GetStatisticsKPI> getStatisticsKPI(String project, Date startDate, Date endDate);
  public List<String> getProjectList();
}