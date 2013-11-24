package com.blackstar.services.interfaces;

import java.util.List;

import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.UpsServiceDTO;

public interface ServiceOrderService {
	
  public OrderserviceDTO getServiceOrderByIdOrNumber(Integer serviceOrderId, String orderNumber);
  public List<FollowUpDTO> getFollows (Integer serviceOrderId);
  
  public AirCoServiceDTO getAirCoService(Integer aaServiceId);
  public BatteryServiceDTO getBateryService(Integer bbServiceId);
  public EmergencyPlantServiceDTO getEmergencyPlantService(Integer epServiceId);
  public PlainServiceDTO getPlainService(Integer plainServiceId);
  public UpsServiceDTO getUpsService(Integer upsServiceId);
  
  public void saveAirCoService (AirCoServiceDTO service);
  public void saveBateryService (BatteryServiceDTO service);
  public void saveEmergencyPlantService (EmergencyPlantServiceDTO service);
  public void savePlainService (PlainServiceDTO service);
  public void saveUpsService (UpsServiceDTO service);
  
}
