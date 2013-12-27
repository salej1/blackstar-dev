package com.blackstar.services.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.AirCoServicePolicyDTO;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.BatteryServicePolicyDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServicePolicyDTO;
import com.blackstar.model.dto.UpsServiceDTO;
import com.blackstar.model.dto.UpsServicePolicyDTO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.ReportService;
import com.blackstar.services.interfaces.ServiceOrderService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;


public class OfflineOSService extends AbstractService {

  private ServiceOrderService service = null;
  private ReportService rpService = null;
	
  private static String TOKEN ="\\$oflnOS-";
  @SuppressWarnings("serial")
  private static HashMap<String, Class<?>> CLASS_TYPES = new HashMap<String, Class <?>>() {{
	                      put("airCo", AirCoServicePolicyDTO.class);
	                      put("emrPlant", EmergencyPlantServicePolicyDTO.class);
	                      put("ups", UpsServicePolicyDTO.class);
	                      put("battery", BatteryServicePolicyDTO.class);
  }};
  private static String DATE_FORMAT = "yyyy/MM/dd HH:mm";
  
  
  public void save(String json, String userName) throws Exception {
    HashMap<String,List<Object>> gridOrders = getGridOrders(json);
	Iterator<String> types = gridOrders.keySet().iterator();
	List<Object> serviceOrders = null;
	String type = null;
	while(types.hasNext()){
	  type = types.next();
	  serviceOrders = gridOrders.get(type);
	  for(Object serviceOrder : serviceOrders){
	    if(serviceOrder instanceof AirCoServicePolicyDTO){
		   saveService((AirCoServicePolicyDTO) serviceOrder, userName);
		} else if(serviceOrder instanceof EmergencyPlantServicePolicyDTO){
		   saveService((EmergencyPlantServicePolicyDTO) serviceOrder, userName);
		} else if(serviceOrder instanceof UpsServicePolicyDTO){
		   saveService((UpsServicePolicyDTO) serviceOrder, userName);
		} else if(serviceOrder instanceof BatteryServicePolicyDTO){
		   saveService((BatteryServicePolicyDTO) serviceOrder, userName);
		}
	  }
	}
  }
  
  
  private HashMap<String,List<Object>> getGridOrders(String json){
	HashMap<String,List<Object>> gridOrders = new HashMap<String,List<Object>>();
	List<String> jsonSOs = Arrays.asList(json.split(TOKEN));
	Gson gson = new GsonBuilder().setDateFormat(DATE_FORMAT).create();
	String type = null;
	for(String jsonSO : jsonSOs){
	  if(jsonSO.trim().length() > 0){
		type = jsonSO.substring(0, jsonSO.indexOf(":"));
		jsonSO = jsonSO.substring(jsonSO.indexOf(":") + 1);
		if(gridOrders.get(type) == null){
			gridOrders.put(type, new ArrayList<Object>());
		}
		gridOrders.get(type).add(gson.fromJson(jsonSO, CLASS_TYPES.get(type)));
	  }
	}
	return gridOrders;
  }
  
  private void saveService(AirCoServicePolicyDTO serviceOrder, String userName) 
		                                                   throws Exception {
	int idServicio = 0;
	Serviceorder servicioOrderSave = new Serviceorder();
    servicioOrderSave.setAsignee( serviceOrder.getResponsible());
    servicioOrderSave.setClosed(serviceOrder.getClosed());
    servicioOrderSave.setPolicyId((Short.parseShort(serviceOrder.getPolicyId()
    		                                                   .toString())));
    servicioOrderSave.setReceivedBy(serviceOrder.getReceivedBy());
    servicioOrderSave.setReceivedByPosition(serviceOrder.getReceivedByPosition());
    servicioOrderSave.setResponsible(serviceOrder.getResponsible());
    servicioOrderSave.setServiceDate(serviceOrder.getServiceDate());
    servicioOrderSave.setServiceOrderNumber(serviceOrder.getServiceOrderNumber());
    servicioOrderSave.setServiceTypeId('I');
    servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
    servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
    servicioOrderSave.setStatusId("N");
    idServicio = service.saveServiceOrder(servicioOrderSave, "OfflineOSService"
    		                                                       , userName);
    if(serviceOrder.getAaServiceId()==null) {
	  serviceOrder.setServiceOrderId(idServicio);
	  service.saveAirCoService(new AirCoServiceDTO(serviceOrder)
	                            , "OfflineOSService", userName);
	  saveReport(serviceOrder);
	}
  }
  
  private void saveService(EmergencyPlantServicePolicyDTO serviceOrder
		                         , String userName) throws Exception {
    int idServicio = 0;
    Serviceorder servicioOrderSave = new Serviceorder();
	servicioOrderSave.setAsignee( serviceOrder.getResponsible());
	servicioOrderSave.setClosed(serviceOrder.getClosed());
	servicioOrderSave.setPolicyId((Short.parseShort(serviceOrder.getPolicyId()
			                                                   .toString())));
	servicioOrderSave.setReceivedBy(serviceOrder.getReceivedBy());
	servicioOrderSave.setReceivedByPosition(serviceOrder.getReceivedByPosition());
	servicioOrderSave.setResponsible(serviceOrder.getResponsible());
	servicioOrderSave.setServiceDate(serviceOrder.getServiceDate());
	servicioOrderSave.setServiceOrderNumber(serviceOrder.getServiceOrderNumber());
	servicioOrderSave.setServiceTypeId('I');
	servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
	servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
	servicioOrderSave.setStatusId("N");
	idServicio = service.saveServiceOrder(servicioOrderSave, "OfflineOSService"
			                                                       , userName);
	if(serviceOrder.getEpServiceId()==null){
	  serviceOrder.setServiceOrderId(idServicio);
	  service.saveEmergencyPlantService(new EmergencyPlantServiceDTO(serviceOrder)
	                                            , "OfflineOSService", userName);
	  saveReport(serviceOrder);
	}
  }
  
