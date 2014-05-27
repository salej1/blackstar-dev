package com.bloom.services;


public interface InternalTicketsSurveyService {

  public String getSurveyTable(Integer userId);
  public String getPendingSurveyTable(Integer userId);
  public void insertSurvey(Integer ticketId, Integer evaluation, String comments
                                             , String created) throws Exception;
  
}
