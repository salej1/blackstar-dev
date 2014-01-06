package com.blackstar.db.dao.interfaces;

import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.BatteryCellServiceDTO;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.UpsServiceDTO;

public interface ServiceOrderDAO {

	public Serviceorder findServiceOrder();
	public List<Serviceorder> selectAllServiceOrder();
	public Serviceorder getServiceOrderById(int id);
	public Serviceorder getServiceOrderByNum(String num);
	public int insertServiceOrder(Serviceorder orderService);
	public boolean updateServiceOrder(Serviceorder orderService);
	
	public OrderserviceDTO getServiceOrderByIdOrNumber(Integer serviceOrderId, String orderNumber);
	public List<FollowUpDTO> getFollows (Integer serviceOrderId);
	
	public AirCoServiceDTO getAirCoService(Integer aaServiceId);
  	public BatteryServiceDTO getBateryService(Integer bbServiceId);
  	public List<BatteryCellServiceDTO> getBatteryCells(Integer bbServiceId);
  	public EmergencyPlantServiceDTO getEmergencyPlantService(Integer epServiceId);
  	public PlainServiceDTO getPlainService(Integer plainServiceId);
  	public UpsServiceDTO getUpsService(Integer upsServiceId);
  	
    public int saveAirCoService (AirCoServiceDTO service, Date created ,String createdBy,String createdByUsr);
    public int saveBateryService (BatteryServiceDTO service, Date created ,String createdBy,String createdByUsr);
    public int saveEmergencyPlantService (EmergencyPlantServiceDTO service, Date created ,String createdBy,String createdByUsr);
    public int savePlainService (PlainServiceDTO service, Date created ,String createdBy,String createdByUsr);
    public int saveUpsService (UpsServiceDTO service, Date created ,String createdBy,String createdByUsr);
    
    public String getNewServiceNumber(Integer policyId);
    
	public List<JSONObject> getServiceOrdersByStatus(String status);
	public List<JSONObject> getServiceOrderHistory();
	
	public List<JSONObject> getEquipmentByType(String type);
	public String getEquipmentTypeBySOId(Integer serviceOrderId);
}