  private void saveService(UpsServicePolicyDTO serviceOrder, String userName) 
		                                                   throws Exception {
    int idServicio = 0;
    Serviceorder servicioOrderSave = new Serviceorder();
    servicioOrderSave.setAsignee( serviceOrder.getResponsible());
    servicioOrderSave.setClosed(serviceOrder.getClosed());
    servicioOrderSave.setPolicyId((Short.parseShort(serviceOrder.getPolicyId()
                                                               .toString())));
    servicioOrderSave.setReceivedBy(serviceOrder.getReceivedBy());
    servicioOrderSave.setReceivedByPosition(serviceOrder.getReceivedByPosition());
    servicioOrderSave.setResponsible(serviceOrder.getResponsible());
    servicioOrderSave.setServiceDate(serviceOrder.getServiceDate());
    servicioOrderSave.setServiceOrderNumber(serviceOrder.getServiceOrderNumber());
    servicioOrderSave.setServiceTypeId('I');
    servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
    servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
    servicioOrderSave.setStatusId("N");
    idServicio = service.saveServiceOrder(servicioOrderSave, "OfflineOSService"
                                                                   , userName);
    if(serviceOrder.getUpsServiceId()==null){
       serviceOrder.setServiceOrderId(idServicio);
       service.saveUpsService(new UpsServiceDTO(serviceOrder), "OfflineOSService"
    		                                                        , userName);
      saveReport(serviceOrder);
    }
  }
  
  private void saveService(BatteryServicePolicyDTO serviceOrder, String userName) 
                                                              throws Exception {
    int idServicio = 0;
    Serviceorder servicioOrderSave = new Serviceorder();
    servicioOrderSave.setAsignee( serviceOrder.getResponsible());
    servicioOrderSave.setClosed(serviceOrder.getClosed());
    servicioOrderSave.setPolicyId((Short.parseShort(serviceOrder.getPolicyId()
                                                               .toString())));
    servicioOrderSave.setReceivedBy(serviceOrder.getReceivedBy());
    servicioOrderSave.setReceivedByPosition(serviceOrder.getReceivedByPosition());
    servicioOrderSave.setResponsible(serviceOrder.getResponsible());
    servicioOrderSave.setServiceDate(serviceOrder.getServiceDate());
    servicioOrderSave.setServiceOrderNumber(serviceOrder.getServiceOrderNumber());
    servicioOrderSave.setServiceTypeId('I');
    servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
    servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
    servicioOrderSave.setStatusId("N");
    idServicio = service.saveServiceOrder(servicioOrderSave, "OfflineOSService"
                                                                   , userName);
    if(serviceOrder.getBbServiceId()==null){
      serviceOrder.setServiceOrderId(idServicio);
      service.saveBateryService(new BatteryServiceDTO(serviceOrder)
                                   , "OfflineOSService", userName);
      saveReport(serviceOrder);
    }
  }
  
  private void saveReport(Object serviceOrder) throws Exception {
	byte[] report = null;
	Integer id = null;
	String parentId = null;
	if(serviceOrder instanceof AirCoServicePolicyDTO){
		id = ((AirCoServicePolicyDTO) serviceOrder).getServiceOrderId();
		parentId = gdService.getReportsFolderId(id);
		report = rpService.getAirCoReport((AirCoServicePolicyDTO) serviceOrder);
	} else if(serviceOrder instanceof EmergencyPlantServicePolicyDTO){
		id = ((EmergencyPlantServicePolicyDTO) serviceOrder).getServiceOrderId();
		parentId = gdService.getReportsFolderId(id);
		report = rpService.getEmergencyPlantReport((EmergencyPlantServicePolicyDTO) serviceOrder);
	} else if(serviceOrder instanceof UpsServicePolicyDTO){
		id = ((UpsServicePolicyDTO) serviceOrder).getServiceOrderId();
		parentId = gdService.getReportsFolderId(id);
		report = rpService.getUPSReport((UpsServicePolicyDTO) serviceOrder);
	} else if(serviceOrder instanceof BatteryServicePolicyDTO){
		id = ((BatteryServicePolicyDTO) serviceOrder).getServiceOrderId();
		parentId = gdService.getReportsFolderId(id);
		report = rpService.getBatteryReport((BatteryServicePolicyDTO) serviceOrder);
	}
	gdService.insertFileFromStream(id, "application/pdf", "ServiceOrder.pdf"
	                                                    , parentId, report);
  }
  
