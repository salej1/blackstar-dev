package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.ProjectFollowUpDAO;
import com.blackstar.model.ProjectFollowUp;
import com.blackstar.model.dto.CustomerListDTO;
import com.blackstar.model.dto.ProjectFollowUpDTO;

public class ProjectFollowUpDAOImpl extends AbstractDAO implements ProjectFollowUpDAO {
	
	private static final String SP_GET_PROJECT_FOLLOWUP_BY_ID = "";
	private static final String SP_GET_PROJECT_FOLLOWUP_BY_PROJECT_ID = "GetProjectFollowUpByProjectId";
	private static final String SP_ADD_PROJECT_FOLLOWUP = "AddProjectFollowUp";
	private static final String SP_UPDATE_PROJECT_FOLLOWUP = "";
	
	@Override
	public int insertProjectFollowUp(ProjectFollowUp projectFollowUp) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL ").append(SP_ADD_PROJECT_FOLLOWUP).append("(?,?,?,?,?);");
		Object[] args = new Object[]{
				projectFollowUp.getProjectId(),
				projectFollowUp.getFollowUpDate(),
				projectFollowUp.getUserAssigner(),
				projectFollowUp.getUserAssigned(),
				projectFollowUp.getComment()
		};
		
		return getJdbcTemplate().queryForInt(sqlBuilder.toString(), args);
	}

	@Override
	public boolean updateProjectFollowUp(ProjectFollowUp tracing) {
		throw new UnsupportedOperationException("Not supported yet."); 
	}

	@Override
	public ProjectFollowUp getProjectFollowUpById(Integer tracingId) {
//		ProjectFollowUp tracing = null;
//		StringBuilder sqlBuilder = new StringBuilder();
//		sqlBuilder.append("CALL " + SP_GET_PROJECT_FOLLOWUP_BY_ID + "(?)");
//		tracing = (ProjectFollowUp) getJdbcTemplate().queryForObject(sqlBuilder.toString(), 
//				new Object[] { tracingId }, 
//				getMapperFor(ProjectFollowUp.class)); 
//		return tracing;
		throw new UnsupportedOperationException("Not supported yet.");
	}

	@Override
	public ProjectFollowUpDTO getProjectFollowUpDTOById(Integer tracingId) {
//		ProjectFollowUpDTO tracing = null;
//		StringBuilder sqlBuilder = new StringBuilder();
//		sqlBuilder.append("CALL " + SP_GET_PROJECT_FOLLOWUP_BY_ID + "(?)");
//		tracing = (ProjectFollowUpDTO) getJdbcTemplate().queryForObject(sqlBuilder.toString(), 
//				new Object[] { tracingId }, 
//				getMapperFor(ProjectFollowUpDTO.class)); 
//		return tracing;
		throw new UnsupportedOperationException("Not supported yet.");
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ProjectFollowUp> getProjectFollowUpByProjectId(Integer projectId) {
		return (List<ProjectFollowUp>) getJdbcTemplate().query(
				"CALL "+SP_GET_PROJECT_FOLLOWUP_BY_PROJECT_ID+"('"+projectId+"');",
				getMapperFor(ProjectFollowUp.class));
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ProjectFollowUpDTO> getProjectFollowUpDTOByProjectId(Integer projectId) {
		return (List<ProjectFollowUpDTO>) getJdbcTemplate().query(
				"CALL "+SP_GET_PROJECT_FOLLOWUP_BY_PROJECT_ID+"('"+projectId+"');",
				getMapperFor(ProjectFollowUpDTO.class));
	}

	@Override
	public List<JSONObject> getProjectFollowUpByProjectIdJSON() {
		throw new UnsupportedOperationException("Not supported yet."); 
	}

}
