package com.blackstar.services.interfaces;

import java.util.Date;
import java.util.List;

import com.blackstar.model.Chart;
import com.blackstar.model.dto.AvailabilityKpiDTO;
import com.blackstar.model.sp.GetConcurrentFailuresKPI;
import com.blackstar.model.sp.GetReportOSTableKPI;
import com.blackstar.model.sp.GetStatisticsKPI;

public interface ServiceIndicatorsService {

	public String getTickets(String project, Date startDate, Date endDate, String user) throws Exception;
	public String getPolicies(String search, String project, Date startDate, Date endDate, String user) throws Exception;
	public List<GetConcurrentFailuresKPI> getConcurrentFailures(String project, Date startDate, Date endDate, String user) throws Exception;
	public String getMaxPeportsByUser(String project, Date startDate, Date endDate) throws Exception;
	public String getReportOSResumeKPI() throws Exception;
	public List<GetReportOSTableKPI> getReportOSTable() throws Exception;
	public String getOSResume() throws Exception;
	public List<Chart> getCharts(String project, Date startDate, Date endDate, String user) throws Exception;
	public List<Chart> getDisplayCharts(String project, Date startDate, Date endDate, String user) throws Exception;
	public String getUserAverage(String project, Date startDate, Date endDate);
	public String getGeneralAverage(String project, Date startDate, Date endDate);
	public List<GetStatisticsKPI> getStatisticsKPI(String project, Date startDate, Date endDate);
	public List<String> getProjectList();
	public List<String> getLimitedProjectList(String user);
	public AvailabilityKpiDTO getAvailability(String project, Date startDate, Date endDate, String user) throws Exception;
	public String getPoliciesExport(String search, String project, Date startDate, Date endDate);
	public String getTicketsExport(String search, String project, Date startDate, Date endDate);
	public String getSOExport(String search, String project, Date startDate, Date endDate);
	public String getProjects(String project, Date startDate, Date endDate);
}
