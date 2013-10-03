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
 * Ticket generated by hbm2java
 */
@Entity
@Table(name = "ticket", catalog = "blackstarDb")
public class Ticket implements java.io.Serializable {

	private Integer ticketId;
	private Integer policyId;
	private Short serviceId;
	private String user;
	private String observations;
	private Character ticketStatusId;
	private Short realResponseTime;
	private Date arrival;
	private Long employee;
	private String asignee;
	private Date closed;
	private Date solutionTime;
	private Short solutionTimeDeviationHr;
	private Date created;
	private String createdBy;
	private String createdByUsr;
	private Date modified;
	private String modifiedBy;
	private String modifiedByUsr;

	public Ticket() {
	}

	public Ticket(Integer ticketId, Integer policyId, Short serviceId, String user,
			String observations, Character ticketStatusId,
			Short realResponseTime, Date arrival, Long employee,
			String asignee, Date closed, Date solutionTime,
			Short solutionTimeDeviationHr, Date created, String createdBy,
			String createdByUsr, Date modified, String modifiedBy,
			String modifiedByUsr) {
		this.ticketId = ticketId;
		this.policyId = policyId;
		this.serviceId = serviceId;
		this.user = user;
		this.observations = observations;
		this.ticketStatusId = ticketStatusId;
		this.realResponseTime = realResponseTime;
		this.arrival = arrival;
		this.employee = employee;
		this.asignee = asignee;
		this.closed = closed;
		this.solutionTime = solutionTime;
		this.solutionTimeDeviationHr = solutionTimeDeviationHr;
		this.created = created;
		this.createdBy = createdBy;
		this.createdByUsr = createdByUsr;
		this.modified = modified;
		this.modifiedBy = modifiedBy;
		this.modifiedByUsr = modifiedByUsr;
	}

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "ticketId", unique = true, nullable = false)
	public Integer getTicketId() {
		return this.ticketId;
	}

	public void setTicketId(Integer ticketId) {
		this.ticketId = ticketId;
	}

	@Column(name = "policyId")
	public Integer getPolicyId() {
		return this.policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	@Column(name = "serviceId")
	public Short getServiceId() {
		return this.serviceId;
	}

	public void setServiceId(Short serviceId) {
		this.serviceId = serviceId;
	}

	@Column(name = "user", length = 8)
	public String getUser() {
		return this.user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	@Column(name = "observations", length = 65535)
	public String getObservations() {
		return this.observations;
	}

	public void setObservations(String observations) {
		this.observations = observations;
	}

	@Column(name = "ticketStatusId", length = 1)
	public Character getTicketStatusId() {
		return this.ticketStatusId;
	}

	public void setTicketStatusId(Character ticketStatusId) {
		this.ticketStatusId = ticketStatusId;
	}

	@Column(name = "realResponseTime")
	public Short getRealResponseTime() {
		return this.realResponseTime;
	}

	public void setRealResponseTime(Short realResponseTime) {
		this.realResponseTime = realResponseTime;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "arrival", length = 19)
	public Date getArrival() {
		return this.arrival;
	}

	public void setArrival(Date arrival) {
		this.arrival = arrival;
	}

	@Column(name = "employee")
	public Long getEmployee() {
		return this.employee;
	}

	public void setEmployee(Long employee) {
		this.employee = employee;
	}

	@Column(name = "asignee", length = 8)
	public String getAsignee() {
		return this.asignee;
	}

	public void setAsignee(String asignee) {
		this.asignee = asignee;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "closed", length = 19)
	public Date getClosed() {
		return this.closed;
	}

	public void setClosed(Date closed) {
		this.closed = closed;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "solutionTime", length = 19)
	public Date getSolutionTime() {
		return this.solutionTime;
	}

	public void setSolutionTime(Date solutionTime) {
		this.solutionTime = solutionTime;
	}

	@Column(name = "solutionTimeDeviationHr")
	public Short getSolutionTimeDeviationHr() {
		return this.solutionTimeDeviationHr;
	}

	public void setSolutionTimeDeviationHr(Short solutionTimeDeviationHr) {
		this.solutionTimeDeviationHr = solutionTimeDeviationHr;
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

	@Column(name = "modifiedBy", length = 8)
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
