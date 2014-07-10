package com.blackstar.db.dao.impl;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.Employee;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.BatteryCellServiceDTO;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.ServiceStatusDTO;
import com.blackstar.model.dto.UpsServiceDTO;


@SuppressWarnings("unchecked")
public class ServiceOrderDAOImpl extends AbstractDAO implements ServiceOrderDAO {
 
  public OrderserviceDTO getServiceOrderByIdOrNumber(Integer serviceOrderId, String orderNumber){
	//Se sugiere generar un SP y cambiar la invocacion por 
    //       sqlBuilder.append("CALL GetServiceOrderByIdOrNumber(?,?)");	  
    OrderserviceDTO data = null;
	StringBuilder sqlSelect = new StringBuilder();
	StringBuilder sqlFrom = new StringBuilder();
	StringBuilder sqlWhere = new StringBuilder();
	StringBuilder sqlBuilder = new StringBuilder();
	sqlSelect.append("SELECT SO.coordinator AS 'coordinator', SO.serviceOrderId AS 'serviceOrderId'")
	         .append("        , SO.serviceOrderNumber AS 'serviceOrderNo', SO.serviceDate AS 'serviceDate'")
	         .append("        , SO.serviceComments AS 'detailStatus', SO.signCreated AS 'signCreated'")
	         .append("        , SO.signReceivedBy AS 'signReceivedBy', SO.receivedBy AS 'receivedBy'")
	         .append("        , SO.responsible AS 'responsible', SO.closed AS 'closed' ")
	         .append("        , SO.receivedByPosition AS 'receivedByPosition', SO.policyId AS 'policyId'")
	         .append("        , SO.ticketId AS 'ticketId', SO.serviceTypeId AS 'serviceTypeId', SO.openCustomerId AS 'openCustomerId' ");
	sqlFrom.append("FROM serviceOrder SO ");
	sqlWhere.append("WHERE (SO.serviceOrderId = ? OR SO.serviceOrderNumber = ?)" );
	sqlBuilder.append(sqlSelect).append(sqlFrom).append(sqlWhere);
	data = (OrderserviceDTO) getJdbcTemplate().queryForObject(sqlBuilder.toString()
			, new Object []{serviceOrderId, orderNumber}, getMapperFor(OrderserviceDTO.class));
	
	if(data.getPolicyId() != null){
		sqlSelect.append(", PY.customer AS 'customer', PY.equipmentAddress AS 'equipmentAddress'")
		         .append(", PY.contactName AS 'contactName', PY.contactPhone AS 'contactPhone'")
		         .append(", PY.brand AS 'equipmentBrand', PY.model AS 'equipmentModel'")
		         .append(", PY.serialNumber AS 'equipmentSerialNo', PY.project AS 'proyectNumber'" );
		sqlFrom.append(", policy PY ");
		sqlWhere.append("AND SO.policyId = PY.policyId ");
	}
	if(data.getTicketId() != null){
		sqlSelect.append(", TK.ticketNumber AS 'ticketNo', TK.ticketId AS 'ticketId'")
		         .append(", TK.observations AS 'failureDescription' ");
		sqlFrom.append(", ticket TK ");
		sqlWhere.append("AND SO.ticketId = TK.ticketId " );		
	}
	if(data.getServiceTypeId() != null){
		sqlSelect.append(", ST.serviceType AS 'serviceType'");
		sqlFrom.append(", serviceType ST ");
		sqlWhere.append("AND SO.serviceTypeId = ST.serviceTypeId ");
	}
	if(data.getEquipmentTypeId() != null){
		sqlSelect.append(", ET.equipmentType AS 'equipmentType' ");
		sqlFrom.append(", equipmentType ET ");
		sqlWhere.append("AND PY.equipmentTypeId = ET.equipmentTypeId ");
	}
	sqlBuilder = new StringBuilder();
	sqlBuilder.append(sqlSelect).append(sqlFrom).append(sqlWhere);
	return (OrderserviceDTO) getJdbcTemplate().queryForObject(sqlBuilder.toString()
			     , new Object []{serviceOrderId, orderNumber}, getMapperFor(OrderserviceDTO.class));
  }
  
  
  public List<FollowUpDTO> getFollows (Integer serviceOrderId){
	StringBuilder sqlBuilder = new StringBuilder();
	sqlBuilder.append("CALL GetFollowUpByServiceOrder(?)");
	return (List<FollowUpDTO>) getJdbcTemplate().query(sqlBuilder.toString() 
			, new Object []{serviceOrderId}, getMapperFor(FollowUpDTO.class));
  }

