package com.blackstar.services.impl;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.model.Serviceorder;
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
public void saveAirCoService(AirCoServiceDTO service, String createdBy, String createdByUsr) {
	
	dao.saveAirCoService(service, new Date(), createdBy, createdByUsr);
}

@Override
public void saveBateryService(BatteryServiceDTO service, String createdBy, String createdByUsr) {
	// TODO Auto-generated method stub
	dao.saveBateryService(service, new Date(), createdBy, createdByUsr);
}

@Override
public void saveEmergencyPlantService(EmergencyPlantServiceDTO service, String createdBy, String createdByUsr) {
	// TODO Auto-generated method stub
	dao.saveEmergencyPlantService(service, new Date(), createdBy, createdByUsr);
}

@Override
public void savePlainService(PlainServiceDTO service, String createdBy, String createdByUsr) {
	// TODO Auto-generated method stub
	dao.savePlainService(service, new Date(), createdBy, createdByUsr);
}

@Override
public void saveUpsService(UpsServiceDTO service, String createdBy, String createdByUsr) {
	// TODO Auto-generated method stub
	dao.saveUpsService(service, new Date(), createdBy, createdByUsr);
}

@Override
public int saveServiceOrder(Serviceorder service, String createdBy,
		String createdByUsr) {
	service.setCreated(new Date());
	service.setCreatedBy(createdBy);
	service.setCreatedByUsr(createdByUsr);
	 return dao.insertServiceOrder(service);
}

@Override
public void updateServiceOrder(Serviceorder service, String modifiedBy,
		String modifiedByUsr) {
	// TODO Auto-generated method stub
	service.setModified(new Date());
	service.setModifiedBy(modifiedBy);
	service.setModifiedByUsr(modifiedByUsr);
	dao.updateServiceOrder(service);
}

@Override
public String getNewServiceNumber(Integer policyId) {
	return dao.getNewServiceNumber(policyId);
}

@Override
public String getServiceOrdersByStatus(String status) {
	List<JSONObject> orders = dao.getServiceOrdersByStatus(status);
	return orders.toString();
}

@Override
public String getServiceOrderHistory() {
	List<JSONObject> history = dao.getServiceOrderHistory();
	return history.toString();
}

@Override
public String getEquipmentByType(String type) {
	List<JSONObject> equipment = dao.getEquipmentByType(type);
	return equipment.toString();
}
  
  
}
