package com.blackstar.services.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.sp.GetConcurrentFailuresKPI;

public interface IndicadoresServicioService {

	public String getTickets() throws Exception;
	public String getPolicies() throws Exception;
	public List<GetConcurrentFailuresKPI> getConcurrentFailures() throws Exception;
	public String getMaxPeportsByUser() throws Exception;
}
