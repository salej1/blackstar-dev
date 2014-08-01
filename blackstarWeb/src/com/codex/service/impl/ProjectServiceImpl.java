package com.codex.service.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.UserDAO;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.blackstar.services.AbstractService;
import com.blackstar.services.EmailServiceFactory;
import com.codex.db.ClientDAO;
import com.codex.db.ProjectDAO;
import com.codex.service.PDFReportService;
import com.codex.service.PriceProposalService;
import com.codex.service.ProjectService;
import com.codex.vo.ClientVO;
import com.codex.vo.CurrencyTypesVO;
import com.codex.vo.DeliverableTypesVO;
import com.codex.vo.DeliverableVO;
import com.codex.vo.PaymentTypeVO;
import com.codex.vo.PriceProposalVO;
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
  private ClientDAO cDAO = null;
  private PDFReportService pdfService = null;
  private PriceProposalService priceProposalService = null;
  private IEmailService gmService = null;
  
  public void setPriceProposalService(PriceProposalService priceProposalService) {
	this.priceProposalService = priceProposalService;
  }
  
  public void setGmService(IEmailService gmService) {
	this.gmService = gmService;
  }
  
  public void setcDAO(ClientDAO cDAO) {
	this.cDAO = cDAO;
  }
  
  public void setDao(ProjectDAO dao) {
	this.dao = dao;
  }
  
  public void setuDAO(UserDAO uDAO) {
	this.uDAO = uDAO;
  }
  
  public void setPdfService(PDFReportService pdfService) {
	this.pdfService = pdfService;
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
  public String getAllProjectsByUsrJson(Integer userId){
	List<JSONObject> types = dao.getAllProjectsByUsrJson(userId);
	return types != null ? encode(types.toString()): "";
  }
  
  @Override
  public List<PaymentTypeVO> getAllPaymentTypes(){
	return dao.getAllPaymentTypes();
  }
  
  @Override
  public void insertProject(ProjectVO project, User user){
	String [] entries = project.getStrEntries().split("~");
	String [] items, values;
	Integer entryId;
	project.setCreatedByUsr(user.getBlackstarUserId());
	dao.upsertProject(project);
	for(String entry : entries){
		values = entry.split("\\|");
		entryId = dao.getNewEntryId();
		dao.upsertProjectEntry(entryId, project.getId(), Integer.valueOf(values[0])
				, values[1], Float.valueOf(values[2]), Float.valueOf(values[3])
				                                                  , values[4]);
		items = values[6].split("\\^");
		for(String item : items){
			values = item.split("°");
			dao.upsertEntryItem(-1, entryId, Integer.valueOf(values[0]), values[1]
			   , values[2], Integer.valueOf(values[3]), Float.valueOf(values[4])
			   , Float.valueOf(values[5]), Float.valueOf(values[6]), values[7]);
		}
	}
	dao.addProjectTeam(project.getId(), 1, user.getBlackstarUserId());
  }
  
  @Override
  public void updateProject(ProjectVO project, User user){
	String [] entries = project.getStrEntries().split("~");
	String [] items, values;
	Integer entryId;
	project.setModifiedByUsr(user.getBlackstarUserId());
	dao.upsertProject(project);
	dao.cleanProjectDependencies(project.getId());
	for(String entry : entries){
		values = entry.split("\\|");
		entryId = dao.getNewEntryId();
		dao.upsertProjectEntry(entryId, project.getId(), Integer.valueOf(values[0])
				, values[1], Float.valueOf(values[2]), Float.valueOf(values[3])
				                                                  , values[4]);
		items = values[6].split("\\^");
		for(String item : items){
			values = item.split("°");
			dao.upsertEntryItem(-1, entryId, Integer.valueOf(values[0]), values[1]
			   , values[2], Integer.valueOf(values[3]), Float.valueOf(values[4])
			   , Float.valueOf(values[5]), Float.valueOf(values[6]), values[7]);
		}
	}
  }
  
  @Override
  public void updateEntries(ProjectVO project){
	String [] entries = project.getStrEntries().split("~");
	String [] items, values;
	Integer entryId, itemId;
	for(String entry : entries){
		values = entry.split("\\|");
		entryId = Integer.valueOf(values[5]);
		dao.upsertProjectEntry(entryId, project.getId(), 0, "", 0F, 0F, values[4]);
		items = values[6].split("\\^");
		for(String item : items){
			values = item.split("°");
			itemId = Integer.valueOf(values[8]);
			dao.upsertEntryItem(itemId, entryId, 0, "", "", 0, 0F, 0F, 0F, values[7]);
		}
	}
	  
  }
  
  @Override
  public List<DeliverableVO> getDeliverables(Integer projectId){
	 return dao.getDeliverables(projectId);
  }
  
  @Override
  public void advanceStatus(ProjectVO project) throws Exception{
	  
	switch(project.getStatusId()){
	  case 1: gotoByAuthStatus(project);
	          break;
	  case 2: gotoAuthStatus(project);
              break;
	  case 3: gotoPricePropStatus(project);
              break;     
	}
  }
  
  private void gotoByAuthStatus(ProjectVO project){
	StringBuilder message = new StringBuilder();
	
	IEmailService mail = EmailServiceFactory.getEmailService();
	dao.advanceStatus(project.getId());
	User to = dao.getSalesManger();
	message.append(String.format("Proyecto pendiente de Autorización: ", project.getProjectNumber()));
	message.append(String.format("\r\n\r\n Estatus: %s", project.getStatusDescription()));
	message.append(String.format("\r\n\r\n Cliente: %s", project.getClientDescription()));
	message.append(String.format("\r\n\r\n"));
	mail.sendEmail("portal-servicios@gposac.com.mx", to.getUserEmail(), "Proyecto pendiente de Autorización " 
	                                                       + project.getProjectNumber(), message.toString());
  }
  
  private void gotoAuthStatus(ProjectVO project){
	StringBuilder message = new StringBuilder();
	User to = null;
	IEmailService mail = EmailServiceFactory.getEmailService();
	dao.advanceStatus(project.getId());
	to = dao.getResponsable(project.getId());
	message.append(String.format("Proyecto Autorizado: ", project.getProjectNumber()));
	message.append(String.format("\r\n\r\n Estatus: %s", project.getStatusDescription()));
	message.append(String.format("\r\n\r\n Cliente: %s", project.getClientDescription()));
	message.append(String.format("\r\n\r\n"));
	mail.sendEmail("portal-servicios@gposac.com.mx", to.getUserEmail(), "Proyecto Autorizado " 
	                                       + project.getProjectNumber(), message.toString());
  }
  
  private void gotoPricePropStatus(ProjectVO project) throws Exception{
	byte[] report = pdfService.getPriceProposalReport(project);
	PriceProposalVO priceProposal = priceProposalService
			           .getProposalFromProject(project);
	priceProposalService.insertPriceProposal(priceProposal);
	ClientVO client = cDAO.getClientById(project.getClientId());
	dao.advanceStatus(project.getId());
	saveReport(project, report);
	gmService.sendEmail(client.getEmail(), "Cotización "  + priceProposal
			 .getPriceProposalNumber(), "Cotización", "Cotizacion.pdf", report);
  }
  
  
  private void saveReport(ProjectVO project, byte[] report) throws Exception {
	String parentId = gdService.getProposalFolderId(project.getProjectNumber());
	gdService.insertFileFromStream("application/pdf", project.getProjectNumber() 
			                                        + ".pdf", parentId, report);
  }

}
