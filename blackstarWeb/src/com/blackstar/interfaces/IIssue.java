package com.blackstar.interfaces;

import java.util.Date;
import java.util.List;

import com.blackstar.model.Followup;

public interface IIssue {
	public Integer getReferenceTypeId();
	public void setReferenceTypeId(Integer referenceTypeId);
	public Integer getReferenceId();
	public void setReferenceId(Integer referenceId);
	public Integer getReferenceNumber();
	public void setReferenceNumber(Integer referenceNumber);
	public String getReferenceStatusId();
	public void setReferenceStatusId(String referenceStatusId);
	public String getReferenceStatus();
	public void setReferenceStatus(String referenceStatus);
	public String getTitle();
	public void setTitle(String title);
	public String getDetail();
	public void setDetail(String detail);
	public String getProject();
	public void setProject(String project);
	public String getCustomer();
	public void setCustomer(String customer);
	public String getAsignee();
	public void setAsignee(String asignee);
	public Date getCreated();
	public void setCreated(Date created);
	public String getCreatedBy();
	public void setCreatedBy(String createdBy);
	public String getCreatedByUsr();
	public void setCreatedByUsr(String createdByUsr);
	public Date getModified();
	public void setModified(Date modified);
	public String getModifiedBy();
	public void setModifiedBy(String modifiedBy);
	public String getModifiedByUsr();
	public void setModifiedByUsr(String modifiedByUsr);
	public List<Followup> getFollowUpList();
	public void setFollowUpList(List<Followup> followUpList);
}
