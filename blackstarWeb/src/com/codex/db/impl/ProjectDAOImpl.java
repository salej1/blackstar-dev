package com.codex.db.impl;

import java.util.List;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.codex.db.ProjectDAO;
import com.codex.vo.CurrencyTypesVO;
import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryTypesVO;
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
  public void addFollow(Integer projectId, Integer userId, String comment) {
	StringBuilder sqlBuilder = new StringBuilder("CALL AddFollowUpToCodexProject(?, ?, ?);");
	getJdbcTemplate().update(sqlBuilder.toString(),new Object[] { projectId
		                                             , userId, comment });
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

}
