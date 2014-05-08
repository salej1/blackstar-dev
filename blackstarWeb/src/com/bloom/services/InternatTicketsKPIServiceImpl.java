package com.bloom.services;

import java.util.ArrayList;
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
  
  public String getTicketsByUser(){
	return dao.getTicketsByUser().toString();
  }
  
  public List<Chart> getTicketByOfficeKPI(){
	List<Chart> charts = new ArrayList<Chart>();
	Chart chart = new Chart();
	chart.setTitle("TICKETS POR OFICINA");
	chart.setIs3d(true);
	chart.setType("pie");
	chart.setData(dao.getTicketByOfficeKPI().toString().replaceAll("\"", "'"));
	charts.add(chart);
	return charts;
  }
  
  public List<Chart> getTicketByAreaKPI(){
	List<Chart> charts = new ArrayList<Chart>();
	Chart chart = new Chart();
	chart.setTitle("TICKETS POR AREA");
	chart.setIs3d(true);
	chart.setType("donut");
	chart.setData(dao.getTicketByAreaKPI().toString().replaceAll("\"", "'"));
	charts.add(chart);
	return charts;
  }
  
  public List<Chart> getTicketByDayKPI(){
	List<Chart> charts = new ArrayList<Chart>();
	Chart chart = new Chart();
	chart.setTitle("TICKETS POR DIA");
	chart.setIs3d(true);
	chart.setType("line");
	chart.setData(dao.getTicketByDayKPI().toString().replaceAll("\"", "'"));
	charts.add(chart);
	return charts;
  }
  
  public List<Chart> getTicketByProjectKPI(){
	List<Chart> charts = new ArrayList<Chart>();
	Chart chart = new Chart();
	chart.setTitle("TICKETS POR PROYECTO");
	chart.setIs3d(true);
	chart.setType("bar");
	chart.setData(dao.getTicketByProjectKPI().toString().replaceAll("\"", "'"));
	charts.add(chart);
	return charts;
  }
  
  public List<Chart> getTicketByServiceAreaKPI(){
	List<Chart> charts = new ArrayList<Chart>();
	Chart chart = new Chart();
	chart.setTitle("TICKETS POR AREA / TIPO DE SOLICITUD");
	chart.setIs3d(true);
	chart.setType("area");
	chart.setData(dao.getTicketByServiceAreaKPI().toString().replaceAll("\"", "'"));
	charts.add(chart);
	return charts;
  }

}
