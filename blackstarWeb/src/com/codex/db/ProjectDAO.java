package com.codex.db;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.codex.model.dto.CostCenterDTO;
import com.codex.model.dto.DeliverableTraceDTO;
import com.codex.vo.CurrencyTypesVO;
import com.codex.vo.DeliverableTypesVO;
import com.codex.vo.DeliverableVO;
import com.codex.vo.PaymentTypeVO;
import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryItemVO;
import com.codex.vo.ProjectEntryTypesVO;
import com.codex.vo.ProjectEntryVO;
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
	public void addFollow(Integer projectId, String userId, String asignedUserId
                                                                , String comment);
	public void addProjectTeam(Integer projectId, Integer roleId, Integer userId);
	public List<ProjectVO> getProjectDetail(Integer projectId);
	public Integer getNewProjectId(String type);
	public List<DeliverableTypesVO> getDeliverableTypes();
	public void addDeliverableTrace(DeliverableTraceDTO deliverable);
	public List<JSONObject> getReferenceTypes(Integer itemTypeId);
	public List<PaymentTypeVO> getAllPaymentTypes(); 
	public Integer upsertProjectEntry(Integer entryId, Integer projectId
            , Integer entryTypeId, String description 
            , Integer qty, Float unitPrice, Float discount, Float totalPrice
            , String comments);
	public void upsertEntryItem(Integer itemId, Integer entryId, Integer itemTypeId
                      , String reference, String description , Float  quantity
                      , Float priceByUnit, Float discount, Float totalPrice
                      , String comments);
	public Integer upsertProject(ProjectVO project);
	public List<ProjectEntryVO> getEntriesByProject(Integer projectId);
	public List<ProjectEntryItemVO> getItemsByEntry(Integer entryId);
	public List<DeliverableVO> getDeliverables(Integer projectId);
	public void advanceStatus(Integer projectId, Integer statusId);
	public List<User> getSalesManger();
	public User getResponsable(Integer projectId);
	public void cleanProjectDependencies(Integer projectId);
	public List<JSONObject> getAllProjectsByUsrJson(Integer userId);
	public List<CostCenterDTO> getCostCenterList();
	public String getCSTOffice(String cst);
	public List<JSONObject> getPriceList();
	public List<JSONObject> getPriceProposalList(Integer projectId);
}
