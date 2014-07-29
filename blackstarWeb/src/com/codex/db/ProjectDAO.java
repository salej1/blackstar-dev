package com.codex.db;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Followup;
import com.blackstar.model.User;
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
	public void addFollow(Integer projectId, Integer userId, Integer asignedUserId
                                                                , String comment);
	public void addProjectTeam(Integer projectId, Integer roleId, Integer userId);
	public List<ProjectVO> getProjectDetail(Integer projectId);
	public Integer getNewProjectId();
	public List<DeliverableTypesVO> getDeliverableTypes();
	public void addDeliverableTrace(Integer projectId, Integer deliverableTypeId
                                                              , Integer userId);
	public List<JSONObject> getReferenceTypes(Integer itemTypeId);
	public List<PaymentTypeVO> getAllPaymentTypes(); 
	public void upsertProjectEntry(Integer entryId, Integer projectId
            , Integer entryTypeId, String description 
            , Float discount, Float totalPrice
            , String comments);
	public void upsertEntryItem(Integer itemId, Integer entryId, Integer itemTypeId
                      , String reference, String description , Integer  quantity
                      , Float priceByUnit, Float discount, Float totalPrice
                      , String comments);
	public void upsertProject(ProjectVO project);
	public Integer getNewEntryId();
	public List<JSONObject> getAllProjectsJson();
	public List<ProjectEntryVO> getEntriesByProject(Integer projectId);
	public List<ProjectEntryItemVO> getItemsByEntry(Integer entryId);
	public List<DeliverableVO> getDeliverables(Integer projectId);
	public void advanceStatus(Integer projectId);
	public User getSalesManger();
	public User getResponsable(Integer projectId);
	public void cleanProjectDependencies(Integer projectId);
}
