package com.blackstar.web;

import java.io.Serializable;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;

import com.blackstar.db.dao.impl.MySQLPolicyDAO;
import com.blackstar.db.dao.impl.MySQLTicketDAO;
import com.blackstar.db.dao.impl.MySQLTicketStatusDAO;
import com.blackstar.model.Policy;
import com.blackstar.model.Servicecenter;
import com.blackstar.model.Ticket;
import com.blackstar.model.Ticketstatus;

@ManagedBean
@SessionScoped
public class TicketPageBean implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8179879917931949668L;
	
	private Ticket ticket;
	private Policy policy;
	private Ticketstatus ticketStatus;
	
	private MySQLTicketDAO ticketDao = new MySQLTicketDAO();
	private MySQLPolicyDAO policyDao = new MySQLPolicyDAO();
	private MySQLTicketStatusDAO ticketStatusDao = new MySQLTicketStatusDAO();
	
	public TicketPageBean() {
		this.ticket = ticketDao.getTicketById(1);
		this.policy = policyDao.getPolicyById(ticket.getPolicyId());
		this.ticketStatus = ticketStatusDao.getTicketStatusById(ticket.getTicketStatusId());
	}

	public Ticket getTicket() {
		return ticket;
	}

	public void setTicket(Ticket ticket) {
		this.ticket = ticket;
	}

	public Policy getPolicy() {
		return policy;
	}

	public void setPolicy(Policy policy) {
		this.policy = policy;
	}

	public Ticketstatus getTicketStatus() {
		return ticketStatus;
	}

	public void setTicketStatus(Ticketstatus ticketStatus) {
		this.ticketStatus = ticketStatus;
	}
}
