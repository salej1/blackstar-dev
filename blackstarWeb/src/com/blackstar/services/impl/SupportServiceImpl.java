package com.blackstar.services.impl;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;
import java.util.UUID;

import com.blackstar.common.Globals;
import com.blackstar.db.dao.SupportDAO;
import com.blackstar.model.BlackstarGuid;
import com.blackstar.services.GmailService;
import com.blackstar.services.SupportService;

public class SupportServiceImpl implements SupportService {
	SupportDAO dao;
	GmailService gmServ;
	
	public void setDao(SupportDAO dao){
		this.dao = dao;
	}

	public void setMailService(GmailService mailService) {
		this.gmServ = mailService;
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

	@Override
	public boolean isGuidValid(String guid) {
		if(guid == null){
			return false;
		}
		else{
			List<BlackstarGuid> g = dao.getGuid(guid);
			if(g == null || g.size() == 0){
				return false;
			}
			else{
				try {
					if(Globals.getLocalTime().compareTo(g.get(0).getExpires()) < 0){
						return true;
					}
					else{
						return false;
					}
				} catch (ParseException e) {
					return false;
				}
			}
		}
	}

	@Override
	public void newGuid() {
		BlackstarGuid guid = new BlackstarGuid();
		guid.setGuid(UUID.randomUUID().toString());
		
		Calendar c = Calendar.getInstance(TimeZone.getTimeZone(Globals.DEFAULT_TIME_ZONE));
		c.add(Calendar.HOUR, 1);
		guid.setExpires(c.getTime());
		
		dao.saveGuid(guid);
		String link = Globals.GOOGLE_CONTEXT_URL + "/support/show.do?code=" + guid.getGuid();
		String body = "<a href=\"" + link + "\">" + link + "</a>";
		gmServ.sendEmail(Globals.GPOSAC_DEFAULT_SENDER, Globals.GPOSAC_DEFAULT_SENDER, "Link de servicio", body);
		
	}

}
