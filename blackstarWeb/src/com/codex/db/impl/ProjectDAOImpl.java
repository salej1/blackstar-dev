package com.codex.db.impl;

import java.util.List;

import com.blackstar.db.dao.AbstractDAO;
import com.codex.db.ProjectDAO;
import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryTypesVO;


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

}