  @Override
  public Serviceorder findServiceOrder() {
	// TODO Auto-generated method stub
	  
	return null;
  }

  @Override
  public List<Serviceorder> selectAllServiceOrder() {
	// TODO Auto-generated method stub
	return null;
  }

  @Override
  public Serviceorder getServiceOrderById(int id) {
	// TODO Auto-generated method stub
	return null;
  }

  @Override
  public Serviceorder getServiceOrderByNum(String num) {
	// TODO Auto-generated method stub
	return null;
  }

  @Override
  public int insertServiceOrder(Serviceorder orderService) {
	  
	StringBuilder sqlBuilder = new StringBuilder();
	sqlBuilder.append("CALL AddserviceOrder(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
	
	DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	
	Object[] args = new Object []{
									"" + orderService.getServiceOrderNumber() + "",
									""+orderService.getServiceTypeId()+"",
									orderService.getTicketId(),
									orderService.getPolicyId(),
									""+orderService.getServiceUnit()+ "",
									""+df.format(orderService.getServiceDate())+ "",
									""+orderService.getResponsible()+ "",
									"''",
									""+orderService.getReceivedBy()+ "",
									""+orderService.getServiceComments()+ "",
									""+orderService.getStatusId()+ "",
									orderService.getClosed()!= null?df.format(orderService.getClosed()): null,
									""+orderService.getConsultant()+ "",
									""+orderService.getCoordinator()+ "",
									""+orderService.getAsignee()+ "",
									0,
									orderService.getIsWrong()==null?0:orderService.getIsWrong(),
									""+orderService.getSignCreated()+ "",
									""+orderService.getsignReceivedBy()+ "",
									""+orderService.getReceivedByPosition()+ "",
									""+df.format(orderService.getCreated())+ "",
									""+orderService.getCreatedBy()+ "",
									""+orderService.getCreatedByUsr()+ "",
									""+orderService.getReceivedByEmail()+ "",
									orderService.getOpenCustomerId(),
									orderService.getServiceEndDate()!=null?df.format(orderService.getServiceEndDate()):null,
									orderService.getHasPdf()!=null?orderService.getHasPdf():0
								};
	
	Integer idOS = getJdbcTemplate().queryForInt(sqlBuilder.toString() ,args);
	
	// Insertando la lista de empleados
	for(Employee employee : orderService.getEmployeeList()){
		sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddServiceOrderEmployee(?,?,?,?,?)");
		
		args = new Object[]{
				idOS.toString(),
				employee.getEmail(),
				df.format(orderService.getCreated()).toString(),
				orderService.getCreatedBy(),
				orderService.getCreatedByUsr()
		};
		
		getJdbcTemplate().update(sqlBuilder.toString(), args);
	}
	
	return idOS;
  }

  @Override
  public boolean updateServiceOrder(Serviceorder orderService) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL UpdateServiceOrder(?,?,?,?,?,?,?,?,?)");
		DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Object[] args = new Object []{
										orderService.getServiceOrderId(),
										""+orderService.getStatusId()+ "",
										orderService.getClosed() != null? df.format(orderService.getClosed()) : null,
										""+orderService.getAsignee()+ "",
										""+orderService.getIsWrong()+ "",
										""+df.format(orderService.getModified())+ "",
										""+orderService.getModifiedBy()+ "",
										""+orderService.getModifiedByUsr()+ "",
										orderService.getHasPdf()
									};
		
		 getJdbcTemplate().update(sqlBuilder.toString() ,args);
		
	return true;
  }

	
	@Override
	public AirCoServiceDTO getAirCoService(Integer aaServiceId) {
		
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetAirCoServiceByIdService(?)");
		
		List<AirCoServiceDTO> aircoServices = (List<AirCoServiceDTO>) getJdbcTemplate().query(sqlBuilder.toString() 
					, new Object []{aaServiceId}, getMapperFor(AirCoServiceDTO.class));
		
		AirCoServiceDTO airService = null;
		
		if(aircoServices.size() >0)
			airService  = aircoServices.get(0);
		
		return airService;
	}
	
	
	@Override
	public BatteryServiceDTO getBateryService(Integer bbServiceId) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetBatteryServiceByIdService(?)");
		
