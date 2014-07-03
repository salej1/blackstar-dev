package com.codex.db;

import java.util.List;

import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryTypesVO;

public interface ProjectDAO {
	
	public List<ProjectEntryTypesVO> getAllEntryTypes();
	public List<ProjectEntryItemTypesVO> getAllEntryItemTypes();

}
