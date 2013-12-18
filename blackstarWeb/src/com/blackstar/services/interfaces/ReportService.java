package com.blackstar.services.interfaces;

import com.blackstar.model.dto.AirCoServicePolicyDTO;

public interface ReportService {

	public byte[] getServiceOrderReport(Integer serviceOrderId) throws Exception;
	public byte[] getAirCoReport(AirCoServicePolicyDTO serviceOrder) throws Exception;
}
