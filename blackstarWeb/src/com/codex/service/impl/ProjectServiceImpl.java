package com.codex.service.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
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
import com.codex.model.dto.DeliverableTraceDTO;
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
import com.codex.vo.ProjectEntryItemVO;
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
  public void addDeliverableTrace(DeliverableTraceDTO deliverable){
	  
	try {
		deliverable.setCreated(Globals.getLocalTime());
	} catch (ParseException e) {
		deliverable.setCreated(new Date());
	}
	dao.addDeliverableTrace(deliverable);
	
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
  public void insertProject(ProjectVO project, User user) throws Exception{
	  upsertProject(project, user, false);
  }
  
  @Override
  public void updateProject(ProjectVO project, User user) throws Exception{
	  upsertProject(project, user, true);
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
	  case 4:
		  gotoRequestedStatus(project);
		  break;
	  case 5:
		  gotoDeliveredStatus(project);
		  break;
	  case 6: 
		  gotoClosedStatus(project);
		  break;
	  }
  }
  
  @Override
  public void fallbackStatus(ProjectVO project) throws Exception{

	  gotoNewStatus(project);
  }
  
  @Override
  public void cancelProject(ProjectVO project) throws Exception {
	  dao.advanceStatus(project.getId(), 8);
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
  
  private void upsertProject(ProjectVO project, User user, Boolean isUpdate) throws Exception{
	  String [] entries = project.getStrEntries().replaceAll("$", "").replaceAll(",", "").split("~");
	  String [] items, values;
	  Integer entryId = 0;

	  // Project
	  if(isUpdate){
		  project.setModifiedByUsr(user.getBlackstarUserId());
	  }
	  else{
		  project.setCreatedByUsr(user.getBlackstarUserId());
	  }
	  
	  dao.upsertProject(project);

	  // Entries
	  List<ProjectEntryVO> projEntries = new ArrayList<ProjectEntryVO>();

	  for(String entry : entries){
		  ProjectEntryVO thisEntry = new ProjectEntryVO();

		  thisEntry.setId(entryId);
		  thisEntry.setProjectId(project.getId());

		  values = entry.split("\\|");

		  try{
			  thisEntry.setEntryTypeId(Integer.valueOf(values[0]));
		  }
		  catch(Exception e){
			  throw new Exception("Tipo de partida invalido: " + values[0]);
		  }

		  thisEntry.setDescription(values[1]);

		  try{
			  thisEntry.setQty(Integer.valueOf(values[2]));
		  }
		  catch(Exception e){
			  throw new Exception("Valor invalido para cantidad de partida: " + values[2]);
		  }

		  try{
			  thisEntry.setUnitPrice(Float.valueOf(values[3]));
		  }
		  catch(Exception e){
			  throw new Exception("Valor invalido para precio unitario de partida: " + values[3]);
		  }

		  try{
			  thisEntry.setDiscount(Float.valueOf(values[4]));
		  }
		  catch(Exception e){
			  throw new Exception("Valor invalido para valor de descuento de partida: " + values[4]);
		  }

		  try{
			  thisEntry.setTotalPrice(Double.valueOf(values[5]));
		  }
		  catch(Exception e){
			  throw new Exception("Valor invalido para precio total de partida: " + values[5]);
		  }

		  thisEntry.setComments(values[6]);

		  //Items
		  List<ProjectEntryItemVO> entryItems = new ArrayList<ProjectEntryItemVO>();

		  items = values[8].split("\\^");
		  for(String item : items){
			  ProjectEntryItemVO thisItem = new ProjectEntryItemVO();

			  values = item.split("::");

			  thisItem.setId(-1);
			  thisItem.setEntryId(entryId);

			  try{
				  thisItem.setItemTypeId(Integer.valueOf(values[0]));
			  }
			  catch(Exception e){
				  throw new Exception("Valor invalido para tipo de item: " + values[0]);
			  }

			  thisItem.setReference(values[1]);

			  thisItem.setDescription(values[2]);

			  try {
				  thisItem.setQuantity(Float.valueOf(values[3]));
			  } catch (Exception e) {
				  throw new Exception("Valor invalido para cantidad de item: " + values[3]);
			  }

			  try {
				  thisItem.setPriceByUnit(Float.valueOf(values[4]));
			  } catch (Exception e) {
				  throw new Exception("Valor invalido para precio unitario de item: " + values[4]);
			  }


			  try {
				  thisItem.setDiscount(Float.valueOf(values[5]));
			  } catch (Exception e) {
				  throw new Exception("Valor invalido para descuento de item: " + values[5]);
			  }

			  try {
				  thisItem.setTotalPrice(Float.valueOf(values[6]));
			  } catch (Exception e) {
				  throw new Exception("Valor invalido para precio total de item: " + values[6]);
			  }

			  thisItem.setComments(values[7]);

			  entryItems.add(thisItem);
		  }

		  thisEntry.setItems(entryItems);

		  projEntries.add(thisEntry);

	  }

	  project.setEntries(projEntries);

	  if(isUpdate){
		  dao.cleanProjectDependencies(project.getId());  
	  }
	  
	  for(ProjectEntryVO entry : projEntries){

		  entryId = dao.upsertProjectEntry(0, project.getId(), entry.getEntryTypeId(), entry.getDescription() 
				  , entry.getQty(), entry.getUnitPrice(), entry.getDiscount(), entry.getTotalPrice().floatValue()
				  , entry.getComments());

		  for(ProjectEntryItemVO item : entry.getItems()){

			  dao.upsertEntryItem(-1, entryId, item.getItemTypeId()
					  , item.getReference(), item.getDescription(), item.getQuantity()
					  , item.getPriceByUnit(), item.getDiscount(), item.getTotalPrice()
					  , item.getComments());
		  }
	  }
	  
	  if(!isUpdate){
		  dao.addProjectTeam(project.getId(), 1, user.getBlackstarUserId());
	  }
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

  private void gotoDeliveredStatus(ProjectVO project){
	IEmailService mail = EmailServiceFactory.getEmailService();
	
	// STATUS ADVANCE
	dao.advanceStatus(project.getId(), project.getStatusId() + 1);

	String link = Globals.GOOGLE_CONTEXT_URL + "/codex/project/edit.do?projectId=" + project.getId();
	String subject = "Proyecto " + project.getProjectNumber() + " surtido";
	StringBuilder bodySb = new StringBuilder();
	String to = project.getCstEmail();

	bodySb.append("<img src='" + Globals.GPOSAC_LOGO_DEFAULT_URL + "'>");
	bodySb.append("<div style='font-family:sans-serif;margin-left:50px;'>");
	bodySb.append("<h3>Proyecto " + project.getProjectNumber() + " Surtido</h3>");
	bodySb.append("<p>Para su informacion:</p>");
	bodySb.append("<p>El proyecto " + project.getProjectNumber() + " ha sido marcado como Surtido.</p>");
	bodySb.append("<p>Fecha: " + Globals.getLocalTimeString() + "</p>");
	bodySb.append("<p>Cliente: " + project.getClientDescription() + "</p>");
	bodySb.append("<p>En el siguiente Link podra revisar los detalles del proyecto y dar el seguimiento correspondiente.</p>");
	bodySb.append("<a href='" + link + "'>" + project.getProjectNumber() + "</a>");
	bodySb.append("</div>");
	bodySb.append("<hr>");
	bodySb.append("<small>Favor de no responder a este email.</small>");

	mail.sendEmail("portal-servicios@gposac.com.mx", to.toString(), subject, bodySb.toString());
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
  
  private void gotoRequestedStatus(ProjectVO project){
	  IEmailService mail = EmailServiceFactory.getEmailService();
	  
	  // STATUS ADVANCE
	  dao.advanceStatus(project.getId(), project.getStatusId() + 1);

	  String link = Globals.GOOGLE_CONTEXT_URL + "/codex/project/edit.do?projectId=" + project.getId();
	  String subject = "Pedido para Proyecto " + project.getProjectNumber();
	  StringBuilder bodySb = new StringBuilder();
	  String to = project.getCstEmail() + "," + getOfficeEmail(project.getOfficeId());

	  bodySb.append("<img src='" + Globals.GPOSAC_LOGO_DEFAULT_URL + "'>");
	  bodySb.append("<div style='font-family:sans-serif;margin-left:50px;'>");
	  bodySb.append("<h3>Pedido para Proyecto " + project.getProjectNumber() + "</h3>");
	  bodySb.append("<p>Para su informacion:</p>");
	  bodySb.append("<p>Favor de llevar a cabo el pedido del proyecto " + project.getProjectNumber() + "</p>");
	  bodySb.append("<p>Fecha: " + Globals.getLocalTimeString() + "</p>");
	  bodySb.append("<p>Cliente: " + project.getClientDescription() + "</p>");
	  bodySb.append("<p>En el siguiente Link podra revisar los detalles del proyecto.</p>");
	  bodySb.append("<a href='" + link + "'>" + project.getProjectNumber() + "</a>");
	  bodySb.append("</div>");
	  bodySb.append("<hr>");
	  bodySb.append("<small>Favor de no responder a este email. En caso de duda pongase en contacto con el consultor</small>");

	  mail.sendEmail("portal-servicios@gposac.com.mx", to.toString(), subject, bodySb.toString());
  }
  
  private void gotoClosedStatus(ProjectVO project){
	  dao.advanceStatus(project.getId(), project.getStatusId() + 1);
  }
  
  private String saveReport(ProjectVO project, byte[] report) throws Exception {
	String parentId = gdService.getProposalFolderId(project.getProjectNumber());
	String documentId = gdService.insertFileFromStream("application/pdf", project.getProjectNumber() 
			                                        + ".pdf", parentId, report);
	
	return documentId;
  }
  
  private String getOfficeEmail(String officeId){
	  
	  // TODO: cambiar por acceso a BD
	  switch(officeId){
	  case "Q":
		  return "queretaro@gposac.com.mx";
	  case "G":
		  return "guadalajara@gposac.com.mx";
	  case "M":
		  return "mexico@gposac.com.mx";
	  default: return "";
	  }
  }
}
