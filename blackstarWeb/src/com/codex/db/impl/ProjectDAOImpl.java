package com.codex.db.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.codex.db.ProjectDAO;
import com.codex.vo.CurrencyTypesVO;
import com.codex.vo.DeliverableTypesVO;
import com.codex.vo.DeliverableVO;
import com.codex.vo.PaymentTypeVO;
import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryItemVO;
import com.codex.vo.ProjectEntryTypesVO;
import com.codex.vo.ProjectEntryVO;
import com.codex.vo.ProjectVO;
import com.codex.vo.TaxesTypesVO;
import com.codex.vo.TicketTeamDTO;


@SuppressWarnings("unchecked")
public class ProjectDAOImpl extends AbstractDAO 
                            implements ProjectDAO {
	
  @Override
  public List<ProjectEntryTypesVO> getAllEntryTypes() {
	String sqlQuery = "CALL CodexGetEntryTypes()";
	return (List<ProjectEntryTypesVO>) getJdbcTemplate().query(sqlQuery
				            , getMapperFor(ProjectEntryTypesVO.class));
  }
  
  @Override
  public List<ProjectEntryItemTypesVO> getAllEntryItemTypes() {
	String sqlQuery = "CALL CodexGetEntryItemTypes()";
	return (List<ProjectEntryItemTypesVO>) getJdbcTemplate().query(sqlQuery
				            , getMapperFor(ProjectEntryItemTypesVO.class));
  }
  
  @Override
  public List<CurrencyTypesVO> getAllCurrencyTypes() {
	String sqlQuery = "CALL CodexGetCurrencyTypes()";
	return (List<CurrencyTypesVO>) getJdbcTemplate().query(sqlQuery
				            , getMapperFor(CurrencyTypesVO.class));
  }
  
  @Override
  public List<TaxesTypesVO> getAllTaxesTypes() {
	String sqlQuery = "CALL CodexGetTaxesTypes()";
	return (List<TaxesTypesVO>) getJdbcTemplate().query(sqlQuery
				            , getMapperFor(TaxesTypesVO.class));
  }
  
  @Override
  public List<Followup> getFollowUps(Integer projectId) {
	StringBuilder sqlBuilder = new StringBuilder("CALL GetFollowUpByProjectId(?)");
	return (List<Followup>) getJdbcTemplate().query(sqlBuilder.toString(),
				 new Object[] {projectId}, getMapperFor(Followup.class));
  }
  
  @Override
  public List<TicketTeamDTO> getWorkTeam(Integer projectId) {
		StringBuilder sqlBuilder = new StringBuilder("CALL GetWorkTeamByProjectId(?);");
		return (List<TicketTeamDTO>) getJdbcTemplate().query(
				sqlBuilder.toString(), new Object[] { projectId },
				getMapperFor(TicketTeamDTO.class));
	}

  @Override
  public List<User> getAsigneedUser(Integer projectId) {
	StringBuilder sqlBuilder = new StringBuilder("CALL GetResponsibleByProjectId(?)");
	return (List<User>) getJdbcTemplate().query(sqlBuilder.toString(),
			     new Object[] { projectId }, getMapperFor(User.class));
  }

  @Override
  public List<User> getResponseUser(Integer projectId) {
	StringBuilder sqlBuilder = new StringBuilder("CALL GetUserForResponseByProjectId(?)");
	return (List<User>) getJdbcTemplate().query(sqlBuilder.toString(),
				new Object[] { projectId }, getMapperFor(User.class));
  }

  @Override
  public void addFollow(Integer projectId, Integer userId, Integer asignedUserId
		                                                     , String comment) {
	StringBuilder sqlBuilder = new StringBuilder("CALL AddFollowUpToCodexProject(?, ?, ?, ?);");
	getJdbcTemplate().update(sqlBuilder.toString(),new Object[] { projectId
		                               , userId, asignedUserId, comment });
  }

  @Override
  public void addProjectTeam(Integer projectId, Integer roleId, Integer userId) {
	StringBuilder sqlBuilder = new StringBuilder("CALL UpsertWorkTeamByCodexProject(?, ?, ?);");
	getJdbcTemplate().update(sqlBuilder.toString(),new Object[] { projectId
		                                               , roleId, userId });
  }
  
  @Override
  public List<ProjectVO> getProjectDetail(Integer projectId) {
	StringBuilder sqlBuilder = new StringBuilder("CALL CodexGetProjectById(?)");
	return (List<ProjectVO>) getJdbcTemplate().query(sqlBuilder.toString(),
				new Object[] { projectId }, getMapperFor(ProjectVO.class));
  }
  
  @Override
  public Integer getNewProjectId() {
	StringBuilder sqlBuilder = new StringBuilder("CALL GetNextProjectId()");
	return getJdbcTemplate().queryForInt(sqlBuilder.toString());
  }
  
  @Override
  public Integer getNewEntryId() {
	StringBuilder sqlBuilder = new StringBuilder("CALL GetNextEntryId()");
	return getJdbcTemplate().queryForInt(sqlBuilder.toString());
  }
  
  @Override
  public List<DeliverableTypesVO> getDeliverableTypes() {
	StringBuilder sqlBuilder = new StringBuilder("CALL CodexGetDeliverableTypes()");
	return (List<DeliverableTypesVO>) getJdbcTemplate().query(sqlBuilder.toString() 
			                             , getMapperFor(DeliverableTypesVO.class));
  }
  
  @Override
  public List<DeliverableVO> getDeliverables(Integer projectId) {
	StringBuilder sqlBuilder = new StringBuilder("CALL CodexGetDeliverables(?)");
	return (List<DeliverableVO>) getJdbcTemplate().query(sqlBuilder.toString()
			   , new Object[]{projectId} , getMapperFor(DeliverableVO.class));
  }
  
  @Override
  public void addDeliverableTrace(Integer projectId, Integer deliverableTypeId
		                                                   , Integer userId) {
	String sqlQuery = "CALL CodexInsertDeliverableTrace(?, ?, ?)";
	getJdbcTemplate().update(sqlQuery, new Object[]{projectId, deliverableTypeId
			                                                         , userId});
  }
  
  @Override
  public List<JSONObject> getReferenceTypes(Integer itemTypeId) {
	String sqlQuery = "CALL CodexGetReferenceTypes(?)";
	return getJdbcTemplate().query(sqlQuery,new Object[]{itemTypeId} 
	                                         , new JSONRowMapper());
  }
  
  @Override
  public List<PaymentTypeVO> getAllPaymentTypes() {
	String sqlQuery = "CALL CodexGetPaymentTypes()";
	return (List<PaymentTypeVO>) getJdbcTemplate().query(sqlQuery
				            , getMapperFor(PaymentTypeVO.class));
  }
  
  @Override 
  public void insertProject(ProjectVO project){
	String sqlQuery = "CALL CodexInsertProject(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	getJdbcTemplate().update(sqlQuery, new Object[]{project.getId(), project.getClientId()
			            , project.getTaxesTypeId(), project.getStatusId()
			            , project.getPaymentTypeId(), project.getCurrencyTypeId()
			            , project.getProjectNumber(), project.getCostCenter()
			            , project.getChangeType(), project.getCreated()
			            , project.getContactName(), project.getLocation()
			            , project.getAdvance(), project.getTimeLimit()
			            , project.getSettlementTimeLimit(), project.getDeliveryTime()
			            , project.getIntercom(), project.getProductsNumber()
			            , project.getFinancesNumber(), project.getServicesNumber()
			                                  , project.getTotalProjectNumber()});
  }
  
  @Override
  public void insertProjectEntry(Integer entryId, Integer projectId
		                         , Integer entryTypeId, String description 
		                         , Float discount, Float totalPrice
		                         , String comments) {
	 String sqlQuery = "CALL CodexInsertProjectEntry(?, ?, ?, ?, ?, ?, ?)";
	 getJdbcTemplate().update(sqlQuery, new Object[]{entryId, projectId
	      , entryTypeId, description, discount, totalPrice, comments});
  }
  
  @Override
  public void insertEntryItem(Integer entryId, Integer itemTypeId
		                    , String reference, String description 
		                    , Integer  quantity, Float priceByUnit
		                    , Float discount, Float totalPrice, String comments){
    String sqlQuery = "CALL CodexInsertProjectEntryItem(?, ?, ?, ?, ?, ?, ? ,?, ?)";
	getJdbcTemplate().update(sqlQuery, new Object[]{entryId, itemTypeId, reference
		   , description, quantity, priceByUnit, discount, totalPrice, comments});
  }
  
  @Override
  public List<JSONObject> getAllProjectsJson() {
	String sqlQuery = "CALL CodexGetAllProjects()";
	return getJdbcTemplate().query(sqlQuery , new JSONRowMapper());
  }
  
  @Override
  public List<ProjectEntryVO> getEntriesByProject(Integer projectId) {
	String sqlQuery = "CALL CodexGetEntriesByProject(?)";
	return (List<ProjectEntryVO>) getJdbcTemplate().query(sqlQuery
			     , new Object[]{projectId}, getMapperFor(ProjectEntryVO.class));
  }
  
  @Override
  public List<ProjectEntryItemVO> getItemsByEntry(Integer entryId) {
	String sqlQuery = "CALL CodexGetItemsByEntry(?)";
	return (List<ProjectEntryItemVO>) getJdbcTemplate().query(sqlQuery
			   , new Object[]{entryId}, getMapperFor(ProjectEntryItemVO.class));
  }

}