		List<BatteryServiceDTO> batteryServices = (List<BatteryServiceDTO>) getJdbcTemplate().query(sqlBuilder.toString() 
				, new Object []{bbServiceId}, getMapperFor(BatteryServiceDTO.class));
	
		BatteryServiceDTO batteryService = null;
		
		if(batteryServices.size() >0)
			batteryService  = batteryServices.get(0);
		
		return batteryService;
	}
	
	
	@Override
	public EmergencyPlantServiceDTO getEmergencyPlantService(Integer epServiceId) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetEmergencyPlantServiceByIdService(?)");
		
		List<EmergencyPlantServiceDTO> emergencyServices = (List<EmergencyPlantServiceDTO>) getJdbcTemplate().query(sqlBuilder.toString() 
				, new Object []{epServiceId}, getMapperFor(EmergencyPlantServiceDTO.class));
	
		EmergencyPlantServiceDTO emergencyPlantService = null;
		
		if(emergencyServices.size() >0)
			emergencyPlantService  = emergencyServices.get(0);
		
		return emergencyPlantService;
	}
	
	
	@Override
	public PlainServiceDTO getPlainService(Integer plainServiceId) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetPlainServiceServiceByIdService(?)");
		
		List<PlainServiceDTO> plainServices = (List<PlainServiceDTO>) getJdbcTemplate().query(sqlBuilder.toString() 
				, new Object []{plainServiceId}, getMapperFor(PlainServiceDTO.class));
	
		PlainServiceDTO plainService = null;
		
		if(plainServices.size() >0)
			plainService  = plainServices.get(0);
		
		return plainService;
		
	}
	
	
	@Override
	public UpsServiceDTO getUpsService(Integer upsServiceId) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetUPSServiceByIdService(?)");
		
		List<UpsServiceDTO> upsServices = (List<UpsServiceDTO>) getJdbcTemplate().query(sqlBuilder.toString() 
				, new Object []{upsServiceId}, getMapperFor(UpsServiceDTO.class));
	
		UpsServiceDTO upsService = null;
		
		if(upsServices.size() >0)
			upsService  = upsServices.get(0);
		
		return upsService;
	}
	
	@Override
	public List<BatteryCellServiceDTO> getBatteryCells(Integer bbServiceId) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetCellBatteryServiceByIdBatteryService(?)");
		return (List<BatteryCellServiceDTO>) getJdbcTemplate().query(sqlBuilder.toString() 
				, new Object []{bbServiceId}, getMapperFor(BatteryCellServiceDTO.class));
	}
	
	@Override
	public int saveAirCoService(AirCoServiceDTO service , Date created ,String createdBy,String createdByUsr) {
		StringBuilder sqlBuilder = new StringBuilder();
		DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		sqlBuilder.append("CALL AddAAservice(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

		Object[] args = new Object []{		
										service.getServiceOrderId(),
										""+service.getEvaDescription()+"",
										service.getEvaValTemp(),
										service.getEvaValHum(),
										service.getEvaSetpointTemp(),
										service.getEvaSetpointHum(),
										service.getEvaFlagCalibration(),
										service.getEvaReviewFilter(),
										service.getEvaReviewStrip(),
										service.getEvaCleanElectricSystem(),
										service.getEvaCleanControlCard(),
										service.getEvaCleanTray(),
										service.getEvaLectrurePreasureHigh(),
										service.getEvaLectrurePreasureLow(),
										service.getEvaLectureTemp(),
										""+service.getEvaLectureOilColor()+"",
										service.getEvaLectureOilLevel(),
										""+service.getEvaLectureCoolerColor()+"",
										service.getEvaLectureCoolerLevel(),
										""+service.getEvaCheckOperatation()+"",
										""+service.getEvaCheckNoise()+"",
										""+service.getEvaCheckIsolated()+"",
										service.getEvaLectureVoltageGroud(),
										service.getEvaLectureVoltagePhases(),
										service.getEvaLectureVoltageControl(),
										service.getEvaLectureCurrentMotor1(),
										service.getEvaLectureCurrentMotor2(),
										service.getEvaLectureCurrentMotor3(),
										service.getEvaLectureCurrentCompressor1(),
										service.getEvaLectureCurrentCompressor2(),
										service.getEvaLectureCurrentCompressor3(),
										service.getEvaLectureCurrentHumidifier1(),
										service.getEvaLectureCurrentHumidifier2(),
										service.getEvaLectureCurrentHumidifier3(),
										service.getEvaLectureCurrentHeater1(),
										service.getEvaLectureCurrentHeater2(),
										service.getEvaLectureCurrentHeater3(),
										service.getEvaCheckFluidSensor(),
										service.getEvaRequirMaintenance(),
										""+service.getCondReview()+"",
										service.getCondCleanElectricSystem(),
										service.getCondClean(),
										service.getCondLectureVoltageGroud(),
										service.getCondLectureVoltagePhases(),
										service.getCondLectureVoltageControl(),
										service.getCondLectureMotorCurrent(),
										""+service.getCondReviewThermostat()+"",
										""+service.getCondModel()+"",
										""+service.getCondSerialNumber()+"",
										""+service.getCondBrand()+"",
										""+service.getObservations()+"",
										""+df.format(created)+"",
										""+createdBy+"",
										""+createdByUsr+""
									};
		
		int idOs = getJdbcTemplate().queryForInt(sqlBuilder.toString() ,args);
		return idOs;	
	}
	
	
	@Override
	public int saveBateryService(BatteryServiceDTO service, Date created ,String createdBy,String createdByUsr) {
		// TODO Auto-generated method stub
		StringBuilder sqlBuilder = new StringBuilder();
		DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		sqlBuilder.append("CALL AddBBservice(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
		Object[] args = new Object []{	
										service.getServiceOrderId(),
										service.getPlugClean(),
										""+service.getPlugCleanStatus()+"",
										""+service.getPlugCleanComments()+"",
										service.getCoverClean(),
										""+service.getCoverCleanStatus()+"",
										""+service.getCoverCleanComments()+"",
										service.getCapClean(),
										""+service.getCapCleanStatus()+"",
										""+service.getCapCleanComments()+"",
										service.getGroundClean(),
										""+service.getGroundCleanStatus()+"",
										""+service.getGroundCleanComments()+"",
										service.getRackClean(),
										""+service.getRackCleanStatus()+"",
										""+service.getRackCleanComments()+"",
										""+service.getSerialNoDateManufact()+"",
										""+service.getBatteryTemperature()+"",
										service.getVoltageBus(),
										service.getTemperature(),
										""+df.format(created)+"",
										""+createdBy+"",
										""+createdByUsr+""	
									};
		int idOs = getJdbcTemplate().queryForInt(sqlBuilder.toString() ,args);
		
		// insertar los registros de las cells
		for (BatteryCellServiceDTO cell : service.getCells()) {
			
			if(cell.getCellNumber()!=null)
			{
				if(cell.getFloatVoltage()==null)
					cell.setFloatVoltage(0);
				if(cell.getChargeVoltage()==null)
					cell.setChargeVoltage(0);
				
				sqlBuilder = new StringBuilder();
				sqlBuilder.append("CALL AddBBcellservice(?,?,?,?)");
				Object[] argsCell = new Object []{	idOs,cell.getCellNumber(),cell.getFloatVoltage(),cell.getChargeVoltage() };
				getJdbcTemplate().update(sqlBuilder.toString() ,argsCell);
			}
		}
		return idOs;	
	}
	
	
	@Override
	public int saveEmergencyPlantService(EmergencyPlantServiceDTO service, Date created ,String createdBy,String createdByUsr) {
		StringBuilder sqlBuilder = new StringBuilder();
		DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		sqlBuilder.append("CALL AddepService(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
		Object[] args = new Object []{
										service.getServiceOrderId(),
										""+service.getBrandPE()+"",
										""+service.getModelPE()+"",
										""+service.getSerialPE()+"",
										""+service.getTransferType()+"",
										""+service.getModelTransfer()+"",
										""+service.getModelControl()+"",
										""+service.getModelRegVoltage()+"",
										""+service.getModelRegVelocity()+"",
										""+service.getModelCharger()+"",
										""+df.format(service.getOilChange())+"",
										""+service.getBrandMotor()+"",
										""+service.getModelMotor()+"",
										""+service.getSerialMotor()+"",
										""+service.getCplMotor()+"",
										""+service.getBrandGenerator()+"",
										""+service.getModelGenerator()+"",
										""+service.getSerialGenerator()+"",
										service.getPowerWattGenerator(),
										service.getTensionGenerator(),
										""+df.format(service.getTuningDate())+"",
										service.getTankCapacity(),
										""+service.getPumpFuelModel()+"",
										service.getFilterFuelFlag(),
										service.getFilterOilFlag(),
										service.getFilterWaterFlag(),
										service.getFilterAirFlag(),
										""+service.getBrandGear()+"",
										""+service.getBrandBattery()+"",
										""+service.getClockLecture()+"",
										""+df.format(service.getServiceCorrective())+"",
										""+service.getObservations()+"",
										""+df.format(created)+"",
										""+createdBy+"",
										""+createdByUsr+""
									};
		int idOs = getJdbcTemplate().queryForInt(sqlBuilder.toString() ,args);
		
		sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddepServiceSurvey(?,?,?,?,?,?,?,?,?,?,?,?,?)");
		args = new Object []{
								idOs,
								service.getLevelOilFlag(),
								service.getLevelWaterFlag(),
								service.getLevelBattery(),
								service.getTubeLeak(),
								""+service.getBatteryCap()+"",
								""+service.getBatterySulfate()+"",
								service.getLevelOil(),
								""+service.getHeatEngine()+"",
								""+service.getHoseOil()+"",
								""+service.getHoseWater()+"",
								""+service.getTubeValve()+"",
								""+service.getStripBlades()+""
							};
		getJdbcTemplate().update(sqlBuilder.toString() ,args);
		
		
		sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddepServiceWorkBasic(?,?,?,?,?,?,?,?,?,?,?,?,?)");
		args = new Object []{
								idOs,
								service.getWashEngine(),
								service.getWashRadiator(),
								service.getCleanWorkArea(),
								service.getConectionCheck(),
								service.getCleanTransfer(),
								service.getCleanCardControl(),
								service.getCheckConectionControl(),
								service.getCheckWinding(),
								service.getBatteryTests(),
								service.getCheckCharger(),
								service.getCheckPaint(),
								service.getCleanGenerator()
							};
		getJdbcTemplate().update(sqlBuilder.toString() ,args);
		
		
		sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddepServiceDynamicTest(?,?,?,?,?,?,?,?,?,?)");
		args = new Object []{
								idOs,
								service.getVacuumFrequency(),
								service.getChargeFrequency(),
								service.getBootTryouts(),
								service.getVacuumVoltage(),
								service.getChargeVoltage(),
								service.getQualitySmoke(),
								service.getStartTime(),
								service.getTransferTime(),
								service.getStopTime()
							};
		getJdbcTemplate().update(sqlBuilder.toString() ,args);
		
		sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddepServiceTestProtection(?,?,?,?,?,?,?)");
		args = new Object []{
								idOs,
								service.getTempSensor(),
								service.getOilSensor(),
								service.getVoltageSensor(),
								service.getOverSpeedSensor(),
								service.getOilPreasureSensor(),
								service.getWaterLevelSensor()
							};
		getJdbcTemplate().update(sqlBuilder.toString() ,args);
		
		sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddepServiceTransferSwitch(?,?,?,?,?,?,?,?,?,?)");
		args = new Object []{
								idOs,
								""+service.getMechanicalStatus(),
								service.getBoardClean(),
								service.getLampTest(),
								service.getScrewAdjust(),
								service.getConectionAdjust(),
								""+service.getSystemMotors()+"",
								""+service.getElectricInterlock()+"",
								""+service.getMechanicalInterlock()+"",
								service.getCapacityAmp()
							};
		getJdbcTemplate().update(sqlBuilder.toString() ,args);
		
		sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddepServiceLectures(?,?,?,?,?,?,?,?,?,?,?)");
		args = new Object []{
								idOs,
								service.getVoltageABAN(),
								service.getVoltageACCN(),
								service.getVoltageBCBN(),
								service.getVoltageNT(),
								service.getCurrentA(),
								service.getCurrentB(),
								service.getCurrentC(),
								service.getFrequency(),
								service.getOilPreassure(),
								service.getTemp()
							};
		getJdbcTemplate().update(sqlBuilder.toString() ,args);
		
		sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddepServiceParams(?,?,?,?,?,?,?)");
		args = new Object []{
								idOs,
								""+service.getAdjsutmentTherm()+"",
								""+service.getCurrent()+"",
								""+service.getBatteryCurrent()+"",
								""+service.getClockStatus()+"",
								""+service.getTrasnferTypeProtection()+"",
								""+service.getGeneratorTypeProtection()+""
							};
		getJdbcTemplate().update(sqlBuilder.toString() ,args);

		return idOs;	
	}
	
	
	@Override
	public int savePlainService(PlainServiceDTO service, Date created ,String createdBy,String createdByUsr) {
		// TODO Auto-generated method stub
		StringBuilder sqlBuilder = new StringBuilder();
		DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		sqlBuilder.append("CALL AddplainService(?,?,?,?,?,?,?,?,?)");
		Object[] args = new Object []{	
										service.getServiceOrderId(),
										""+service.getTroubleDescription()+"",
										""+service.getTechParam()+"",
										""+service.getWorkDone()+"",
										""+service.getMaterialUsed()+"",
										""+service.getObservations()+"",
										""+df.format(created)+"",
										""+createdBy+"",
										""+createdByUsr+""
									};
		int idOs = getJdbcTemplate().queryForInt(sqlBuilder.toString() ,args);
		return idOs;	
	}
	
	
	@Override
	public int saveUpsService(UpsServiceDTO service, Date created ,String createdBy,String createdByUsr) {
		// TODO Auto-generated method stub
		StringBuilder sqlBuilder = new StringBuilder();
		DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		sqlBuilder.append("CALL AddupsService(?,?,?,?,?,?,?,?,?,?,?,?,?)");
		Object[] args = new Object []{
										service.getServiceOrderId(),
										""+service.getEstatusEquipment()+"",
										service.getCleaned(),
										service.getHooverClean(),
										service.getVerifyConnections(),
										""+service.getCapacitorStatus()+"",
										service.getVerifyFuzz(),
										service.getChargerReview(),
										""+service.getFanStatus()+"",
										""+service.getObservations()+"",
										""+df.format(created)+"",
										""+createdBy+"",
										""+createdByUsr+""
									};
		int idOs = getJdbcTemplate().queryForInt(sqlBuilder.toString() ,args);
		
		sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddupsServiceBatteryBank(?,?,?,?,?,?,?,?,?,?,?)");
		args = new Object []{
								idOs,
								service.getCheckConnectors(),
								service.getCverifyOutflow(),
								service.getNumberBatteries(),
								""+service.getManufacturedDateSerial()+"",
								""+service.getDamageBatteries()+"",
								""+service.getOther()+"",
								service.getTemp(),
								service.getChargeTest(),
								""+service.getBrandModel()+"",
								service.getBatteryVoltage()
							};
		getJdbcTemplate().update(sqlBuilder.toString() ,args);
		
		
		sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddupsServiceGeneralTest(?,?,?,?,?)");
		args = new Object []{
								idOs,
								service.getTrasferLine(),
								service.getTransferEmergencyPlant(),
								service.getBackupBatteries(),
								service.getVerifyVoltage()
							};
		getJdbcTemplate().update(sqlBuilder.toString() ,args);
		
		
		sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddupsServiceParams(?,?,?,?,?,?,?,?,?)");
		args = new Object []{
								idOs,
								service.getInputVoltagePhase(),
								service.getInputVoltageNeutro(),
								service.getInputVoltageNeutroGround(),
								service.getPercentCharge(),
								service.getOutputVoltagePhase(),
								service.getOutputVoltageNeutro(),
								service.getInOutFrecuency(),
								service.getBusVoltage()
							};
		getJdbcTemplate().update(sqlBuilder.toString() ,args);

		return idOs;	
	}


	@Override
	public String getNewServiceNumber(String equipmentType) {
		if(equipmentType != null && equipmentType.length() > 1){
			equipmentType = equipmentType.substring(0, 1);
		}
		return getJdbcTemplate().queryForObject(String.format("CALL blackstarDb.GetNextServiceNumberForType('%s')", equipmentType), String.class);
	}


	@Override
	public List<JSONObject> getServiceOrdersByStatus(String status) {
		String sqlQuery = "CALL GetServiceOrders(?);";
		return getJdbcTemplate().query(sqlQuery, new Object[]{status}, new JSONRowMapper()); 
	}


	@Override
	public List<JSONObject> getServiceOrderHistory() {
		String sqlQuery = "CALL GetAllServiceOrders();";
		return getJdbcTemplate().query(sqlQuery, new JSONRowMapper()); 
	}

	@Override
	public List<JSONObject> getLimitedServiceOrdersHistory(String user) {
		String sqlQuery = "CALL GetLimitedServiceOrderList(?);";
		return getJdbcTemplate().query(sqlQuery, new Object[]{user}, new JSONRowMapper()); 
	}

	@Override
	public List<JSONObject> getEquipmentByType(String type) {
		String sqlQuery = "CALL GetEquipmentByType(?);";
		return getJdbcTemplate().query(sqlQuery, new Object[]{type}, new JSONRowMapper()); 
	}


	@Override
	public String getServiceOrderTypeBySOId(Integer serviceOrderId) {
		String sqlQuery = "CALL GetServiceOrderTypeBySOId(?);";
		return getJdbcTemplate().queryForObject(sqlQuery, new Object[]{serviceOrderId}, String.class); 
	}


	@Override
	public List<ServiceStatusDTO> getServiceStatusList() {
		String query = "CALL GetServiceStatusList()";
		return (List<ServiceStatusDTO>) getJdbcTemplate().query(query,  getMapperFor(ServiceStatusDTO.class));
	}


	@Override
	public List<FollowUpDTO> getServiceFollowUps(Integer serviceOrderId) {
		String query = "CALL GetFollowUpByServiceOrder(?)";
		return (List<FollowUpDTO>) getJdbcTemplate().query(query, getMapperFor(FollowUpDTO.class));
	}


	@Override
	public String getNewServiceNumber() {
		String query = "CALL GetNextServiceNumberForTicket()";
		return (String) getJdbcTemplate().queryForObject(query,  String.class);
	}


	@Override
	public List<JSONObject> getServiceOrderDetails(String orderNumber) {
		String query = "CALL GetServiceOrderDetails(?)";
		return (List<JSONObject>) getJdbcTemplate().query(query, new Object[]{orderNumber}, new JSONRowMapper());
	}


	@Override
	public List<JSONObject> getServiceOrdersByDate(Date startDate) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String query = "CALL GetAutoCompleteServiceOrdersByDate(?)";
		return (List<JSONObject>) getJdbcTemplate().query(query, new Object[]{sdf.format(startDate)}, new JSONRowMapper());
	}
}
