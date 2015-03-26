package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.ProjectStatus;
import com.blackstar.model.dto.ProjectStatusDTO;


/**
 * 
 * @author Mauricio Arellano
 *
 */
public interface ProjectStatusDAO {
	
	public ProjectStatus getProjectStatusById(String statusId);
	
	public ProjectStatusDTO getProjectStatusDTOById(String statusId);
	
	public List<ProjectStatus> getAllProjectStatus();
	
	public List<ProjectStatusDTO> getAllProjectStatusDTO();
	
	public List<JSONObject> getAllProjectStatusJSON();

}
