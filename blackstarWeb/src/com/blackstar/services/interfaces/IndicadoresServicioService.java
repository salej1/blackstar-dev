package com.blackstar.services.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Chart;
import com.blackstar.model.sp.GetConcurrentFailuresKPI;
import com.blackstar.model.sp.GetReportOSTableKPI;

public interface IndicadoresServicioService {

	public String getTickets() throws Exception;
	public String getPolicies() throws Exception;
	public List<GetConcurrentFailuresKPI> getConcurrentFailures() throws Exception;
	public String getMaxPeportsByUser() throws Exception;
	public String getReportOSResumeKPI() throws Exception;
	public List<GetReportOSTableKPI> getReportOSTable() throws Exception;
	public String getOSResume() throws Exception;
	public List<Chart> getCharts() throws Exception;
	public String getUserAverage();
	public String getGeneralAverage();
	
}
