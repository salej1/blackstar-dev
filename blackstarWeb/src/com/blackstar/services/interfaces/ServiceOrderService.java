package com.blackstar.services.interfaces;

import java.util.List;

import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;

public interface ServiceOrderService {
	
  public OrderserviceDTO getServiceOrderByIdOrNumber(Integer serviceOrderId, String orderNumber);
  public List<FollowUpDTO> getFollows (Integer serviceOrderId);
  
}
