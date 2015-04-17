package com.bloom.services;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.blackstar.model.Chart;
import com.blackstar.services.AbstractService;
import com.bloom.db.dao.InternatTicketsKPIDao;

public class InternatTicketsKPIServiceImpl extends AbstractService 
                                           implements InternatTicketsKPIService {
	
  private InternatTicketsKPIDao dao;
  
  public void setDao(InternatTicketsKPIDao dao) {
	this.dao = dao;
  }	
  
  public String getTicketsByUser(Date startDate, Date endDate){
	return dao.getTicketsByUser(startDate, endDate).toString();
  }
  
  public List<Chart> getTicketByOfficeKPI(Date startDate, Date endDate){
	List<Chart> charts = new ArrayList<Chart>();
	Chart chart = new Chart();
	chart.setTitle("Requisiciones por Oficina");
	chart.setIs3d(true);
	chart.setType("pie");
	chart.setData(dao.getTicketByOfficeKPI(startDate, endDate).toString().replaceAll("\"", "'"));
	charts.add(chart);
	return charts;
  }
  
  public List<Chart> getTicketByAreaKPI(Date startDate, Date endDate){
	List<Chart> charts = new ArrayList<Chart>();
	Chart chart = new Chart();
	chart.setTitle("Requisiciones por Area solicitante");
	chart.setIs3d(true);
	chart.setType("pie");
	chart.setData(dao.getTicketByAreaKPI(startDate, endDate).toString().replaceAll("\"", "'"));
	charts.add(chart);
	return charts;
  }
  
  public List<Chart> getTicketByDayKPI(Date startDate, Date endDate){
	List<Chart> charts = new ArrayList<Chart>();
	Chart chart = new Chart();
	chart.setTitle("Requisiciones por Dia");
	chart.setIs3d(true);
	chart.setType("line");
	chart.setData(dao.getTicketByDayKPI(startDate, endDate).toString().replaceAll("\"", "'"));
	charts.add(chart);
	return charts;
  }
  
  public List<Chart> getTicketByProjectKPI(Date startDate, Date endDate){
	List<Chart> charts = new ArrayList<Chart>();
	Chart chart = new Chart();
	chart.setTitle("Requisiciones por Proyecto");
	chart.setIs3d(true);
	chart.setType("bar");
	chart.setData(dao.getTicketByProjectKPI(startDate, endDate).toString().replaceAll("\"", "'"));
	charts.add(chart);
	return charts;
  }
  
  public List<Chart> getTicketByServiceAreaKPI(Date startDate, Date endDate){
	List<Chart> charts = new ArrayList<Chart>();
	Chart chart = new Chart();
	chart.setTitle("Requisiciones por Area de apoyo");
	chart.setIs3d(true);
	chart.setType("pie");
	chart.setData(dao.getTicketByServiceAreaKPI(startDate, endDate).toString().replaceAll("\"", "'"));
	charts.add(chart);
	return charts;
  }

}
