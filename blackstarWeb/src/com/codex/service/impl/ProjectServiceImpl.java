package com.codex.service.impl;

import java.util.List;

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
import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryTypesVO;
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
  public void addFollow(Integer projectId, Integer userId, String comment) {
	dao.addFollow(projectId, userId, comment);
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
	  to = uDAO.getUserById(toUserId);
	  from = uDAO.getUserById(toUserId);
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

}
