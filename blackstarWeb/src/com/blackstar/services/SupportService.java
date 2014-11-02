package com.blackstar.services;

public interface SupportService{
	public String getServiceOrderDetail(String serviceOrderNumber);
	public String getServiceOrderComments(String serviceOrderNumber);
	public String deleteServiceOrder(String serviceOrderNumber);
	public String deleteServiceOrderPDF(String serviceOrderNumber);
	public String getTicketDetails(String ticketNumber);
	public String getTicketComments(String ticketNumber);
	public String deleteTicket(String ticketNumber);
	public String getBloomTicketDetails(String ticketNumber);
	public String getBloomTicketComments(String ticketNumber);
	public String deleteBloomTicket(String ticketNumber);
	public String deleteFollowUp(Integer followUpId);
}
