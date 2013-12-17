package com.blackstar.services.impl;

import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.ReportService;
import com.blackstar.services.report.core.ServiceOrderReport;

public class ReportServiceImpl extends AbstractService implements ReportService {
  
  private ServiceOrderDAO soDAO = null;
  
  public void setSoDAO(ServiceOrderDAO soDAO) {
	this.soDAO = soDAO;
  }
  
  public byte[] getServiceOrderReport(Integer serviceOrderId) throws Exception {
	ServiceOrderReport report = new ServiceOrderReport();
	return report.getReport(soDAO.getServiceOrderByIdOrNumber(serviceOrderId
			                                                       , null));
  }

}
