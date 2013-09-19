package com.blackstar.model;

// Generated 19/09/2013 02:56:42 AM by Hibernate Tools 3.4.0.CR1

import java.util.Date;

/**
 * Followup generated by hbm2java
 */
public class Followup implements java.io.Serializable {

	private Integer followUpId;
	private Integer ticketId;
	private Integer serviceOrderId;
	private String asignee;
	private String followup;
	private Date created;
	private String createdBy;
	private String createdByUsr;
	private Date modified;
	private String modifiedBy;
	private String modifiedByUsr;

	public Followup() {
	}

	public Followup(Integer ticketId, Integer serviceOrderId, String asignee,
			String followup, Date created, String createdBy,
			String createdByUsr, Date modified, String modifiedBy,
			String modifiedByUsr) {
		this.ticketId = ticketId;
		this.serviceOrderId = serviceOrderId;
		this.asignee = asignee;
		this.followup = followup;
		this.created = created;
		this.createdBy = createdBy;
		this.createdByUsr = createdByUsr;
		this.modified = modified;
		this.modifiedBy = modifiedBy;
		this.modifiedByUsr = modifiedByUsr;
	}

	public Integer getFollowUpId() {
		return this.followUpId;
	}

	public void setFollowUpId(Integer followUpId) {
		this.followUpId = followUpId;
	}

	public Integer getTicketId() {
		return this.ticketId;
	}

	public void setTicketId(Integer ticketId) {
		this.ticketId = ticketId;
	}

	public Integer getServiceOrderId() {
		return this.serviceOrderId;
	}

	public void setServiceOrderId(Integer serviceOrderId) {
		this.serviceOrderId = serviceOrderId;
	}

	public String getAsignee() {
		return this.asignee;
	}

	public void setAsignee(String asignee) {
		this.asignee = asignee;
	}

	public String getFollowup() {
		return this.followup;
	}

	public void setFollowup(String followup) {
		this.followup = followup;
	}

	public Date getCreated() {
		return this.created;
	}

	public void setCreated(Date created) {
		this.created = created;
	}

	public String getCreatedBy() {
		return this.createdBy;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	public String getCreatedByUsr() {
		return this.createdByUsr;
	}

	public void setCreatedByUsr(String createdByUsr) {
		this.createdByUsr = createdByUsr;
	}

	public Date getModified() {
		return this.modified;
	}

	public void setModified(Date modified) {
		this.modified = modified;
	}

	public String getModifiedBy() {
		return this.modifiedBy;
	}

	public void setModifiedBy(String modifiedBy) {
		this.modifiedBy = modifiedBy;
	}

	public String getModifiedByUsr() {
		return this.modifiedByUsr;
	}

	public void setModifiedByUsr(String modifiedByUsr) {
		this.modifiedByUsr = modifiedByUsr;
	}

}
