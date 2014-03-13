package com.bloom.services;

import java.util.List;

import com.bloom.common.bean.InternalTicketBean;

public interface InternalTicketsService {
	
	public List<InternalTicketBean> getPendingTickets();	
	
}
