package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Followup;

public interface FollowUpDAO {

	public Followup findFollowUp();
	public List<Followup> selectAllFollowUp();
	public List<Followup> getFollowUpByServiceOrderId(int id);
	public List<Followup> getFollowUpByTicketId(int id);
	public int insertFollowUp();
	public boolean updateFollowUp();
}
