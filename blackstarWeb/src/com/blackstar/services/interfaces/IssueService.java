package com.blackstar.services.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.FollowUpReferenceType;
import com.blackstar.model.IssueStatus;
import com.blackstar.model.dto.IssueDTO;


public interface IssueService {
	public List<JSONObject> getUserIssues(String user);
	public IssueDTO getIssueById(String issueTypeId, Integer issueId);
	public List<FollowUpReferenceType> getReferenceTypeList();
	public Integer saveIssue(IssueDTO issue, String user, String who);
	public String getNewIssueNumber();
	public List<IssueStatus> getIssueStatusList();
	public List<JSONObject> getUserWatchingIssues(String user);
}
