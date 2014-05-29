package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.ProjectTrackingDAO;
import com.blackstar.model.ProjectTracking;
import com.blackstar.model.dto.ProjectTrackingDTO;

/**
 * 
 * @author Mauricio Arellano
 *
 */
public class ProjectTrackingDAOImpl extends AbstractDAO implements ProjectTrackingDAO {
	
	private static final String SP_ADD_PROJECT_TRACKING = "AddProjectTracking";
	private static final String SP_GET_PROJECT_TRACKING_BY_PROJECT_ID = "GetProjectTrakingByProjectId";

	@Override
	public int insertProjectTracking(ProjectTracking projectTracking) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL ").append(SP_ADD_PROJECT_TRACKING).append("(?,?,?,?,?);");
		Object[] args = new Object[]{
				projectTracking.getProjectId(),
				projectTracking.getProjectTrakingFileType(),
				projectTracking.getUser(),
				projectTracking.getFilePath(),
				projectTracking.getTrackingDate()
		};
		
		return getJdbcTemplate().queryForInt(sqlBuilder.toString(), args);
	}

	@Override
	public boolean updateProjectTracking(ProjectTracking projectTracking) {
		throw new UnsupportedOperationException("Not supported yet.");
	}

	@Override
	public ProjectTracking getProjectTrackingById(Integer projectTrackingId) {
		throw new UnsupportedOperationException("Not supported yet.");
	}

	@Override
	public ProjectTrackingDTO getProjectTrackingDTOById(Integer projectTrackingId) {
		throw new UnsupportedOperationException("Not supported yet.");
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ProjectTracking> getProjectTrackingByProjectId(Integer projectId) {
		return (List<ProjectTracking>) getJdbcTemplate().query(
				"CALL "+SP_GET_PROJECT_TRACKING_BY_PROJECT_ID+"('"+projectId+"');",
				getMapperFor(ProjectTracking.class));
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ProjectTrackingDTO> getProjectTrackingDTOByProjectId(Integer projectId) {
		return (List<ProjectTrackingDTO>) getJdbcTemplate().query(
				"CALL "+SP_GET_PROJECT_TRACKING_BY_PROJECT_ID+"('"+projectId+"');",
				getMapperFor(ProjectTrackingDTO.class));
	}

	@Override
	public List<JSONObject> getProjectTrackingByProjectIdJSON() {
		throw new UnsupportedOperationException("Not supported yet.");
	}

}
