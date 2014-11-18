package com.bloom.services;


public interface InternalTicketsSurveyService {

  public String getSurveyTable(Integer userId);
  public String getPendingSurveyTable(Integer userId);
  public void insertSurvey(Integer ticketId, String ticketNumber, Integer evaluation, String comments
                                             , String created, String createdByUsr) throws Exception;
  
}
