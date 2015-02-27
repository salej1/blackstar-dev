package com.codex.service;

import java.util.List;

import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.codex.model.dto.CostCenterDTO;
import com.codex.model.dto.CstDTO;
import com.codex.model.dto.DeliverableTraceDTO;
import com.codex.vo.CurrencyTypesVO;
import com.codex.vo.DeliverableTypesVO;
import com.codex.vo.DeliverableVO;
import com.codex.vo.PaymentTypeVO;
import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryTypesVO;
import com.codex.vo.ProjectVO;
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
  public void addFollow(Integer projectId, String userId, String assignedUserId
                                                               , String comment);
  public void addProjectTeam(Integer projectId, Integer roleId, Integer userId);
  public void sendNotification(String fromUserId, String toUser 
		                       , Integer projectId, String detail);
  public Integer getNewProjectId(String type);
  public List<DeliverableTypesVO> getDeliverableTypes();
  public void addDeliverableTrace(DeliverableTraceDTO deliverable);
  public String getReferenceTypes(Integer itemTypeId);
  public List<PaymentTypeVO> getAllPaymentTypes();
  public void insertProject(ProjectVO project, User user);
  public void updateProject(ProjectVO project, User user);
  public String getAllProjectsByUsrJson(Integer userId);
  public ProjectVO getProjectDetail(Integer projectId);
  public ProjectVO getProjectDetail(Integer projectId, CstDTO cst);
  public List<DeliverableVO> getDeliverables(Integer projectId);
  public void advanceStatus(ProjectVO project) throws Exception;
  public void fallbackStatus(ProjectVO project) throws Exception;

  public List<CostCenterDTO> getCostCenterList();
  public String getCSTOffice(String cst);
  public List<String> getIncotermList();
  public String getPriceList();
  public String getPriceProposalList(Integer projectId);
}
