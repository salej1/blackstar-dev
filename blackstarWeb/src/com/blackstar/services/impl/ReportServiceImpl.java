package com.blackstar.services.impl;

import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.model.dto.AirCoServicePolicyDTO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.ReportService;
import com.blackstar.services.report.core.AirConditioningReport;
import com.blackstar.services.report.core.ServiceOrderReport;

public class ReportServiceImpl extends AbstractService implements ReportService {
  
  private ServiceOrderDAO soDAO = null;
  
  public void setSoDAO(ServiceOrderDAO soDAO) {
	this.soDAO = soDAO;
  }
  
  public byte[] getServiceOrderReport(Integer serviceOrderId) throws Exception {
	return new ServiceOrderReport().getReport(soDAO
			                .getServiceOrderByIdOrNumber(serviceOrderId, null));
  }
  
  public byte[] getAirCoReport(AirCoServicePolicyDTO serviceOrder) 
		                                        throws Exception {
	return new AirConditioningReport().getReport(serviceOrder);
  }

}
