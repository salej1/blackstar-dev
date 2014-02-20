package com.blackstar.db.dao.interfaces;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Customer;
import com.blackstar.model.dto.CustomerDTO;



public interface CustomerDAO 
{
	
	public int insertCustomer(Customer customer);
	public boolean updateCustomer(Customer customer);
	
	public CustomerDTO getCustomerById(Integer id);
	public List<JSONObject> getCustomers();
	public List<JSONObject> getLeaflets();
	
/*	public OrderserviceDTO getServiceOrderByIdOrNumber(Integer serviceOrderId, String orderNumber);
	public List<FollowUpDTO> getFollows (Integer serviceOrderId);
	
	public AirCoServiceDTO getAirCoService(Integer aaServiceId);
  	public BatteryServiceDTO getBateryService(Integer bbServiceId);
  	public List<BatteryCellServiceDTO> getBatteryCells(Integer bbServiceId);
  	public EmergencyPlantServiceDTO getEmergencyPlantService(Integer epServiceId);
  	public PlainServiceDTO getPlainService(Integer plainServiceId);
  	public UpsServiceDTO getUpsService(Integer upsServiceId);*/
  	
    /*public int saveAirCoService (AirCoServiceDTO service, Date created ,String createdBy,String createdByUsr);
    public int saveBateryService (BatteryServiceDTO service, Date created ,String createdBy,String createdByUsr);
    public int saveEmergencyPlantService (EmergencyPlantServiceDTO service, Date created ,String createdBy,String createdByUsr);
    public int savePlainService (PlainServiceDTO service, Date created ,String createdBy,String createdByUsr);
    public int saveUpsService (UpsServiceDTO service, Date created ,String createdBy,String createdByUsr);
    
    public String getNewServiceNumber(Integer policyId);
    public String getNewServiceNumber();*/
  /*  
	public List<JSONObject> getServiceOrdersByStatus(String status);
	public List<JSONObject> getServiceOrderHistory();
	
	public List<JSONObject> getEquipmentByType(String type);
	public String getEquipmentTypeBySOId(Integer serviceOrderId);
	
	public List<ServiceStatusDTO> getServiceStatusList();
	
	public List<FollowUpDTO> getServiceFollowUps(Integer serviceOrderId);*/

}
