package com.blackstar.web;

import java.io.Serializable;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;

import com.blackstar.db.DAOFactory;
import com.blackstar.model.Equipmenttype;
import com.blackstar.model.Followup;
import com.blackstar.model.Office;
import com.blackstar.model.Policy;
import com.blackstar.model.Policycontact;
import com.blackstar.model.Servicecenter;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.Ticket;
import com.blackstar.model.Ticketstatus;

@ManagedBean
@SessionScoped
public class TicketPageBean implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8179879917931949668L;
	private DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
	
	private Ticket ticket;
	private Policy policy;
	private Policycontact policyContact;
	private Ticketstatus ticketStatus;
	private Equipmenttype equipmentType;
	private Servicecenter serviceCenter;
	private Office office;
	private Serviceorder serviceOrder;
	private Followup followUp;
	
	public TicketPageBean() {
		this.ticket = daoFactory.getTicketDAO().getTicketById(1);
		this.ticketStatus = daoFactory.getTicketStatusDAO().getTicketStatusById(ticket.getTicketStatusId());
		this.policy = daoFactory.getPolicyDAO().getPolicyById(ticket.getPolicyId());
		this.equipmentType = daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
		this.serviceCenter = daoFactory.getServiceCenterDAO().getServiceCenterById(policy.getServiceCenterId());
		this.office = daoFactory.getOfficeDAO().getOfficeById(policy.getOfficeId());
		//this.serviceOrder = daoFactory.getServiceOrderDAO().getServiceOrderBy(ticket.getTicketId());
		this.followUp = daoFactory.getFollowUpDAO().getFollowUpByTicketId(ticket.getTicketId());
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

	public Policycontact getPolicyContact() {
		return policyContact;
	}

	public void setPolicyContact(Policycontact policyContact) {
		this.policyContact = policyContact;
	}

	public Equipmenttype getEquipmentType() {
		return equipmentType;
	}

	public void setEquipmentType(Equipmenttype equipmentType) {
		this.equipmentType = equipmentType;
	}

	public Servicecenter getServiceCenter() {
		return serviceCenter;
	}

	public void setServiceCenter(Servicecenter serviceCenter) {
		this.serviceCenter = serviceCenter;
	}

	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}

	public Serviceorder getServiceOrder() {
		return serviceOrder;
	}

	public void setServiceOrder(Serviceorder serviceOrder) {
		this.serviceOrder = serviceOrder;
	}

	public Followup getFollowUp() {
		return followUp;
	}

	public void setFollowUp(Followup followUp) {
		this.followUp = followUp;
	}
}
