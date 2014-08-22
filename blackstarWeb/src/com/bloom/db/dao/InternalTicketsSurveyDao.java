package com.bloom.db.dao;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

public interface InternalTicketsSurveyDao {
	
  public List<JSONObject> getSurveyTable(Integer userId);
  public List<JSONObject> getPendingSurveyTable(Integer userId);
  public void insertSurvey(Integer ticketId, Integer evaluation, String comments
                                                                , Date created);

}
