package com.codex.service;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.codex.vo.CurrencyTypesVO;
import com.codex.vo.DeliverableTypesVO;
import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryTypesVO;
import com.codex.vo.TaxesTypesVO;
import com.codex.vo.TicketTeamDTO;

public interface ProjectService {
	
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
  public void sendNotification(Integer fromUserId, Integer toUserId 
		                       , Integer projectId, String detail);
  public Integer getNewProjectId();
  public List<DeliverableTypesVO> getDeliverableTypes();
  public void addDeliverableTrace(Integer projectId, Integer deliverableTypeId
                                                            , Integer userId);
  public String getReferenceTypes(Integer itemTypeId);
  
}
