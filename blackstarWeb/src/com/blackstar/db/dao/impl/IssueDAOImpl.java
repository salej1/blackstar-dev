package com.blackstar.db.dao.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.IssueDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.FollowUpReferenceType;
import com.blackstar.model.Issue;
import com.blackstar.model.IssueStatus;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.IssueDTO;

public class IssueDAOImpl extends AbstractDAO implements IssueDAO {

	@Override
	public List<JSONObject> getUserIssues(String user) {
		String sql = "CALL GetUserPendingIssues(?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{user}, new JSONRowMapper());
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public IssueDTO getIssueById(String issueTypeId, Integer issueId) {
		Issue issue;
		List<FollowUpDTO> followUp;
		
		String sql = "CALL GetIssueById(?)";
		issue = (Issue)getJdbcTemplate().queryForObject(sql, new Object[]{issueId}, getMapperFor(Issue.class));
		
		sql = "CALL GetFollowUpByIssue(?)";
		followUp = (List<FollowUpDTO>)getJdbcTemplate().query(sql, new Object[]{issueId}, getMapperFor(FollowUpDTO.class));
		
		IssueDTO dto = new IssueDTO(issue);
		dto.setFollowUpList(followUp);
		
		return dto;
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<FollowUpReferenceType> getReferenceTypeList() {
		String sql = "CALL GetFollowUpReferenceTypes()";
		List<FollowUpReferenceType> list = (List<FollowUpReferenceType>)getJdbcTemplate().query(sql, getMapperFor(FollowUpReferenceType.class));
		return list;
	}

	@Override
	public Integer saveIssue(Issue issue) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String sql = "CALL SaveIssue(?,?,?,?,?,?,?,?,?,?,?,?)";
		Integer issueId = (Integer)getJdbcTemplate().queryForObject(sql, new Object[]{
				issue.getIssueId(),
				issue.getIssueNumber(),
				issue.getIssueStatusId(),
				issue.getTitle(),
				issue.getDetail(),
				issue.getProject(),
				issue.getCustomer(),
				issue.getAsignee(),
				sdf.format(issue.getModified() == null? issue.getCreated() : issue.getModified()),
				issue.getModifiedBy() == null? issue.getCreatedBy() : issue.getModifiedBy(),
				issue.getModifiedByUsr() == null? issue.getCreatedByUsr() : issue.getModifiedByUsr(),
				issue.getDueDate()
		}, Integer.class);
		
		return issueId;
	}

	@Override
	public String getNewIssueNumber() {
		String sql = "CALL GetNextIssueNumber()";
		String number = getJdbcTemplate().queryForObject(sql, String.class);
		return number;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<IssueStatus> getIssueStatusList() {
		String sql = "CALL GetIssueStatusList()";
		List<IssueStatus> list = (List<IssueStatus>)getJdbcTemplate().query(sql, getMapperFor(IssueStatus.class));
		return list;
	}

	@Override
	public List<JSONObject> getUserWatchingIssues(String user) {
		String sql = "CALL GetUserWatchingIssues(?)";
		List<JSONObject> list = getJdbcTemplate().query(sql, new Object[]{user}, new JSONRowMapper());
		return list;
	}
	
	@Override
	public void addFollowUp(Integer id, java.util.Date timeStamp,
			String sender, String asignee, String message) {
		String sql = "CALL AddFollowUpToIssue(?,?,?,?,?)";
		getJdbcTemplate().update(sql, new Object[]{id, timeStamp, sender, asignee, message});

	}
}
