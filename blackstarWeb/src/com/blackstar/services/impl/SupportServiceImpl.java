package com.blackstar.services.impl;

import com.blackstar.db.dao.SupportDAO;
import com.blackstar.services.SupportService;

public class SupportServiceImpl implements SupportService {
	SupportDAO dao;
	
	public void setDao(SupportDAO dao){
		this.dao = dao;
	}

	@Override
	public String getServiceOrderDetail(String serviceOrderNumber) {
		return dao.getServiceOrderDetail(serviceOrderNumber);
	}

	@Override
	public String getServiceOrderComments(String serviceOrderNumber) {
		return dao.getServiceOrderComments(serviceOrderNumber);
	}

	@Override
	public String getTicketDetails(String ticketNumber) {
		return dao.getTicketDetails(ticketNumber);
	}

	@Override
	public String getTicketComments(String ticketNumber) {
		return dao.getTicketComments(ticketNumber);
	}

	@Override
	public String getBloomTicketDetails(String ticketNumber) {
		return dao.getBloomTicketDetails(ticketNumber);
	}

	@Override
	public String getBloomTicketComments(String ticketNumber) {
		return dao.getBloomTicketComments(ticketNumber);
	}

	@Override
	public String deleteFollowUp(Integer followUpId) {
		return dao.deleteFollowUp(followUpId);
	}

	@Override
	public String deleteServiceOrder(String serviceOrderNumber) {
		return dao.deleteServiceOrder(serviceOrderNumber);
	}

	@Override
	public String deleteTicket(String ticketNumber) {
		return dao.deleteTicket(ticketNumber);
	}

	@Override
	public String deleteBloomTicket(String ticketNumber) {
		return dao.deleteBloomTicket(ticketNumber);
	}

	@Override
	public String deleteServiceOrderPDF(String serviceOrderNumber) {
		return dao.deleteServiceOrderPDF(serviceOrderNumber);
	}

}
