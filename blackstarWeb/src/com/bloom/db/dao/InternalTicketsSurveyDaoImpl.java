package com.bloom.db.dao;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;

public class InternalTicketsSurveyDaoImpl extends AbstractDAO 
                        implements InternalTicketsSurveyDao {

	
  public List<JSONObject> getSurveyTable(Integer userId){
	String sql = "CALL GetBloomSurveyTable(?)";
	return getJdbcTemplate().query(sql, new Object[]{userId}, new JSONRowMapper());
  }
  
  public List<JSONObject> getPendingSurveyTable(Integer userId){
	String sql = "CALL GetBloomPendingSurveyTable(?)";
	return getJdbcTemplate().query(sql, new Object[]{userId}, new JSONRowMapper());
  }
  
  public void insertSurvey(Integer ticketId, Integer evaluation, String comments
		                                                       , Date created) {
	String sql = "CALL InsertBloomSurvey(?,?,?,?)";
	getJdbcTemplate().update(sql, new Object[]{ticketId, evaluation, comments
			                                                     , created});
  }
}
