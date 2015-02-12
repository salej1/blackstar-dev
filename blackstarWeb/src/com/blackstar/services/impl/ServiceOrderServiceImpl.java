package com.blackstar.services.impl;

import java.text.ParseException;
import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.common.Globals;
import com.blackstar.db.dao.interfaces.EquipmentTypeDAO;
import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.db.dao.interfaces.ServiceTypeDAO;
import com.blackstar.model.Equipmenttype;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.ServiceStatusDTO;
import com.blackstar.model.dto.ServiceTypeDTO;
import com.blackstar.model.dto.UpsServiceDTO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.ServiceOrderService;

public class ServiceOrderServiceImpl extends AbstractService 
                                           implements ServiceOrderService{

  private ServiceOrderDAO dao = null;
    
  public void setDao(ServiceOrderDAO dao) {
	this.dao = dao;
  }
  
  private ServiceTypeDAO typeDao = null;

  public void setTypeDao(ServiceTypeDAO typeDao) {
	this.typeDao = typeDao;
  }
  
  private EquipmentTypeDAO equipmentDao = null;

  public void setEquipmentDao(EquipmentTypeDAO equipmentDao) {
	  this.equipmentDao = equipmentDao;
  }

public OrderserviceDTO getServiceOrderByIdOrNumber(Integer serviceOrderId, String orderNumber){
	return dao.getServiceOrderByIdOrNumber(serviceOrderId, orderNumber);
  }
  
  public List<FollowUpDTO> getFollows (Integer serviceOrderId){
	return dao.getFollows(serviceOrderId);
  }

@Override
public AirCoServiceDTO getAirCoService(Integer serviceOrderId) {
	return dao.getAirCoService(serviceOrderId);
}

@Override
public BatteryServiceDTO getBateryService(Integer serviceOrderId) {
	BatteryServiceDTO batteryService = dao.getBateryService(serviceOrderId);
	batteryService.setCells(dao.getBatteryCells(batteryService.getBbServiceId()));
	return batteryService;
}

@Override
public EmergencyPlantServiceDTO getEmergencyPlantService(Integer serviceOrderId) {
	return dao.getEmergencyPlantService(serviceOrderId);
}

@Override
public PlainServiceDTO getPlainService(Integer serviceOrderId) {
	return dao.getPlainService(serviceOrderId);
}

@Override
public UpsServiceDTO getUpsService(Integer serviceOrderId) {
	return dao.getUpsService(serviceOrderId);
}

@Override
public void saveAirCoService(AirCoServiceDTO service, String createdBy, String createdByUsr) throws Exception {
	
	dao.saveAirCoService(service, Globals.getLocalTime(), createdBy, createdByUsr);
}

@Override
public void saveBateryService(BatteryServiceDTO service, String createdBy, String createdByUsr) throws Exception {
	// TODO Auto-generated method stub
	dao.saveBateryService(service, Globals.getLocalTime(), createdBy, createdByUsr);
}

@Override
public void saveEmergencyPlantService(EmergencyPlantServiceDTO service, String createdBy, String createdByUsr) throws Exception {
	// TODO Auto-generated method stub
	dao.saveEmergencyPlantService(service, Globals.getLocalTime(), createdBy, createdByUsr);
}

@Override
public void savePlainService(PlainServiceDTO service, String createdBy, String createdByUsr) throws Exception {
	// TODO Auto-generated method stub
	dao.savePlainService(service, Globals.getLocalTime(), createdBy, createdByUsr);
}

@Override
public void saveUpsService(UpsServiceDTO service, String createdBy, String createdByUsr) throws Exception {
	// TODO Auto-generated method stub
	dao.saveUpsService(service, Globals.getLocalTime(), createdBy, createdByUsr);
}

@Override
public int saveServiceOrder(Serviceorder service, String createdBy,
		String createdByUsr) {
	try {
		service.setCreated(Globals.getLocalTime());
	} catch (ParseException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	service.setCreatedBy(createdBy);
	service.setCreatedByUsr(createdByUsr);
	 return dao.insertServiceOrder(service);
}

@Override
public void updateServiceOrder(Serviceorder service, String modifiedBy,
		String modifiedByUsr) {
	// TODO Auto-generated method stub
	try {
		service.setModified(Globals.getLocalTime());
	} catch (ParseException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	service.setModifiedBy(modifiedBy);
	service.setModifiedByUsr(modifiedByUsr);
	dao.updateServiceOrder(service);
}

@Override
public String getNewServiceNumber(String equipmentType) {
	return dao.getNewServiceNumber(equipmentType);
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
public String getLimitedServiceOrdersHistoryJson(String user){
	List<JSONObject> history = dao.getLimitedServiceOrdersHistory(user);
	return history.toString();
}

@Override
public String getEquipmentByType(String type) {
	List<JSONObject> equipment = dao.getEquipmentByType(type);
	return equipment.toString();
}

@Override
public List<ServiceTypeDTO> getServiceTypeList() {
	return typeDao.getServiceTypeList();
}

@Override
public String getServiceOrderTypeBySOId(Integer serviceOrderId) {
	return dao.getServiceOrderTypeBySOId(serviceOrderId);
}

@Override
public List<ServiceStatusDTO> getServiceStatusList() {
	return dao.getServiceStatusList();
}

@Override
public List<FollowUpDTO> getServiceFollowUps(Integer serviceOrderId) {
	// TODO Auto-generated method stub
	return null;
}

@Override
public String getNewServiceNumber() {
	return dao.getNewServiceNumber();
}

@Override
public List<Equipmenttype> getEquipmentTypeList() {
	return equipmentDao.selectAllEquipmentType();
}

@Override
public String getServiceOrderDetails(String orderNumber) {
	List<JSONObject> list = dao.getServiceOrderDetails(orderNumber);
	if(list.size() > 0){
		return list.get(0).toString();
	}
	else{
		return "{\"error\":\"sin datos\"}";
	}
}

@Override
public String getServiceOrdersByDate(Date startDate) {
	return dao.getServiceOrdersByDate(startDate).toString();
}
  
  
}
