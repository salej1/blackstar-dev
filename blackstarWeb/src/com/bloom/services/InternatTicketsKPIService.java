package com.bloom.services;

import java.util.Date;
import java.util.List;

import com.blackstar.model.Chart;


public interface InternatTicketsKPIService {

  public String getTicketsByUser(Date startDate, Date endDate);
  public List<Chart> getTicketByOfficeKPI(Date startDate, Date endDate);
  public List<Chart> getTicketByAreaKPI(Date startDate, Date endDate);
  public List<Chart> getTicketByDayKPI(Date startDate, Date endDate);
  public List<Chart> getTicketByProjectKPI(Date startDate, Date endDate);
  public List<Chart> getTicketByServiceAreaKPI(Date startDate, Date endDate);
}
