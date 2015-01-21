package com.codex.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.common.Globals;
import com.blackstar.db.dao.interfaces.UserDAO;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.blackstar.services.AbstractService;
import com.blackstar.services.EmailServiceFactory;
import com.codex.model.dto.CostCenterDTO;
import com.codex.model.dto.CstDTO;
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
  public void addFollow(Integer projectId, String userId, String assignedUserId
		                                                      , String comment) {
	dao.addFollow(projectId, userId, assignedUserId, comment);
  }

  @Override
  public void addProjectTeam(Integer projectId, Integer roleId, Integer userId) {
	dao.addProjectTeam(projectId, roleId, userId);
  }
  
  @Override
  public void sendNotification(String fromUser, String toUser 
		                      , Integer projectId, String detail) {
	List<ProjectVO> projects = dao.getProjectDetail(projectId);
	ProjectVO project = null;
	StringBuilder message;

	if(projects.size() > 0){
	  project = projects.get(0);
	  message = new StringBuilder();
	  
	  System.out.println("sendNot=> From(" + fromUser + "), to(" + toUser + ")");

	  IEmailService mail = EmailServiceFactory.getEmailService();
	  message.append(String.format("El proyecto %s le ha sido asignada para dar seguimiento. Por favor revise a continuación los detalles: ", project.getProjectNumber()));
	  message.append(String.format("\r\n\r\n Estatus: %s", project.getStatusDescription()));
	  message.append(String.format("\r\n\r\n Cliente: %s", project.getClientDescription()));
	  message.append(String.format("\r\n\r\n"));
	  message.append(String.format("\r\n\r\n Mensaje: %s", detail));
	 //  mail.sendEmail(fromUser, toUser, "Asignación de Proyecto " + project.getProjectNumber(), message.toString());
	  
	  mail.sendEmail(Globals.GPOSAC_DEFAULT_SENDER, toUser, "Asignación de Proyecto " + project.getProjectNumber(), message.toString());
	}
  }
  

	@Override
	public ProjectVO getProjectDetail(Integer projectId, CstDTO cst) {
		ProjectVO p = getProjectDetail(projectId);

		if(cst != null){
			 p.setCstAutoAuth(cst.getAutoAuthProjects());
			 p.setCstEmail(cst.getEmail());
			 p.setCstMobile(cst.getMobile());
			 p.setCstName(cst.getName());
			 p.setCstPhone(cst.getPhone());
			 p.setCstPhoneExt(cst.getPhoneExt());
		}
		 
		 return p;
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
  public Integer getNewProjectId(String type){
	return dao.getNewProjectId(type);
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
	return types.toString();
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
	Integer entryId = 0;
	project.setCreatedByUsr(user.getBlackstarUserId());
	dao.upsertProject(project);
	for(String entry : entries){
		values = entry.split("\\|");

		entryId = dao.upsertProjectEntry(0, project.getId(), Integer.valueOf(values[0]),
						values[1], Integer.valueOf(values[2]), Float.valueOf(values[3]),
						Float.valueOf(values[4]),Float.valueOf(values[5]), values[6]);
		items = values[8].split("\\^");
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
	Integer entryId = 0;
	project.setModifiedByUsr(user.getBlackstarUserId());
	dao.upsertProject(project);
	dao.cleanProjectDependencies(project.getId());
	for(String entry : entries){
		values = entry.split("\\|");

		entryId = dao.upsertProjectEntry(0, project.getId(), Integer.valueOf(values[0]),
				values[1], Integer.valueOf(values[2]), Float.valueOf(values[3]),
				Float.valueOf(values[4]),Float.valueOf(values[5]), values[6]);
		items = values[8].split("\\^");
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
		entryId = Integer.valueOf(values[7]);
		dao.upsertProjectEntry(entryId, project.getId(), 0, "", 0, 0F, 0F, 0F, values[6]);
		items = values[8].split("\\^");
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
	  case 1: 
		  if(project.getCstAutoAuth() >= project.getTotalProjectNumber()){
			  project.setStatusId(project.getStatusId() + 1);
			  gotoAuthStatus(project);  
		  }
		  else{
			  gotoByAuthStatus(project, false);
		  }
		  
		  break;	
	  case 2: 
		  gotoAuthStatus(project);
		  break;
	  case 3: 
		  gotoPricePropStatus(project);
		  break;     
	  }
  }
  
  @Override
  public void fallbackStatus(ProjectVO project) throws Exception{

	  gotoNewStatus(project);
  }
  
  private void gotoNewStatus(ProjectVO project){
	  // STATUS ADVANCE
	  dao.advanceStatus(project.getId(), 1);
  }
  
  private void gotoByAuthStatus(ProjectVO project, boolean autoAuth){
	  IEmailService mail = EmailServiceFactory.getEmailService();

	  // STATUS ADVANCE
	  dao.advanceStatus(project.getId(), project.getStatusId() + 1);

	  if(!autoAuth){
		  StringBuilder to = new StringBuilder();

		  List<User> mgrs = dao.getSalesManger();

		  for(User mgr : mgrs){
			  if(to.length() > 0){
				  to.append(",");  
			  }
			  else{
				  to.append(mgr.getUserEmail());
			  }
		  }

		  String link = Globals.GOOGLE_CONTEXT_URL + "/codex/project/edit.do?projectId=" + project.getId();
		  String subject = "Solicitud de aprobacion para proyecto " + project.getProjectNumber();
		  StringBuilder bodySb = new StringBuilder();

		  bodySb.append("<img src='" + Globals.GPOSAC_LOGO_DEFAULT_URL + "'>");
		  bodySb.append("<div style='font-family:sans-serif;margin-left:50px;'>");
		  bodySb.append("<h3>Solicitud de aprobacion para proyecto " + project.getProjectNumber() + "</h3>");
		  bodySb.append("<p>Para su informacion:</p>");
		  bodySb.append("<p>Se ha solicitado la autorizacion del proyecto " + project.getProjectNumber() + "</p>");
		  bodySb.append("<br>Registrado por: " + project.getCstName());
		  bodySb.append("<br>Fecha: " + Globals.getLocalTimeString());
		  bodySb.append("<br>");
		  bodySb.append("<p>En el siguiente Link podra revisar los detalles. Por favor revise la informacion para dar el seguimiento correspondiente</p>");
		  bodySb.append(link);
		  bodySb.append("</div>");
		  bodySb.append("<hr>");
		  bodySb.append("<small>Favor de no responder a este email. En caso de duda pongase en contacto con la persona que lo solicito</small>");

		  mail.sendEmail("portal-servicios@gposac.com.mx", to.toString(), subject, bodySb.toString());
	  }
	  else{
		  // Auto-autorizado
	  }
  }
  
  private void gotoAuthStatus(ProjectVO project){
	  IEmailService mail = EmailServiceFactory.getEmailService();

	  // STATUS ADVANCE
	  dao.advanceStatus(project.getId(), project.getStatusId() + 1);

	  String link = Globals.GOOGLE_CONTEXT_URL + "/codex/project/edit.do?projectId=" + project.getId();
	  String subject = "Proyecto " + project.getProjectNumber() + " autorizado";
	  StringBuilder bodySb = new StringBuilder();
	  String to = project.getCstEmail();

	  bodySb.append("<img src='" + Globals.GPOSAC_LOGO_DEFAULT_URL + "'>");
	  bodySb.append("<div style='font-family:sans-serif;margin-left:50px;'>");
	  bodySb.append("<h3>Proyecto " + project.getProjectNumber() + " autorizado</h3>");
	  bodySb.append("<p>Para su informacion:</p>");
	  bodySb.append("<p>La solicitud de autorizacion del proyecto " + project.getProjectNumber() + " ha sido aprobada</p>");
	  bodySb.append("<br>Fecha: " + Globals.getLocalTimeString());
	  bodySb.append("<br>");
	  bodySb.append("<p>En el siguiente Link podra revisar los detalles.</p>");
	  bodySb.append(link);
	  bodySb.append("</div>");
	  bodySb.append("<hr>");
	  bodySb.append("<small>Favor de no responder a este email. En caso de duda pongase en contacto con la persona que autorizo</small>");

	  mail.sendEmail("portal-servicios@gposac.com.mx", to.toString(), subject, bodySb.toString());
  }
    
  private void gotoPricePropStatus(ProjectVO project) throws Exception{
	  IEmailService mail = EmailServiceFactory.getEmailService();
	  PriceProposalVO priceProposal = priceProposalService
			  .getProposalFromProject(project);
	  
	  project.setPriceProposalNumber(priceProposal.getPriceProposalNumber());
	  byte[] report = pdfService.getPriceProposalReport(project);
	  
	  String documentId = saveReport(project, report);
	  if(documentId == null || documentId.equals("")){
		  throw new Exception("Error de comunicacion con Google Drive, no fue posible guardar el documento " + priceProposal.getPriceProposalNumber());
	  }
	  
	  priceProposal.setDocumentId(documentId);
	  priceProposalService.insertPriceProposal(priceProposal);

	  // STATUS ADVANCE
	  dao.advanceStatus(project.getId(), project.getStatusId() + 1);

	  String to = project.getCstEmail();
	  gmService.sendEmail(to, "Cotización "  + priceProposal.getPriceProposalNumber(), "Cotización", "Cotizacion.pdf", report);

  }
  
  
  private String saveReport(ProjectVO project, byte[] report) throws Exception {
	String parentId = gdService.getProposalFolderId(project.getProjectNumber());
	String documentId = gdService.insertFileFromStream("application/pdf", project.getProjectNumber() 
			                                        + ".pdf", parentId, report);
	
	return documentId;
  }

  @Override
  public List<CostCenterDTO> getCostCenterList() {
	 return dao.getCostCenterList();
  }

@Override
public String getCSTOffice(String cst) {
	return dao.getCSTOffice(cst);
}

@Override
public List<String> getIncotermList() {
	List<String> incs = new ArrayList<String>();
	incs.add("DDP");
	incs.add("FOB");
	
	return incs;
}

@Override
public String getPriceList() {
	return dao.getPriceList().toString();
}

@Override
public String getPriceProposalList(Integer projectId) {
	return dao.getPriceProposalList(projectId).toString();
}


}
