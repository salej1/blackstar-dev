package com.bloom.services;

import java.util.List;

import com.blackstar.model.Chart;


public interface InternatTicketsKPIService {

  public String getTicketsByUser();
  public List<Chart> getTicketByOfficeKPI();
  public List<Chart> getTicketByAreaKPI();
  public List<Chart> getTicketByDayKPI();
  public List<Chart> getTicketByProjectKPI();
  public List<Chart> getTicketByServiceAreaKPI();
}
