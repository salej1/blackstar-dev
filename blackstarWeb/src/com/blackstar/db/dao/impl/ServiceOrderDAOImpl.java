package com.blackstar.db.dao.impl;

import java.util.List;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.ServiceOrderDAO;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;


@SuppressWarnings("unchecked")
public class ServiceOrderDAOImpl extends AbstractDAO implements ServiceOrderDAO {
 
  public OrderserviceDTO getServiceOrderByIdOrNumber(Integer serviceOrderId, String orderNumber){
	StringBuilder sqlBuilder = new StringBuilder();
	//Se sugiere generar un SP y cambiar la invocacion por 
	//        sqlBuilder.append("CALL GetServiceOrderByIdOrNumber(?,?)");
	sqlBuilder.append("SELECT SO.coordinator AS 'coordinator', SO.serviceOrderId AS 'serviceOrderId',")
	          .append("       SO.serviceOrderNumber AS 'serviceOrderNo', TK.ticketNumber AS 'ticketNo',")
	          .append("       TK.ticketId AS 'ticketId', PY.customer AS 'customer',")
	          .append("       PY.equipmentAddress AS 'equipmentAddress', PY.contactName AS 'contactName',")
	          .append("       SO.serviceDate AS 'serviceDate', PY.contactPhone AS 'contactPhone',")
	          .append("       ET.equipmentType AS 'equipmentType', PY.brand AS 'equipmentBrand',")
	          .append("       PY.model AS 'equipmentModel', PY.serialNumber AS 'equipmentSerialNo',")
	          .append("       TK.observations AS 'failureDescription', ST.serviceType AS 'serviceType',")
	          .append("       PY.project AS 'proyectNumber', '' AS 'detailIssue',")
	          .append("       '' AS 'detailWorkDone', '' AS 'detailTechnicalJob',")
	          .append("       '' AS 'detailRequirments', SO.serviceComments AS 'detailStatus',")
	          .append("       SO.signCreated AS 'signCreated', SO.signReceivedBy AS 'signReceivedBy',")
	          .append("       SO.receivedBy AS 'receivedBy', SO.responsible AS 'responsible',")
	          .append("       SO.closed AS 'closed', SO.receivedByPosition AS 'receivedByPosition' ")
	          .append("FROM serviceOrder SO, policy PY, ticket TK,")
	          .append("     serviceType ST, equipmentType ET ")
	          .append("WHERE (SO.serviceOrderId = ? OR SO.serviceOrderNumber = ?)")
	          .append("      AND SO.policyId = PY.policyId")
	          .append("      AND SO.ticketId = TK.ticketId")
	          .append("      AND SO.serviceTypeId = ST.serviceTypeId")
	          .append("      AND PY.equipmentTypeId = ET.equipmentTypeId");
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
}
