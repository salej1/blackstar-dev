package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;

public interface ServiceOrderDAO {

	public Serviceorder findServiceOrder();
	public List<Serviceorder> selectAllServiceOrder();
	public Serviceorder getServiceOrderById(int id);
	public Serviceorder getServiceOrderByNum(String num);
	public int insertServiceOrder();
	public boolean updateServiceOrder(Serviceorder so);
	public OrderserviceDTO getServiceOrderByIdOrNumber(Integer serviceOrderId, String orderNumber);
	public List<FollowUpDTO> getFollows (Integer serviceOrderId);
}
