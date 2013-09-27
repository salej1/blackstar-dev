package com.blackstar.model;

// Generated Sep 23, 2013 12:57:18 AM by Hibernate Tools 3.4.0.CR1

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Followup generated by hbm2java
 */
@Entity
@Table(name = "followup", catalog = "blackstarDb")
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

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "followUpId", unique = true, nullable = false)
	public Integer getFollowUpId() {
		return this.followUpId;
	}

	public void setFollowUpId(Integer followUpId) {
		this.followUpId = followUpId;
	}

	@Column(name = "ticketId")
	public Integer getTicketId() {
		return this.ticketId;
	}

	public void setTicketId(Integer ticketId) {
		this.ticketId = ticketId;
	}

	@Column(name = "serviceOrderId")
	public Integer getServiceOrderId() {
		return this.serviceOrderId;
	}

	public void setServiceOrderId(Integer serviceOrderId) {
		this.serviceOrderId = serviceOrderId;
	}

	@Column(name = "asignee", length = 50)
	public String getAsignee() {
		return this.asignee;
	}

	public void setAsignee(String asignee) {
		this.asignee = asignee;
	}

	@Column(name = "followup", length = 65535)
	public String getFollowup() {
		return this.followup;
	}

	public void setFollowup(String followup) {
		this.followup = followup;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "created", length = 19)
	public Date getCreated() {
		return this.created;
	}

	public void setCreated(Date created) {
		this.created = created;
	}

	@Column(name = "createdBy", length = 8)
	public String getCreatedBy() {
		return this.createdBy;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	@Column(name = "createdByUsr", length = 50)
	public String getCreatedByUsr() {
		return this.createdByUsr;
	}

	public void setCreatedByUsr(String createdByUsr) {
		this.createdByUsr = createdByUsr;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "modified", length = 19)
	public Date getModified() {
		return this.modified;
	}

	public void setModified(Date modified) {
		this.modified = modified;
	}

	@Column(name = "modifiedBy", length = 50)
	public String getModifiedBy() {
		return this.modifiedBy;
	}

	public void setModifiedBy(String modifiedBy) {
		this.modifiedBy = modifiedBy;
	}

	@Column(name = "modifiedByUsr", length = 50)
	public String getModifiedByUsr() {
		return this.modifiedByUsr;
	}

	public void setModifiedByUsr(String modifiedByUsr) {
		this.modifiedByUsr = modifiedByUsr;
	}

}
