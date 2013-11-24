package com.blackstar.db.dao.impl;

import java.util.List;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.AirCoServiceDTO;
import com.blackstar.model.dto.BatteryCellServiceDTO;
import com.blackstar.model.dto.BatteryServiceDTO;
import com.blackstar.model.dto.EmergencyPlantServiceDTO;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.model.dto.PlainServiceDTO;
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
	         .append("        , SO.ticketId AS 'ticketId', SO.serviceTypeId AS 'serviceTypeId' ");
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
  public int insertServiceOrder() {
	// TODO Auto-generated method stub
	return 0;
  }

  @Override
  public boolean updateServiceOrder() {
	// TODO Auto-generated method stub
	return false;
  }

	
	@Override
	public AirCoServiceDTO getAirCoService(Integer aaServiceId) {
		
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetAirCoServiceByIdService(?)");
		return (AirCoServiceDTO) getJdbcTemplate().query(sqlBuilder.toString() 
				, new Object []{aaServiceId}, getMapperFor(AirCoServiceDTO.class));
	}
	
	
	@Override
	public BatteryServiceDTO getBateryService(Integer bbServiceId) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetBatteryServiceByIdService(?)");
		return (BatteryServiceDTO) getJdbcTemplate().query(sqlBuilder.toString() 
				, new Object []{bbServiceId}, getMapperFor(BatteryServiceDTO.class));
	}
	
	
	@Override
	public EmergencyPlantServiceDTO getEmergencyPlantService(Integer epServiceId) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetEmergencyPlantServiceByIdService(?)");
		return (EmergencyPlantServiceDTO) getJdbcTemplate().query(sqlBuilder.toString() 
				, new Object []{epServiceId}, getMapperFor(EmergencyPlantServiceDTO.class));
	}
	
	
	@Override
	public PlainServiceDTO getPlainService(Integer plainServiceId) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetPlainServiceServiceByIdService(?)");
		return (PlainServiceDTO) getJdbcTemplate().query(sqlBuilder.toString() 
				, new Object []{plainServiceId}, getMapperFor(PlainServiceDTO.class));
	}
	
	
	@Override
	public UpsServiceDTO getUpsService(Integer upsServiceId) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetUPSServiceByIdService(?)");
		return (UpsServiceDTO) getJdbcTemplate().query(sqlBuilder.toString() 
				, new Object []{upsServiceId}, getMapperFor(UpsServiceDTO.class));
	}
	
	@Override
	public List<BatteryCellServiceDTO> getBatteryCells(Integer bbServiceId) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetCellBatteryServiceByIdBatteryService(?)");
		return (List<BatteryCellServiceDTO>) getJdbcTemplate().query(sqlBuilder.toString() 
				, new Object []{bbServiceId}, getMapperFor(FollowUpDTO.class));
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
