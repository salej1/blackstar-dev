package com.codex.db.impl;

import java.util.List;

import com.blackstar.db.dao.AbstractDAO;
import com.codex.db.ProjectDAO;
import com.codex.vo.CurrencyTypesVO;
import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryTypesVO;
import com.codex.vo.TaxesTypesVO;


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

}
