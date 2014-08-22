package com.bloom.services;

import java.util.List;

import com.blackstar.services.AbstractService;
import com.bloom.common.bean.ReportTicketBean;
import com.bloom.common.exception.DAOException;
import com.bloom.common.exception.ServiceException;
import com.bloom.common.utils.DataTypeUtil;
import com.bloom.db.dao.ReportsTicketsDao;

public class ReportsTicketsServiceImpl extends AbstractService 
                                        implements ReportsTicketsService {

  private ReportsTicketsDao reportsTicketsDao = null;
  
  
  @Override
  public List<ReportTicketBean> getStatisticsByAreaSupport(String startCreationDateTicket, String endCreationDateTicket) throws ServiceException {
  	
  	startCreationDateTicket = DataTypeUtil.transformDateFormat(startCreationDateTicket,DataTypeUtil.MIN_TIME);
  	endCreationDateTicket = DataTypeUtil.transformDateFormat(endCreationDateTicket,DataTypeUtil.MAX_TIME);
  	
      try {
      	return getReportsTicketsDao().getStatisticsByAreaSupport(startCreationDateTicket, endCreationDateTicket);
          
      } catch (DAOException e) {
      	//LOGGER.error(ERROR_CONSULTA_CAT, e);
          throw new ServiceException("Error al obtener datos del reporte tiempo de respuesta por area de apoyo", e);
      }
  }
  

  @Override
  public List<ReportTicketBean> getStatisticsByHelpDesk(String startCreationDateTicket, String endCreationDateTicket) throws ServiceException {
  	
  	startCreationDateTicket = DataTypeUtil.transformDateFormat(startCreationDateTicket,DataTypeUtil.MIN_TIME);
  	endCreationDateTicket = DataTypeUtil.transformDateFormat(endCreationDateTicket,DataTypeUtil.MAX_TIME);
  	
      try {
      	return getReportsTicketsDao().getStatisticsByHelpDesk(startCreationDateTicket, endCreationDateTicket);
          
      } catch (DAOException e) {
      	//LOGGER.error(ERROR_CONSULTA_CAT, e);
          throw new ServiceException("Error al obtener datos del reporte tiempo de respuesta de mesa de ayuda", e);
      }
  }


  @Override
  public List<ReportTicketBean> getPercentageTimeClosedTickets(String startCreationDateTicket, String endCreationDateTicket) throws ServiceException {
  	
  	startCreationDateTicket = DataTypeUtil.transformDateFormat(startCreationDateTicket,DataTypeUtil.MIN_TIME);
  	endCreationDateTicket = DataTypeUtil.transformDateFormat(endCreationDateTicket,DataTypeUtil.MAX_TIME);
  	
      try {
      	return getReportsTicketsDao().getPercentageTimeClosedTickets(startCreationDateTicket, endCreationDateTicket);
          
      } catch (DAOException e) {
      	//LOGGER.error(ERROR_CONSULTA_CAT, e);
          throw new ServiceException("Error al obtener datos del reporte tickets cerrados a tiempo", e);
      }
  }

  
  @Override
  public List<ReportTicketBean> getPercentageEvaluationTickets(String startCreationDateTicket, String endCreationDateTicket) throws ServiceException {
  	
  	startCreationDateTicket = DataTypeUtil.transformDateFormat(startCreationDateTicket,DataTypeUtil.MIN_TIME);
  	endCreationDateTicket = DataTypeUtil.transformDateFormat(endCreationDateTicket,DataTypeUtil.MAX_TIME);
  	
      try {
      	return getReportsTicketsDao().getPercentageEvaluationTickets(startCreationDateTicket, endCreationDateTicket);
          
      } catch (DAOException e) {
      	//LOGGER.error(ERROR_CONSULTA_CAT, e);
          throw new ServiceException("Error al obtener datos del reporte tickets por evaluacion", e);
      }
  }


  @Override
  public List<ReportTicketBean> getNumberTicketsByArea(String startCreationDateTicket, String endCreationDateTicket) throws ServiceException {
  	
  	startCreationDateTicket = DataTypeUtil.transformDateFormat(startCreationDateTicket,DataTypeUtil.MIN_TIME);
  	endCreationDateTicket = DataTypeUtil.transformDateFormat(endCreationDateTicket,DataTypeUtil.MAX_TIME);
  	
      try {
      	return getReportsTicketsDao().getNumberTicketsByArea(startCreationDateTicket, endCreationDateTicket);
          
      } catch (DAOException e) {
      	//LOGGER.error(ERROR_CONSULTA_CAT, e);
          throw new ServiceException("Error al obtener datos del reporte numero de tickets por area de apoyo", e);
      }
  }
  

  @Override
  public List<ReportTicketBean> getUnsatisfactoryTicketsByUserEngineeringService(String startCreationDateTicket, String endCreationDateTicket) throws ServiceException {
  	
  	startCreationDateTicket = DataTypeUtil.transformDateFormat(startCreationDateTicket,DataTypeUtil.MIN_TIME);
  	endCreationDateTicket = DataTypeUtil.transformDateFormat(endCreationDateTicket,DataTypeUtil.MAX_TIME);
  	
      try {
      	return getReportsTicketsDao().getUnsatisfactoryTicketsByUserEngineeringService(startCreationDateTicket, endCreationDateTicket);
          
      } catch (DAOException e) {
      	//LOGGER.error(ERROR_CONSULTA_CAT, e);
          throw new ServiceException("Error al obtener datos del reporte tickets no satisfactorios por Ing. de Servicio", e);
      }
  }
  

/**
 * @return the reportsTicketsDao
 */
public ReportsTicketsDao getReportsTicketsDao() {
	return reportsTicketsDao;
}





/**
 * @param reportsTicketsDao the reportsTicketsDao to set
 */
public void setReportsTicketsDao(ReportsTicketsDao reportsTicketsDao) {
	this.reportsTicketsDao = reportsTicketsDao;
}

  

}