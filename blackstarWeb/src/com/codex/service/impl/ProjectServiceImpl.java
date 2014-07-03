package com.codex.service.impl;

import com.blackstar.services.AbstractService;
import com.codex.db.ProjectDAO;
import com.codex.service.ProjectService;

public class ProjectServiceImpl extends AbstractService 
                                implements ProjectService {
	
	private ProjectDAO dao;

	public void setDao(ProjectDAO dao) {
		this.dao = dao;
	}

}
