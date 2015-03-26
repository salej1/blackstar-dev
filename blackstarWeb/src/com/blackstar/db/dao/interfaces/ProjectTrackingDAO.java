package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.ProjectTracking;
import com.blackstar.model.dto.ProjectTrackingDTO;

/**
 * 
 * @author Mauricio Arellano
 *
 */
public interface ProjectTrackingDAO {
	
	public int insertProjectTracking(ProjectTracking projectTracking);
	
	public boolean updateProjectTracking(ProjectTracking projectTracking);
	
	public ProjectTracking getProjectTrackingById(Integer projectTrackingId);
	
	public ProjectTrackingDTO getProjectTrackingDTOById(Integer projectTrackingId);
	
	public List<ProjectTracking> getProjectTrackingByProjectId(Integer projectId);
	
	public List<ProjectTrackingDTO> getProjectTrackingDTOByProjectId(Integer projectId);
	
	public List<JSONObject> getProjectTrackingByProjectIdJSON();
	
}
