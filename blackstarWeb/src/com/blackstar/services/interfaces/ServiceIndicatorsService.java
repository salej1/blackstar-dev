package com.blackstar.services.interfaces;

import java.util.Date;
import java.util.List;

import com.blackstar.model.Chart;
import com.blackstar.model.dto.AvailabilityKpiDTO;
import com.blackstar.model.sp.GetConcurrentFailuresKPI;
import com.blackstar.model.sp.GetReportOSTableKPI;
import com.blackstar.model.sp.GetStatisticsKPI;

public interface ServiceIndicatorsService {

	public String getTickets() throws Exception;
	public String getPolicies() throws Exception;
	public List<GetConcurrentFailuresKPI> getConcurrentFailures() throws Exception;
	public String getMaxPeportsByUser() throws Exception;
	public String getReportOSResumeKPI() throws Exception;
	public List<GetReportOSTableKPI> getReportOSTable() throws Exception;
	public String getOSResume() throws Exception;
	public List<Chart> getCharts(String project, Date startDate, Date endDate, String user) throws Exception;
	public String getUserAverage();
	public String getGeneralAverage();
	public List<GetStatisticsKPI> getStatisticsKPI(String project, Date startDate, Date endDate);
	public List<String> getProjectList();
	public List<String> getLimitedProjectList(String user);
	public AvailabilityKpiDTO getAvailability(String project, Date startDate, Date endDate, String user) throws Exception;
}