package com.blackstar.services.impl;


import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.IssueDAO;
import com.blackstar.model.FollowUpReferenceType;
import com.blackstar.model.Issue;
import com.blackstar.model.IssueStatus;
import com.blackstar.model.dto.IssueDTO;
import com.blackstar.services.interfaces.IssueService;

public class IssueServiceImpl implements IssueService {
	IssueDAO dao;

	public void setDao(IssueDAO dao) {
		this.dao = dao;
	}

	@Override
	public List<JSONObject> getUserIssues(String user) {
		return dao.getUserIssues(user);
	}

	@Override
	public IssueDTO getIssueById(String issueTypeId, Integer issueId) {
		return dao.getIssueById(issueTypeId, issueId);
	}

	@Override
	public List<FollowUpReferenceType> getReferenceTypeList() {
		return dao.getReferenceTypeList();
	}

	@Override
	public Integer saveIssue(IssueDTO issue, String user, String who) {
		Integer issueId = 0;
		
		if(issue.getReferenceTypeId().equals("I")){
			// Necesitamos guardar el issue, despues agregar el followUp
			Issue i = new Issue();
			i.setIssueId(issue.getReferenceId());
			i.setIssueNumber(issue.getReferenceNumber());
			i.setAsignee(issue.getReferenceAsignee());
			if(issue.getReferenceId() != null && issue.getReferenceId() > 0){
				i.setModified(issue.getModified());
				i.setModifiedBy(who);
				i.setModifiedByUsr(user);
			}
			else{
				i.setCreated(issue.getCreated());
				i.setCreatedBy(who);
				i.setCreatedByUsr(user);
			}
			i.setProject(issue.getProject());
			i.setCustomer(issue.getCustomer());
			i.setDetail(issue.getDetail());
			i.setIssueStatusId(issue.getReferenceStatusId());
			i.setTitle(issue.getTitle());
			i.setDueDate(issue.getDueDate());
			
			issueId = dao.saveIssue(i);
			
			// Enviar email de asignacion
			
			return issueId;
		}	
		else{
			// Es ticket o SO, nada uq hacer aqui
			return 0;
		}
	}

	@Override
	public String getNewIssueNumber() {
		return dao.getNewIssueNumber();
	}

	@Override
	public List<IssueStatus> getIssueStatusList() {
		return dao.getIssueStatusList();
	}

	@Override
	public List<JSONObject> getUserWatchingIssues(String user) {
		return dao.getUserWatchingIssues(user);
	}

	@Override
	public void addFollowUp(Integer id, Date timeStamp, String sender,
			String asignee, String message) {
		dao.addFollowUp(id, timeStamp, sender, asignee, message);
	}
}
