package com.blackstar.services.interfaces;

import com.blackstar.model.dto.AirCoServicePolicyDTO;
import com.blackstar.model.dto.BatteryServicePolicyDTO;
import com.blackstar.model.dto.EmergencyPlantServicePolicyDTO;
import com.blackstar.model.dto.PlainServicePolicyDTO;
import com.blackstar.model.dto.UpsServicePolicyDTO;

public interface ReportService {

	public byte[] getGeneralReport(PlainServicePolicyDTO data) throws Exception;
	public byte[] getAirCoReport(AirCoServicePolicyDTO data) throws Exception;
	public byte[] getBatteryReport(BatteryServicePolicyDTO data) throws Exception;
	public byte[] getEmergencyPlantReport(EmergencyPlantServicePolicyDTO data) throws Exception;
	public byte[] getUPSReport(UpsServicePolicyDTO data) throws Exception;
}