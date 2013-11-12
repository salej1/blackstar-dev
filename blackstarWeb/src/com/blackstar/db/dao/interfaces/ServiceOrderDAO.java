package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Serviceorder;

public interface ServiceOrderDAO {

	public Serviceorder findServiceOrder();
	public List<Serviceorder> selectAllServiceOrder();
	public Serviceorder getServiceOrderById(int id);
	public Serviceorder getServiceOrderByNum(String num);
	public int insertServiceOrder();
	public boolean updateServiceOrder(Serviceorder so);
}
