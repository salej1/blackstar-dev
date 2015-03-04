package com.blackstar.services.interfaces;

import java.util.Date;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import com.blackstar.model.Equipmenttype;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.ServiceStatusDTO;
import com.blackstar.model.dto.ServiceTypeDTO;
import com.blackstar.model.dto.UpsServiceDTO;

public interface ServiceOrderService {
	
	// Servicios de despliegue y guardado de una orden de servicio
	public OrderserviceDTO getServiceOrderByIdOrNumber(Integer serviceOrderId, String orderNumber);
	public List<FollowUpDTO> getFollows (Integer serviceOrderId);

	public AirCoServiceDTO getAirCoService(Integer serviceOrderId);
	public BatteryServiceDTO getBateryService(Integer serviceOrderId);
	public EmergencyPlantServiceDTO getEmergencyPlantService(Integer serviceOrderId);
	public PlainServiceDTO getPlainService(Integer serviceOrderId);
	public UpsServiceDTO getUpsService(Integer serviceOrderId);

	public int saveServiceOrder (Serviceorder service,String createdBy, String createdByUsr);
	public void updateServiceOrder (Serviceorder service,String modifiedBy, String modifiedByUsr);

	public void saveAirCoService (AirCoServiceDTO service,String createdBy, String createdByUsr) throws Exception ;
	public void saveBateryService (BatteryServiceDTO service,String createdBy, String createdByUsr) throws Exception ;
	public void saveEmergencyPlantService (EmergencyPlantServiceDTO service,String createdBy, String createdByUsr) throws Exception ;
	public void savePlainService (PlainServiceDTO service,String createdBy, String createdByUsr) throws Exception ;
	public void saveUpsService (UpsServiceDTO service,String createdBy, String createdByUsr) throws Exception ;

	// regresa un numero de OS preventivo, segun tipo de equipo
	public String getNewServiceNumber(String equipmentType);
	// regresa un nuevo numero de OS correctivo, siempre OS-
	public String getNewServiceNumber();
	
	// Servicios de despliegue de listados de ordenes de servicio
	public String getServiceOrdersByStatus(String status);
	public String getServiceOrdersByDate(Date startDate);
	public String getServiceOrderHistory(Date startDate, Date endDate);
	public String getLimitedServiceOrdersHistoryJson(Date startDate, Date endDate, String user);

  
	// Servicios de recuperacion de equipos
	public String getEquipmentByType(String type);
	
	// Servicio de identificacion de OS
	public String getServiceOrderTypeBySOId(Integer serviceOrderId);
	
	// Servicio de recuperacion de tipos de servicios
	public List<ServiceTypeDTO> getServiceTypeList();
	
	// Servicio de recuperacion de estatus 
	public List<ServiceStatusDTO> getServiceStatusList();
	
	// Recuperacion del seguimiento asociado
	public List<FollowUpDTO> getServiceFollowUps(Integer serviceOrderId);
	
	// Recuperacion de tipos de equipos
	public List<Equipmenttype> getEquipmentTypeList();
	
	// Detalles de una orden por numero
	public String getServiceOrderDetails(String orderNumber);

}
