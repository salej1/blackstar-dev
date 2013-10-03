package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Serviceorder;

public interface ServiceOrderDAO {

	public Serviceorder findServiceOrder();
	public List<Serviceorder> selectAllServiceOrder();
	public Serviceorder getServiceOrderByTicketId(int id);
	public int insertServiceOrder();
	public boolean updateServiceOrder();
}
