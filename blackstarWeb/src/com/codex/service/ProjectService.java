package com.codex.service;

import java.util.List;

import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryTypesVO;

public interface ProjectService {
	
  public List<ProjectEntryTypesVO> getAllEntryTypes();
  public List<ProjectEntryItemTypesVO> getAllEntryItemTypes();

}
