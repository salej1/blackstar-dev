package com.blackstar.services.impl;

import java.util.List;

import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.UpsServiceDTO;
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

@Override
public AirCoServiceDTO getAirCoService(Integer aaServiceId) {
	return dao.getAirCoService(aaServiceId);
}

@Override
public BatteryServiceDTO getBateryService(Integer bbServiceId) {
	BatteryServiceDTO batteryService = dao.getBateryService(bbServiceId);
	batteryService.setCells(dao.getBatteryCells(bbServiceId));
	return batteryService;
}

@Override
public EmergencyPlantServiceDTO getEmergencyPlantService(Integer epServiceId) {
	return dao.getEmergencyPlantService(epServiceId);
}

@Override
public PlainServiceDTO getPlainService(Integer plainServiceId) {
	return dao.getPlainService(plainServiceId);
}

@Override
public UpsServiceDTO getUpsService(Integer upsServiceId) {
	return dao.getUpsService(upsServiceId);
}

@Override
public void saveAirCoService(AirCoServiceDTO service) {
	// TODO Auto-generated method stub
	
}

@Override
public void saveBateryService(BatteryServiceDTO service) {
	// TODO Auto-generated method stub
	
}

@Override
public void saveEmergencyPlantService(EmergencyPlantServiceDTO service) {
	// TODO Auto-generated method stub
	
}

@Override
public void savePlainService(PlainServiceDTO service) {
	// TODO Auto-generated method stub
	
}

@Override
public void saveUpsService(UpsServiceDTO service) {
	// TODO Auto-generated method stub
	
}
  
  
}
