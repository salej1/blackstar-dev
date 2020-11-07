package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.ProjectStatusDAO;
import com.blackstar.model.ProjectStatus;
import com.blackstar.model.dto.ProjectStatusDTO;

public class ProjectStatusDAOImpl extends AbstractDAO implements ProjectStatusDAO {
	
	private static final String GET_PROJECT_STATUS_BY_ID = "GetProjectStatusById";

	public ProjectStatusDAOImpl() {
	}

	@Override
	public ProjectStatus getProjectStatusById(String statusId) {
		ProjectStatus projectStatus = null;
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL ").append(GET_PROJECT_STATUS_BY_ID).append("(?)");
		projectStatus = (ProjectStatus) getJdbcTemplate().queryForObject(
				sqlBuilder.toString(), new Object[] { statusId },
				getMapperFor(ProjectStatus.class));
		return projectStatus;
	}

	@Override
	public ProjectStatusDTO getProjectStatusDTOById(String statusId) {
		ProjectStatusDTO projectStatusDTO = null;
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL ").append(GET_PROJECT_STATUS_BY_ID).append("(?)");
		projectStatusDTO = (ProjectStatusDTO) getJdbcTemplate().queryForObject(
				sqlBuilder.toString(), new Object[] { statusId },
				getMapperFor(ProjectStatusDTO.class));
		return projectStatusDTO;
	}

	@Override
	public List<ProjectStatus> getAllProjectStatus() {
		throw new UnsupportedOperationException("Not supported yet.");
	}

	@Override
	public List<ProjectStatusDTO> getAllProjectStatusDTO() {
		throw new UnsupportedOperationException("Not supported yet.");
	}

	@Override
	public List<JSONObject> getAllProjectStatusJSON() {
		throw new UnsupportedOperationException("Not supported yet.");
	}

}
