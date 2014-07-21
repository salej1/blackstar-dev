package com.blackstar.db.dao.interfaces;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Servicecenter;
import com.blackstar.model.dto.AvailabilityKpiDTO;
import com.blackstar.model.sp.GetConcurrentFailuresKPI;
import com.blackstar.model.sp.GetReportOSTableKPI;
import com.blackstar.model.sp.GetStatisticsKPI;

public interface ServiceIndicatorsDAO {
	
  public List<JSONObject> getTickets(String project, Date startDate, Date endDate, String user);
  public List<JSONObject> getPolicies(String search, String project, Date startDate, Date endDate, String user, Integer includeRenewed);
  public List<GetConcurrentFailuresKPI> getConcurrentFailures(String project, Date startDate, Date endDate, String user);
  public List<JSONObject> getMaxPeportsByUser(String project, Date startDate, Date endDate);
  public List<GetReportOSTableKPI> getReportOSTable();
  public List<JSONObject> getReportOSResume();
  public List<JSONObject> getOSResume();
  public List<JSONObject> getReportByEquipmentType(String project, Date startDate, Date endDate, String customer);
  public List<JSONObject> getTicketsByServiceCenter(String project, Date startDate, Date endDate, String customer);
  public List<JSONObject> getStatus(String servicecenterId, String project, Date startDate, Date endDate, String customer);
  public List<Servicecenter> getServiceCenterIdList();
  public List<JSONObject> getUserAverage(String project, Date startDate, Date endDate);
  public List<JSONObject> getGeneralAverage(String project, Date startDate, Date endDate);
  public List<GetStatisticsKPI> getStatisticsKPI(String project, Date startDate, Date endDate);
  public List<String> getProjectList();
  public List<String> getLimitedProjectList(String user);
  public AvailabilityKpiDTO getAvailability(String project, Date startDate, Date endDate, String customer);
  public List<String> getPoliciesExport(String search, String project, Date startDate, Date endDate);
  public List<String> getTicketsExport(String search, String project, Date startDate, Date endDate);
  public List<String> getSOExport(String search, String project, Date startDate, Date endDate);
  public List<JSONObject> getProjects(String project, Date startDate, Date endDate);
}
