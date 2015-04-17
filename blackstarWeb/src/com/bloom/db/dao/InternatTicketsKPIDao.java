package com.bloom.db.dao;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

public interface InternatTicketsKPIDao {

  public List<JSONObject> getTicketsByUser(Date startDate, Date endDate);
  public List<JSONObject> getTicketByOfficeKPI(Date startDate, Date endDate);
  public List<JSONObject> getTicketByAreaKPI(Date startDate, Date endDate);
  public List<JSONObject> getTicketByDayKPI(Date startDate, Date endDate);
  public List<JSONObject> getTicketByProjectKPI(Date startDate, Date endDate);
  public List<JSONObject> getTicketByServiceAreaKPI(Date startDate, Date endDate);
  
}
