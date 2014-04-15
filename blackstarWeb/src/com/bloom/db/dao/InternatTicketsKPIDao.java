package com.bloom.db.dao;

import java.util.List;

import org.json.JSONObject;

public interface InternatTicketsKPIDao {

  public List<JSONObject> getTicketsByUser();
  public List<JSONObject> getTicketByOfficeKPI();
  public List<JSONObject> getTicketByAreaKPI();
  public List<JSONObject> getTicketByDayKPI();
  public List<JSONObject> getTicketByProjectKPI();
  public List<JSONObject> getTicketByServiceAreaKPI();
  
}
