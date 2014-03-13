package com.bloom.db.dao;

import java.util.List;

import org.json.JSONObject;

import com.bloom.common.bean.InternalTicketBean;

public interface InternalTicketsDao {
	
	public List<InternalTicketBean> getPendingTickets ();
}
