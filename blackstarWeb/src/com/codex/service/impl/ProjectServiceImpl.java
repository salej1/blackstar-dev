package com.codex.service.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.UserDAO;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.blackstar.services.AbstractService;
import com.blackstar.services.EmailServiceFactory;
import com.codex.db.ProjectDAO;
import com.codex.service.ProjectService;
import com.codex.vo.CurrencyTypesVO;
import com.codex.vo.DeliverableTypesVO;
import com.codex.vo.DeliverableVO;
import com.codex.vo.PaymentTypeVO;
import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryTypesVO;
import com.codex.vo.ProjectEntryVO;
import com.codex.vo.ProjectVO;
import com.codex.vo.TaxesTypesVO;
import com.codex.vo.TicketTeamDTO;

public class ProjectServiceImpl extends AbstractService 
                                implements ProjectService {
	
  private ProjectDAO dao;
  private UserDAO uDAO = null;

  public void setDao(ProjectDAO dao) {
	this.dao = dao;
  }
  
  public void setuDAO(UserDAO uDAO) {
	this.uDAO = uDAO;
  }
  
  @Override
  public List<ProjectEntryTypesVO> getAllEntryTypes(){
	  return dao.getAllEntryTypes();
  }
  
  @Override
  public List<ProjectEntryItemTypesVO> getAllEntryItemTypes(){
	  return dao.getAllEntryItemTypes();
  }
  
  @Override
  public List<CurrencyTypesVO> getAllCurrencyTypes(){
	return dao.getAllCurrencyTypes();
  }
  
  @Override
  public List<TaxesTypesVO> getAllTaxesTypes(){
	return dao.getAllTaxesTypes();
  }
  
  @Override
  public List<Followup> getFollowUps(Integer projectId){
	return dao.getFollowUps(projectId);
  }

  @Override
  public List<TicketTeamDTO> getWorkTeam(Integer projectId) {
	return dao.getWorkTeam(projectId);
  }

  @Override
  public List<User> getAsigneedUser(Integer projectId) {
	return dao.getAsigneedUser(projectId);
  }

  @Override
  public List<User> getResponseUser(Integer projectId) {
	return dao.getResponseUser(projectId);
  }

  @Override
  public void addFollow(Integer projectId, Integer userId, Integer assignedUserId
		                                                      , String comment) {
	dao.addFollow(projectId, userId, assignedUserId, comment);
  }

  @Override
  public void addProjectTeam(Integer projectId, Integer roleId, Integer userId) {
	dao.addProjectTeam(projectId, roleId, userId);
  }
  
  @Override
  public void sendNotification(Integer fromUserId, Integer toUserId 
		                      , Integer projectId, String detail) {
	List<ProjectVO> projects = dao.getProjectDetail(projectId);
	ProjectVO project = null;
	StringBuilder message;
	User to;
	User from;
	if(projects.size() > 0){
	  project = projects.get(0);
	  message = new StringBuilder();
	  System.out.println("sendNot=> From(" + fromUserId + "), to(" + toUserId + ")");
	  to = uDAO.getUserById(toUserId);
	  from = uDAO.getUserById(fromUserId);
	  IEmailService mail = EmailServiceFactory.getEmailService();
	  message.append(String.format("La requisicion %s le ha sido asignada para dar seguimiento. Por favor revise a continuación los detalles: ", project.getProjectNumber()));
	  message.append(String.format("\r\n\r\n Estatus: %s", project.getStatusDescription()));
	  message.append(String.format("\r\n\r\n Cliente: %s", project.getClientDescription()));
	  message.append(String.format("\r\n\r\n"));
	  message.append(String.format("\r\n\r\n Usuario que asignó: %s", from.getUserName()));
	  message.append(String.format("\r\n\r\n Mensaje: %s", detail));
	  mail.sendEmail(from.getUserEmail(), to.getUserEmail(), "Asignación de Proyecto " + project.getProjectNumber(), message.toString());
	}
  }

  @Override
  public ProjectVO getProjectDetail(Integer projectId) {
	ProjectVO project = null;
	List<ProjectEntryVO> entries = null;
	List<ProjectVO> projects = dao.getProjectDetail(projectId);
	if(projects.size() == 0){
		return null;
	} else {
		project = projects.get(0);
	}
	entries = dao.getEntriesByProject(project.getId());
	for(ProjectEntryVO entry : entries){
	  entry.setItems(dao.getItemsByEntry(entry.getId()));
	}
	project.setEntries(entries);
	return project;
  }
  
  
  @Override
  public Integer getNewProjectId(){
	return dao.getNewProjectId();
  }
  
  @Override
  public List<DeliverableTypesVO> getDeliverableTypes(){
	return dao.getDeliverableTypes();
  }
  
  @Override
  public void addDeliverableTrace(Integer projectId, Integer deliverableTypeId
                                                            , Integer userId){
	dao.addDeliverableTrace(projectId, deliverableTypeId, userId);
  }
  
  @Override
  public String getReferenceTypes(Integer itemTypeId){
	List<JSONObject> types = dao.getReferenceTypes(itemTypeId);
	return types != null ? encode(types.toString()): "";
  }
  
  @Override
  public String getAllProjectsJson(){
	List<JSONObject> types = dao.getAllProjectsJson();
	return types != null ? encode(types.toString()): "";
  }
  
  @Override
  public List<PaymentTypeVO> getAllPaymentTypes(){
	return dao.getAllPaymentTypes();
  }
  
  @Override
  public void insertProject(ProjectVO project){
	String [] entries = project.getStrEntries().split("~");
	String [] items, values;
	Integer entryId;
	dao.insertProject(project);
	for(String entry : entries){
		values = entry.split("\\|");
		entryId = dao.getNewEntryId();
		dao.insertProjectEntry(entryId, project.getId(), Integer.valueOf(values[0])
				, values[1], Float.valueOf(values[2]), Float.valueOf(values[3])
				                                                  , values[4]);
		items = values[5].split("\\^");
		for(String item : items){
			values = item.split("°");
			System.out.println("Mesagge=> " + entryId + ", " + Integer.valueOf(values[0]) + ", " + values[2] + ", " + Integer.valueOf(values[3]) + ", " + Float.valueOf(values[4]));
			dao.insertEntryItem(entryId, Integer.valueOf(values[0]), values[1]
			   , values[2], Integer.valueOf(values[3]), Float.valueOf(values[4])
			   , Float.valueOf(values[5]), Float.valueOf(values[6]), values[7]);
		}
	}
	  
  }
  
  @Override
  public List<DeliverableVO> getDeliverables(Integer projectId){
	 return dao.getDeliverables(projectId);
  }
  
  @Override
  public void advanceStatus(ProjectVO project){
	switch(project.getStatusId()){
	  case 1: gotoByAuthStatus(project);
	          break;
	  case 2: gotoAuthStatus(project);
              break;      
	}
  }
  
  private void gotoByAuthStatus(ProjectVO project){
	StringBuilder message = new StringBuilder();
	
	IEmailService mail = EmailServiceFactory.getEmailService();
	dao.advanceStatus(project.getId());
//	User to = dao.getManagerForProject(project.getId());
//	message.append(String.format("Proyecto pendiente de Autorización: ", project.getProjectNumber()));
//	message.append(String.format("\r\n\r\n Estatus: %s", project.getStatusDescription()));
//	message.append(String.format("\r\n\r\n Cliente: %s", project.getClientDescription()));
//	message.append(String.format("\r\n\r\n"));
//	mail.sendEmail("portal-servicios@gposac.com.mx", to.getUserEmail(), "Proyecto pendiente de Autorización " + project.getProjectNumber(), message.toString());
  }
  
  private void gotoAuthStatus(ProjectVO project){
	  dao.advanceStatus(project.getId());
  }

}
