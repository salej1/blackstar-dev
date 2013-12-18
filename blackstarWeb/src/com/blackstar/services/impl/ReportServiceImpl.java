package com.blackstar.services.impl;

import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.model.dto.AirCoServicePolicyDTO;
import com.blackstar.model.dto.BatteryServicePolicyDTO;
import com.blackstar.model.dto.EmergencyPlantServicePolicyDTO;
import com.blackstar.model.dto.UpsServicePolicyDTO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.ReportService;
import com.blackstar.services.report.core.AirConditioningReport;
import com.blackstar.services.report.core.BatteryMaintenanceReport;
import com.blackstar.services.report.core.EmergencyPlantServiceReport;
import com.blackstar.services.report.core.GeneralServiceReport;
import com.blackstar.services.report.core.UPSServiceReport;

public class ReportServiceImpl extends AbstractService implements ReportService {
  
  private ServiceOrderDAO soDAO = null;
  
  public void setSoDAO(ServiceOrderDAO soDAO) {
	this.soDAO = soDAO;
  }
  
  public byte[] getGeneralReport(Integer serviceOrderId) throws Exception {
	return new GeneralServiceReport().getReport(soDAO
			                .getServiceOrderByIdOrNumber(serviceOrderId, null));
  }
  
  public byte[] getAirCoReport(AirCoServicePolicyDTO data) throws Exception {
	return new AirConditioningReport().getReport(data);
  }
  
  public byte[] getBatteryReport(BatteryServicePolicyDTO data) throws Exception {
    return new BatteryMaintenanceReport().getReport(data);
  }
  
  public byte[] getEmergencyPlantReport(EmergencyPlantServicePolicyDTO data) 
                                                          throws Exception {
    return new EmergencyPlantServiceReport().getReport(data);
  }
  
  public byte[] getUPSReport(UpsServicePolicyDTO data) throws Exception {
    return new UPSServiceReport().getReport(data);
  }

}
