package com.blackstar.services.interfaces;

import java.util.List;

import org.json.JSONArray;

import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.UpsServiceDTO;

public interface ServiceOrderService {
	
	// Servicios de desploegue y guardado de una orden de servicio
	public OrderserviceDTO getServiceOrderByIdOrNumber(Integer serviceOrderId, String orderNumber);
	public List<FollowUpDTO> getFollows (Integer serviceOrderId);

	public AirCoServiceDTO getAirCoService(Integer aaServiceId);
	public BatteryServiceDTO getBateryService(Integer bbServiceId);
	public EmergencyPlantServiceDTO getEmergencyPlantService(Integer epServiceId);
	public PlainServiceDTO getPlainService(Integer plainServiceId);
	public UpsServiceDTO getUpsService(Integer upsServiceId);

	public int saveServiceOrder (Serviceorder service,String createdBy, String createdByUsr);
	public void updateServiceOrder (Serviceorder service,String modifiedBy, String modifiedByUsr);

	public void saveAirCoService (AirCoServiceDTO service,String createdBy, String createdByUsr);
	public void saveBateryService (BatteryServiceDTO service,String createdBy, String createdByUsr);
	public void saveEmergencyPlantService (EmergencyPlantServiceDTO service,String createdBy, String createdByUsr);
	public void savePlainService (PlainServiceDTO service,String createdBy, String createdByUsr);
	public void saveUpsService (UpsServiceDTO service,String createdBy, String createdByUsr);

	public String getNewServiceNumber(Integer policyId);
	
	
	// Servicios de despliegue de listados de ordenes de servicio
	public String getServiceOrdersByStatus(String status);
	public String getServiceOrderHistory();
  
}
