package com.bloom.services;

import java.text.SimpleDateFormat;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.services.AbstractService;
import com.bloom.db.dao.InternalTicketsSurveyDao;

public class InternalTicketsSurveyServiceImpl extends AbstractService 
                                              implements InternalTicketsSurveyService{

  private InternalTicketsSurveyDao dao;

  public InternalTicketsSurveyDao getDao() {
	return dao;
  }

  public void setDao(InternalTicketsSurveyDao dao) {
	this.dao = dao;
  }
  
  public String getSurveyTable(Integer userId){
	List<JSONObject> jsonList = dao.getSurveyTable(userId);
	if (jsonList != null){
		return jsonList.toString();
	}
	return "";
  }
  
  public String getPendingSurveyTable(Integer userId){
	List<JSONObject> jsonList = dao.getPendingSurveyTable(userId);
	if (jsonList != null){
	  return jsonList.toString();
	}
	return "";
  }
  
  public void insertSurvey(Integer ticketId, Integer evaluation, String comments
                                            , String created) throws Exception {
	 SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");	  
	 dao.insertSurvey(ticketId, evaluation, comments, df.parse(created));
  }
}
