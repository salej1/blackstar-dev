package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.ProjectFollowUp;
import com.blackstar.model.dto.ProjectFollowUpDTO;

/**
 * 
 * @author Mauricio Arellano
 *
 */
public interface ProjectFollowUpDAO {
	
	public int insertProjectFollowUp(ProjectFollowUp projectFollowUp);
	
	public boolean updateProjectFollowUp(ProjectFollowUp projectFollowUp);
	
	public ProjectFollowUp getProjectFollowUpById(Integer projectFollowUpId);
	
	public ProjectFollowUpDTO getProjectFollowUpDTOById(Integer projectFollowUpId);
	
	public List<ProjectFollowUp> getProjectFollowUpByProjectId(Integer projectId);
	
	public List<ProjectFollowUpDTO> getProjectFollowUpDTOByProjectId(Integer projectId);
	
	public List<JSONObject> getProjectFollowUpByProjectIdJSON();
}
