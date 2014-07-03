package com.codex.service.impl;

import java.util.List;

import com.blackstar.services.AbstractService;
import com.codex.db.ProjectDAO;
import com.codex.service.ProjectService;
import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryTypesVO;

public class ProjectServiceImpl extends AbstractService 
                                implements ProjectService {
	
  private ProjectDAO dao;

  public void setDao(ProjectDAO dao) {
	this.dao = dao;
  }
  
  @Override
  public List<ProjectEntryTypesVO> getAllEntryTypes(){
	  return dao.getAllEntryTypes();
  }
  
  @Override
  public List<ProjectEntryItemTypesVO> getAllEntryItemTypes(){
	  return dao.getAllEntryItemTypes();
  }

}
