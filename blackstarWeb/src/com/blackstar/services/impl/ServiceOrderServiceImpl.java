package com.blackstar.services.impl;

import java.util.List;

import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.ServiceOrderService;

public class ServiceOrderServiceImpl extends AbstractService 
                                           implements ServiceOrderService{

  private ServiceOrderDAO dao = null;
    
  public void setDao(ServiceOrderDAO dao) {
	this.dao = dao;
  }

  public OrderserviceDTO getServiceOrderByIdOrNumber(Integer serviceOrderId, String orderNumber){
	return dao.getServiceOrderByIdOrNumber(serviceOrderId, orderNumber);
  }
  
  public List<FollowUpDTO> getFollows (Integer serviceOrderId){
	return dao.getFollows(serviceOrderId);
  }
}