  public static void main(String [] args){
	  OfflineOSService service = new OfflineOSService();
	  service.getGridOrders("$oflnOS-airCo: {\"customer\":\"Cliente\",\"project\":\"proyecto\",\"equipmentAddress\":\"Domicilio\",\"contactPhone\":\"Telefono\",\"equipmentType\":\"Equipo\",\"brand\":\"Marca\",\"model\":\"Modelo\",\"serialNumber\":\"Serie\",\"serviceDate\":\"2013/12/27 04:00\",\"evaDescription\":\"Funcionamiento\",\"evaValTemp\":\"1\",\"evaValHum\":\"2\",\"evaSetpointTemp\":\"3\",\"evaSetpointHum\":\"2\",\"evaFlagCalibration\":\"true\",\"evaReviewFilter\":\"true\",\"evaReviewStrip\":\"true\",\"evaCleanElectricSystem\":\"true\",\"evaCleanControlCard\":\"true\",\"evaCleanTray\":\"true\",\"evaLectrurePreasureHigh\":\"3\",\"evaLectrurePreasureLow\":\"2\",\"evaLectureTemp\":\"1\",\"evaLectureOilColor\":\"33\",\"evaLectureOilLevel\":\"5345\",\"evaLectureCoolerColor\":\"23\",\"evaLectureCoolerLevel\":\"34\",\"evaCheckOperatation\":\"5552\",\"evaCheckNoise\":\"121\",\"evaCheckIsolated\":\"23\",\"evaLectureVoltageGroud\":\"545\",\"evaLectureVoltagePhases\":\"45\",\"evaLectureVoltageControl\":\"21\",\"evaLectureCurrentMotor1\":\"4\",\"evaLectureCurrentMotor2\":\"2\",\"evaLectureCurrentMotor3\":\"24\",\"evaLectureCurrentCompressor1\":\"123\",\"evaLectureCurrentCompressor2\":\"13\",\"evaLectureCurrentCompressor3\":\"123\",\"evaLectureCurrentHumidifier1\":\"34\",\"evaLectureCurrentHumidifier2\":\"33\",\"evaLectureCurrentHumidifier3\":\"23\",\"evaLectureCurrentHeater1\":\"123\",\"evaLectureCurrentHeater2\":\"32\",\"evaLectureCurrentHeater3\":\"321\",\"evaCheckFluidSensor\":\"true\",\"evaRequirMaintenance\":\"true\",\"condReview\":\"234\",\"condCleanElectricSystem\":\"true\",\"condClean\":\"true\",\"condLectureVoltageGroud\":\"434\",\"condLectureVoltagePhases\":\"3\",\"condLectureVoltageControl\":\"2\",\"condLectureMotorCurrent\":\"23\",\"condReviewThermostat\":\"43\",\"condModel\":\"4234\",\"condSerialNumber\":\"234\",\"condBrand\":\"2\",\"observations\":\"fsdfsf\",\"responsible\":\"54656\",\"receivedBy\":\"65465\",\"closed\":\"2013/12/27 04:00\",\"receivedByPosition\":\"4566\",\"signCreated\":\"{'lines':[[[222.4,51.3],[221.4,51.3],[218.4,52.3],[216.4,52.3],[214.4,53.3],[208.4,54.3],[201.4,54.3],[190.4,52.3],[178.4,49.3],[165.4,47.3],[154.4,44.3],[143.4,40.3],[134.4,38.3],[127.4,35.3],[120.4,32.3],[115.4,28.3],[112.4,26.3],[110.4,24.3],[109.4,24.3],[109.4,23.3],[109.4,22.3],[109.4,21.3],[110.4,20.3],[113.4,18.3],[116.4,16.3],[121.4,13.3],[126.4,11.3],[132.4,9.3],[135.4,8.3],[140.4,8.3],[142.4,8.3],[143.4,8.3],[144.4,8.3],[146.4,8.3],[150.4,9.3],[154.4,11.3],[160.4,14.3],[164.4,17.3],[171.4,22.3],[176.4,27.3],[181.4,33.3],[186.4,38.3],[192.4,43.3],[194.4,47.3],[197.4,51.3],[198.4,52.3],[199.4,54.3],[199.4,57.3],[199.4,59.3],[199.4,61.3],[198.4,64.3],[197.4,64.3],[197.4,66.3],[194.4,68.3],[191.4,69.3],[189.4,69.3],[187.4,70.3],[184.4,71.3],[179.4,73.3],[170.4,73.3],[163.4,73.3],[153.4,76.3],[145.4,77.3],[136.4,78.3],[128.4,80.3],[121.4,80.3],[117.4,80.3],[115.4,80.3],[112.4,80.3],[110.4,80.3],[107.4,80.3],[106.4,80.3],[106.4,79.3],[105.4,79.3],[106.4,78.3]]]}\",\"signReceivedBy\":\"{'lines':[[[248.4,36.3],[247.4,36.3],[244.4,36.3],[241.4,38.3],[239.4,38.3],[234.4,38.3],[227.4,39.3],[220.4,39.3],[212.4,40.3],[205.4,41.3],[199.4,41.3],[189.4,42.3],[181.4,43.3],[173.4,45.3],[166.4,46.3],[157.4,48.3],[155.4,49.3],[152.4,51.3],[150.4,52.3],[148.4,52.3],[147.4,54.3],[145.4,55.3],[145.4,56.3],[145.4,57.3],[145.4,60.3],[147.4,62.3],[152.4,66.3],[157.4,68.3],[166.4,70.3],[173.4,72.3],[182.4,72.3],[191.4,72.3],[198.4,72.3],[206.4,72.3],[213.4,71.3],[217.4,71.3],[218.4,70.3],[219.4,69.3],[220.4,69.3],[219.4,67.3],[217.4,66.3],[214.4,65.3],[212.4,64.3],[210.4,63.3],[206.4,62.3],[203.4,61.3],[198.4,59.3],[193.4,59.3],[188.4,58.3],[184.4,57.3],[180.4,57.3],[177.4,57.3],[173.4,57.3],[171.4,57.3],[170.4,56.3],[166.4,55.3],[164.4,54.3],[161.4,54.3],[159.4,52.3],[157.4,51.3],[154.4,49.3],[151.4,48.3],[149.4,46.3],[146.4,45.3],[140.4,43.3],[136.4,41.3],[133.4,41.3],[128.4,39.3],[125.4,39.3],[121.4,38.3],[119.4,38.3],[116.4,37.3],[114.4,37.3],[111.4,36.3]]]}\"}");
	  service.getGridOrders("$oflnOS-emrPlant: {\"customer\":\"34535\",\"project\":\"54\",\"equipmentAddress\":\"345\",\"contactPhone\":\"345\",\"capacity\":\"435\",\"serviceDate\":\"2013/12/27 02:00\",\"brandPE\":\"345\",\"brandMotor\":\"345\",\"tankCapacity\":\"345\",\"modelPE\":\"345\",\"modelMotor\":\"345\",\"pumpFuelModel\":\"345\",\"serialPE\":\"345\",\"serialMotor\":\"345\",\"filterFuelFlag\":\"false\",\"transferType\":\"345\",\"cplMotor\":\"34345\",\"filterOilFlag\":\"false\",\"modelTransfer\":\"345\",\"brandGenerator\":\"345\",\"filterWaterFlag\":\"true\",\"modelControl\":\"345\",\"modelGenerator\":\"345345\",\"filterAirFlag\":\"true\",\"modelRegVoltage\":\"345\",\"serialGenerator\":\"345\",\"brandGear\":\"345\",\"modelRegVelocity\":\"345\",\"powerWattGenerator\":\"345\",\"brandBattery\":\"345\",\"modelCharger\":\"345\",\"tensionGenerator\":\"345\",\"clockLecture\":\"345\",\"oilChange\":\"2013/12/05 01:00\",\"tuningDate\":\"2013/12/27 03:00\",\"serviceCorrective\":\"2013/12/27 01:00\",\"levelOilFlag\":\"true\",\"batteryCap\":\"345\",\"hoseOil\":\"35\",\"levelWaterFlag\":\"false\",\"batterySulfate\":\"345\",\"hoseWater\":\"345\",\"levelBattery\":\"345\",\"levelOil\":\"345\",\"tubeValve\":\"345\",\"tubeLeak\":\"true\",\"heatEngine\":\"345\",\"stripBlades\":\"345\",\"washEngine\":\"false\",\"cleanTransfer\":\"false\",\"batteryTests\":\"false\",\"washRadiator\":\"true\",\"cleanCardControl\":\"false\",\"checkCharger\":\"false\",\"cleanWorkArea\":\"true\",\"checkConectionControl\":\"true\",\"checkPaint\":\"true\",\"conectionCheck\":\"false\",\"checkWinding\":\"false\",\"cleanGenerator\":\"false\",\"vacuumFrequency\":\"5345\",\"vacuumVoltage\":\"345\",\"startTime\":\"5345\",\"chargeFrequency\":\"345\",\"chargeVoltage\":\"34\",\"transferTime\":\"4\",\"bootTryouts\":\"3554\",\"qualitySmoke\":\"345\",\"stopTime\":\"543\",\"tempSensor\":\"89\",\"voltageSensor\":\"454\",\"oilPreasureSensor\":\"345\",\"oilSensor\":\"45\",\"overSpeedSensor\":\"345\",\"waterLevelSensor\":\"345\",\"mechanicalStatus\":\"345\",\"screwAdjust\":\"false\",\"electricInterlock\":\"354\",\"boardClean\":\"false\",\"conectionAdjust\":\"true\",\"mechanicalInterlock\":\"345\",\"lampTest\":\"false\",\"systemMotors\":\"345\",\"capacityAmp\":\"345\",\"voltageABAN\":\"345\",\"currentA\":\"345\",\"frequency\":\"35\",\"voltageACCN\":\"345\",\"currentB\":\"345\",\"oilPreassure\":\"43\",\"voltageBCBN\":\"345\",\"currentC\":\"345\",\"temp\":\"45\",\"voltageNT\":\"345\",\"adjsutmentTherm\":\"345\",\"batteryCurrent\":\"345\",\"trasnferTypeProtection\":\"345\",\"current\":\"345\",\"clockStatus\":\"345\",\"generatorTypeProtection\":\"345\",\"observations\":\"345\",\"responsible\":\"345\",\"receivedBy\":\"345\",\"closed\":\"2013/12/27 04:00\",\"receivedByPosition\":\"35\",\"signCreated\":\"{'lines':[[[147.4,62.3],[147.4,63.3],[148.4,63.3],[150.4,63.3],[153.4,63.3],[156.4,63.3],[157.4,63.3],[156.4,63.3],[155.4,63.3],[152.4,65.3],[147.4,66.3],[142.4,67.3],[132.4,68.3],[120.4,68.3],[111.4,65.3],[101.4,63.3],[90.4,60.3],[82.4,57.3],[72.4,54.3],[64.4,50.3],[57.4,47.3],[52.4,47.3],[51.4,45.3],[50.4,45.3],[50.4,44.3],[50.4,43.3],[51.4,43.3],[53.4,42.3],[55.4,40.3],[58.4,39.3],[63.4,38.3],[70.4,36.3],[79.4,36.3],[90.4,34.3],[103.4,34.3],[114.4,34.3],[124.4,35.3],[135.4,38.3],[145.4,40.3],[152.4,43.3],[157.4,46.3],[163.4,50.3],[168.4,52.3],[171.4,54.3],[175.4,56.3],[177.4,57.3],[180.4,57.3],[180.4,59.3],[182.4,59.3],[184.4,59.3],[184.4,60.3],[185.4,61.3],[185.4,62.3],[187.4,62.3],[189.4,63.3],[191.4,64.3],[193.4,65.3],[199.4,65.3],[208.4,66.3],[218.4,64.3],[227.4,63.3],[235.4,61.3],[241.4,59.3],[245.4,58.3],[247.4,56.3],[249.4,55.3],[250.4,55.3],[251.4,54.3],[251.4,52.3],[251.4,51.3],[249.4,51.3],[248.4,49.3],[246.4,48.3],[243.4,48.3],[238.4,47.3],[232.4,44.3],[224.4,42.3],[216.4,39.3],[202.4,35.3],[183.4,31.3],[162.4,29.3],[148.4,27.3],[132.4,27.3],[118.4,27.3],[113.4,27.3],[110.4,29.3],[107.4,29.3],[106.4,29.3],[105.4,30.3],[105.4,31.3]]]}\",\"signReceivedBy\":\"{'lines':[[[205.4,37.3],[204.4,37.3],[204.4,38.3],[204.4,40.3],[203.4,42.3],[203.4,43.3],[202.4,44.3],[202.4,46.3],[201.4,46.3],[200.4,46.3],[197.4,45.3],[194.4,44.3],[188.4,42.3],[181.4,41.3],[172.4,40.3],[164.4,40.3],[154.4,40.3],[145.4,41.3],[140.4,41.3],[137.4,43.3],[135.4,43.3],[134.4,43.3],[133.4,43.3],[131.4,43.3],[129.4,42.3],[127.4,40.3],[125.4,40.3],[122.4,38.3],[120.4,37.3],[118.4,37.3],[117.4,36.3],[116.4,36.3],[115.4,36.3],[114.4,36.3],[113.4,38.3],[113.4,40.3],[113.4,42.3],[114.4,46.3],[121.4,51.3],[131.4,56.3],[145.4,61.3],[172.4,67.3],[203.4,72.3],[229.4,75.3],[244.4,77.3],[254.4,77.3],[259.4,77.3],[260.4,77.3],[259.4,76.3],[257.4,75.3],[253.4,74.3],[251.4,73.3],[247.4,72.3],[242.4,70.3],[239.4,70.3],[236.4,69.3],[233.4,67.3],[231.4,67.3],[230.4,65.3],[230.4,64.3],[230.4,63.3],[228.4,63.3],[226.4,62.3],[224.4,61.3],[218.4,60.3],[209.4,58.3],[198.4,56.3],[187.4,56.3],[172.4,54.3],[159.4,54.3],[146.4,54.3],[135.4,56.3],[129.4,57.3],[126.4,57.3],[125.4,57.3],[125.4,56.3],[125.4,55.3],[124.4,53.3],[122.4,53.3],[122.4,51.3],[121.4,51.3],[118.4,50.3],[117.4,50.3],[115.4,49.3],[112.4,49.3],[111.4,49.3],[115.4,49.3],[121.4,49.3],[129.4,47.3],[138.4,45.3],[145.4,43.3],[148.4,42.3],[150.4,40.3],[151.4,39.3],[150.4,38.3],[147.4,38.3],[143.4,36.3],[138.4,35.3],[134.4,34.3],[131.4,34.3],[128.4,34.3],[127.4,34.3],[124.4,34.3],[122.4,33.3],[119.4,32.3],[116.4,32.3],[112.4,32.3],[109.4,32.3],[102.4,34.3],[98.4,37.3],[93.4,41.3],[91.4,43.3],[91.4,45.3],[91.4,46.3],[91.4,47.3],[92.4,47.3],[95.4,47.3],[98.4,49.3],[104.4,50.3],[111.4,51.3],[120.4,54.3],[129.4,57.3],[140.4,60.3],[155.4,65.3],[173.4,74.3],[188.4,81.3],[208.4,87.3],[224.4,92.3],[238.4,94.3],[247.4,94.3],[254.4,94.3],[258.4,93.3],[259.4,93.3],[260.4,92.3],[260.4,91.3],[260.4,90.3],[258.4,90.3],[256.4,90.3],[255.4,89.3],[253.4,87.3],[253.4,86.3],[253.4,84.3],[253.4,82.3],[253.4,79.3],[253.4,75.3],[253.4,72.3],[253.4,67.3],[251.4,64.3],[250.4,60.3],[247.4,55.3],[242.4,50.3],[237.4,45.3],[234.4,44.3],[229.4,41.3],[227.4,40.3],[223.4,40.3],[220.4,40.3],[219.4,40.3]]]}\"}");
	  service.getGridOrders("$oflnOS-ups: {\"customer\":\"54\",\"project\":\"45\",\"equipmentAddress\":\"545\",\"contactPhone\":\"3455\",\"brand\":\"234\",\"model\":\"234\",\"capacity\":\"234\",\"serialNumber\":\"234\",\"serviceDate\":\"2013/12/27 04:00\",\"estatusEquipment\":\"23\",\"capacitorStatus\":\"24\",\"cleaned\":\"false\",\"verifyFuzz\":\"true\",\"hooverClean\":\"true\",\"chargerReview\":\"true\",\"verifyConnections\":\"true\",\"fanStatus\":\"234\",\"checkConnectors\":\"false\",\"temp\":\"234\",\"cverifyOutflow\":\"false\",\"chargeTest\":\"true\",\"numberBatteries\":\"23\",\"brandModel\":\"24\",\"manufacturedDateSerial\":\"234\",\"batteryVoltage\":\"234\",\"damageBatteries\":\"234\",\"other\":\"234\",\"trasferLine\":\"234\",\"backupBatteries\":\"24\",\"transferEmergencyPlant\":\"234\",\"verifyVoltage\":\"234\",\"inputVoltagePhase\":\"234\",\"outputVoltagePhase\":\"234\",\"inputVoltageNeutro\":\"234\",\"outputVoltageNeutro\":\"234\",\"inputVoltageNeutroGround\":\"234\",\"inOutFrecuency\":\"234\",\"percentCharge\":\"234\",\"busVoltage\":\"24\",\"responsible\":\"23424\",\"receivedBy\":\"234\",\"closed\":\"2013/12/27 02:00\",\"receivedByPosition\":\"234\",\"signCreated\":\"{'lines':[[[97.4,59.3],[102.4,59.3],[113.4,57.3],[122.4,57.3],[133.4,55.3],[142.4,54.3],[149.4,53.3],[159.4,52.3],[167.4,50.3],[172.4,48.3],[175.4,48.3],[175.4,46.3],[176.4,46.3],[174.4,45.3],[173.4,45.3],[173.4,44.3],[171.4,44.3],[170.4,44.3],[169.4,42.3],[166.4,42.3],[163.4,42.3],[159.4,42.3],[154.4,42.3],[148.4,41.3],[142.4,41.3],[133.4,38.3],[124.4,38.3],[117.4,35.3],[109.4,33.3],[99.4,32.3],[95.4,31.3],[89.4,30.3],[86.4,29.3],[84.4,27.3],[83.4,27.3],[82.4,27.3],[83.4,27.3],[84.4,27.3],[88.4,30.3],[98.4,34.3],[107.4,38.3],[118.4,43.3],[125.4,46.3],[133.4,48.3],[139.4,51.3],[147.4,52.3],[150.4,52.3],[153.4,52.3],[155.4,52.3],[156.4,52.3],[156.4,51.3]]]}\",\"signReceivedBy\":\"{'lines':[[[277.4,36.3],[274.4,36.3],[273.4,36.3],[271.4,37.3],[269.4,38.3],[262.4,39.3],[252.4,39.3],[241.4,39.3],[228.4,39.3],[215.4,39.3],[198.4,37.3],[185.4,36.3],[171.4,33.3],[156.4,29.3],[143.4,26.3],[129.4,24.3],[118.4,20.3],[107.4,17.3],[99.4,14.3],[87.4,12.3],[77.4,10.3],[69.4,9.3],[64.4,9.3],[59.4,9.3],[56.4,9.3],[54.4,9.3],[55.4,9.3],[55.4,8.3],[57.4,8.3],[62.4,6.3],[67.4,5.3],[71.4,5.3],[78.4,5.3],[84.4,5.3],[90.4,8.3],[99.4,11.3],[107.4,13.3],[113.4,16.3],[119.4,17.3],[125.4,20.3],[129.4,22.3],[131.4,24.3],[134.4,25.3],[137.4,28.3],[138.4,31.3],[142.4,35.3],[146.4,39.3],[148.4,43.3],[151.4,47.3],[155.4,50.3],[158.4,53.3],[160.4,54.3],[164.4,55.3],[166.4,56.3],[167.4,56.3],[168.4,56.3],[170.4,56.3],[172.4,56.3],[173.4,56.3],[174.4,56.3],[175.4,56.3],[176.4,55.3],[177.4,55.3],[178.4,55.3],[178.4,54.3]]]}\"}");
	  service.getGridOrders("$oflnOS-battery: {\"customer\":\"32434\",\"project\":\"234\",\"equipmentAddress\":\"234\",\"contactPhone\":\"234\",\"brand\":\"234\",\"model\":\"234\",\"capacity\":\"234\",\"serialNumber\":\"234\",\"serviceDate\":\"2013/12/27 03:00\",\"plugClean\":\"true\",\"plugCleanStatus\":\"234\",\"coverClean\":\"true\",\"coverCleanStatus\":\"234\",\"coverCleanComments\":\"234\",\"capClean\":\"true\",\"capCleanStatus\":\"234\",\"capCleanComments\":\"234\",\"groundClean\":\"true\",\"groundCleanStatus\":\"234\",\"groundCleanComments\":\"24\",\"rackClean\":\"true\",\"rackCleanStatus\":\"234\",\"rackCleanComments\":\"234\",\"serialNoDateManufact\":\"234\",\"batteryTemperature\":\"234\",\"voltageBus\":\"234\",\"temperature\":\"234\",\"responsible\":\"234\",\"receivedBy\":\"234\",\"closed\":\"2013/12/27 04:00\",\"receivedByPosition\":\"234\",\"signCreated\":\"{'lines':[[[116.4,42.3],[114.4,42.3],[111.4,43.3],[109.4,44.3],[103.4,45.3],[95.4,46.3],[84.4,46.3],[72.4,46.3],[60.4,47.3],[47.4,47.3],[35.4,48.3],[26.4,48.3],[15.4,49.3],[9.4,49.3],[5.4,49.3],[3.4,48.3],[2.4,47.3],[1.4,46.3],[0.4,44.3],[0.4,41.3],[0.4,38.3],[0.4,36.3],[1.4,33.3],[2.4,32.3],[3.4,30.3],[4.4,30.3],[8.4,29.3],[9.4,27.3],[12.4,27.3],[14.4,25.3],[18.4,24.3],[23.4,23.3],[27.4,22.3],[30.4,22.3],[32.4,22.3],[33.4,22.3],[34.4,22.3],[36.4,23.3],[41.4,26.3],[46.4,28.3],[52.4,30.3],[58.4,36.3],[67.4,39.3],[74.4,43.3],[80.4,46.3],[87.4,49.3],[92.4,52.3],[94.4,53.3],[96.4,55.3],[99.4,57.3],[100.4,59.3],[101.4,61.3],[104.4,62.3],[106.4,64.3],[108.4,65.3],[111.4,67.3],[116.4,68.3],[120.4,69.3],[126.4,71.3],[132.4,73.3],[141.4,75.3],[151.4,76.3],[163.4,79.3],[174.4,80.3],[186.4,80.3],[196.4,80.3],[204.4,80.3],[213.4,77.3],[218.4,76.3],[220.4,76.3],[223.4,75.3],[224.4,74.3],[225.4,74.3],[226.4,74.3],[229.4,73.3],[231.4,72.3],[234.4,72.3],[237.4,71.3],[239.4,70.3],[241.4,69.3],[243.4,69.3],[244.4,68.3],[245.4,67.3]]]}\",\"signReceivedBy\":\"{'lines':[[[232.4,33.3],[231.4,33.3],[230.4,32.3],[229.4,32.3],[227.4,32.3],[226.4,32.3],[224.4,31.3],[222.4,31.3],[220.4,30.3],[216.4,30.3],[212.4,30.3],[208.4,30.3],[201.4,29.3],[193.4,29.3],[186.4,29.3],[179.4,29.3],[172.4,30.3],[168.4,31.3],[162.4,32.3],[157.4,33.3],[152.4,35.3],[149.4,36.3],[146.4,37.3],[143.4,39.3],[140.4,40.3],[139.4,42.3],[138.4,43.3],[138.4,47.3],[138.4,49.3],[138.4,53.3],[140.4,55.3],[144.4,58.3],[149.4,61.3],[153.4,63.3],[162.4,65.3],[166.4,68.3],[172.4,69.3],[176.4,71.3],[181.4,71.3],[183.4,72.3],[187.4,72.3],[190.4,72.3],[193.4,72.3],[194.4,72.3],[197.4,71.3],[198.4,70.3],[200.4,68.3],[201.4,67.3],[202.4,66.3],[203.4,66.3],[203.4,65.3],[203.4,64.3],[203.4,63.3],[201.4,62.3],[201.4,60.3],[198.4,59.3],[197.4,57.3],[194.4,56.3],[190.4,53.3],[187.4,50.3],[182.4,47.3],[176.4,44.3],[171.4,40.3],[167.4,37.3],[162.4,34.3],[157.4,33.3],[154.4,30.3],[149.4,28.3],[145.4,27.3],[140.4,26.3],[137.4,23.3],[133.4,22.3],[128.4,21.3],[125.4,20.3],[123.4,20.3],[120.4,20.3],[118.4,20.3],[117.4,20.3],[115.4,20.3],[114.4,21.3],[113.4,22.3],[111.4,22.3],[109.4,24.3],[108.4,26.3],[106.4,28.3],[105.4,30.3],[105.4,33.3],[104.4,35.3],[104.4,36.3],[104.4,39.3],[104.4,41.3],[104.4,45.3],[105.4,47.3],[107.4,49.3],[109.4,50.3],[111.4,52.3],[113.4,53.3],[116.4,54.3],[120.4,56.3],[123.4,57.3],[130.4,58.3],[136.4,60.3],[140.4,62.3],[146.4,63.3],[150.4,64.3],[153.4,64.3],[156.4,64.3],[158.4,64.3],[161.4,64.3],[162.4,63.3],[165.4,63.3],[167.4,61.3],[169.4,60.3],[171.4,59.3],[171.4,58.3],[171.4,56.3],[171.4,54.3],[171.4,53.3],[169.4,52.3],[168.4,51.3],[165.4,49.3],[164.4,48.3],[161.4,46.3],[158.4,45.3],[155.4,44.3],[152.4,42.3],[150.4,41.3],[147.4,38.3],[142.4,37.3],[140.4,34.3],[135.4,32.3],[133.4,31.3],[130.4,29.3],[124.4,26.3],[121.4,25.3],[116.4,23.3],[112.4,22.3],[106.4,20.3],[103.4,19.3],[100.4,19.3],[97.4,19.3],[95.4,19.3],[93.4,18.3],[90.4,18.3],[86.4,18.3],[84.4,19.3],[81.4,21.3],[79.4,22.3],[74.4,24.3],[71.4,25.3],[68.4,27.3],[66.4,28.3],[63.4,31.3],[60.4,32.3],[58.4,35.3],[57.4,36.3],[57.4,38.3],[55.4,40.3],[54.4,42.3],[54.4,45.3],[53.4,47.3],[53.4,49.3],[53.4,51.3],[53.4,53.3],[53.4,54.3],[53.4,56.3],[53.4,57.3],[55.4,59.3],[56.4,60.3],[58.4,62.3],[61.4,63.3],[65.4,65.3],[69.4,67.3],[73.4,68.3],[78.4,69.3],[83.4,70.3],[85.4,70.3],[88.4,70.3],[92.4,70.3],[95.4,70.3],[97.4,69.3],[99.4,67.3],[100.4,66.3],[101.4,64.3],[102.4,61.3],[102.4,58.3],[102.4,55.3],[102.4,52.3],[102.4,50.3],[100.4,46.3],[99.4,44.3],[97.4,41.3],[95.4,38.3],[93.4,36.3],[91.4,34.3],[90.4,32.3],[89.4,30.3],[88.4,28.3],[86.4,27.3],[86.4,26.3],[84.4,26.3],[83.4,25.3],[81.4,23.3],[78.4,22.3],[77.4,21.3],[76.4,21.3],[73.4,20.3],[72.4,19.3],[69.4,18.3],[68.4,18.3],[66.4,18.3],[64.4,18.3],[62.4,18.3],[61.4,19.3],[58.4,20.3],[56.4,21.3],[54.4,23.3],[52.4,25.3],[50.4,27.3],[49.4,32.3],[49.4,35.3],[48.4,38.3],[47.4,39.3],[47.4,40.3],[47.4,41.3],[47.4,42.3],[47.4,44.3],[48.4,46.3],[50.4,48.3],[52.4,50.3],[58.4,53.3],[64.4,56.3],[71.4,59.3],[81.4,62.3],[91.4,66.3],[103.4,67.3],[108.4,69.3],[115.4,70.3],[122.4,71.3],[126.4,71.3],[128.4,71.3],[131.4,71.3],[134.4,71.3],[137.4,71.3],[138.4,70.3],[140.4,69.3],[141.4,68.3],[144.4,68.3],[147.4,67.3],[149.4,66.3],[153.4,65.3],[160.4,64.3],[164.4,64.3],[170.4,63.3],[178.4,63.3],[184.4,63.3],[194.4,61.3],[205.4,60.3],[215.4,58.3],[230.4,57.3],[241.4,54.3],[251.4,52.3],[256.4,49.3],[262.4,47.3],[267.4,46.3],[267.4,45.3],[268.4,45.3],[269.4,45.3],[269.4,44.3],[270.4,44.3],[271.4,43.3],[272.4,42.3],[274.4,41.3],[275.4,40.3],[276.4,40.3],[276.4,39.3],[276.4,38.3],[275.4,38.3],[274.4,38.3],[274.4,37.3],[272.4,37.3],[269.4,36.3],[267.4,36.3],[264.4,36.3],[260.4,36.3],[258.4,36.3],[255.4,36.3],[252.4,36.3],[250.4,36.3],[248.4,36.3],[245.4,35.3],[242.4,33.3],[239.4,32.3],[236.4,30.3],[230.4,27.3],[225.4,25.3],[216.4,21.3],[206.4,17.3],[201.4,14.3],[192.4,10.3],[185.4,7.3],[179.4,5.3],[174.4,5.3],[168.4,4.3],[164.4,4.3],[160.4,4.3],[154.4,4.3],[152.4,4.3],[151.4,4.3]]]}\",\"cells\":[{\"cellNumber\":1,\"floatVoltage\":234,\"chargeVoltage\":234}, {\"cellNumber\":2,\"floatVoltage\":234,\"chargeVoltage\":234}, {\"cellNumber\":3,\"floatVoltage\":234,\"chargeVoltage\":24}, {\"cellNumber\":4,\"floatVoltage\":234,\"chargeVoltage\":234}, {\"cellNumber\":5,\"floatVoltage\":234,\"chargeVoltage\":234}, {\"cellNumber\":6,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":7,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":8,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":9,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":10,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":11,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":12,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":13,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":14,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":15,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":16,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":17,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":18,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":19,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":20,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":21,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":22,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":23,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":24,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":25,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":26,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":27,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":28,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":29,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":30,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":31,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":32,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":33,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":34,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":35,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":36,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":37,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":38,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":39,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":40,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":41,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":42,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":43,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":44,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":45,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":46,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":47,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":48,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":49,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":50,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":51,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":52,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":53,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":54,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":55,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":56,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":57,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":58,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":59,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":60,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":61,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":62,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":63,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":64,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":65,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":66,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":67,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":68,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":69,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":70,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":71,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":72,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":73,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":74,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":75,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":76,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":77,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":78,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":79,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":80,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":81,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":82,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":83,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":84,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":85,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":86,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":87,\"floatVoltage\":0,\"chargeVoltage\":0}, {\"cellNumber\":88,\"floatVoltage\":0,\"chargeVoltage\":0}]}");
  }
	
}
