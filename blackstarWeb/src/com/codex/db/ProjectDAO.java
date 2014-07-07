package com.codex.db;

import java.util.List;

import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.codex.vo.CurrencyTypesVO;
import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryTypesVO;
import com.codex.vo.ProjectVO;
import com.codex.vo.TaxesTypesVO;
import com.codex.vo.TicketTeamDTO;

public interface ProjectDAO {
	
	public List<ProjectEntryTypesVO> getAllEntryTypes();
	public List<ProjectEntryItemTypesVO> getAllEntryItemTypes();
	public List<CurrencyTypesVO> getAllCurrencyTypes();
	public List<TaxesTypesVO> getAllTaxesTypes();
	public List<Followup> getFollowUps(Integer projectId);
	public List<TicketTeamDTO> getWorkTeam(Integer projectId);
	public List<User> getAsigneedUser(Integer projectId);
	public List<User> getResponseUser(Integer projectId);
	public void addFollow(Integer projectId, Integer userId, String comment);
	public void addProjectTeam(Integer projectId, Integer roleId, Integer userId);
	public List<ProjectVO> getProjectDetail(Integer projectId);
	public Integer getNewProjectId();

}
