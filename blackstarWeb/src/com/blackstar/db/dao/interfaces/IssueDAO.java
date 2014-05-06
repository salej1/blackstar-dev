package com.blackstar.db.dao.interfaces;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.FollowUpReferenceType;
import com.blackstar.model.Issue;
import com.blackstar.model.IssueStatus;
import com.blackstar.model.dto.IssueDTO;

public interface IssueDAO {
	public List<JSONObject> getUserIssues(String user);
	public IssueDTO getIssueById(String issueTypeId, Integer issueId);
	public List<FollowUpReferenceType> getReferenceTypeList();
	public Integer saveIssue(Issue issue);
	public String getNewIssueNumber();
	public List<IssueStatus> getIssueStatusList();
	public List<JSONObject> getUserWatchingIssues(String user);
	public void addFollowUp(Integer id, Date timeStamp, String sender, String asignee, String message);
}
