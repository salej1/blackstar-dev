package com.bloom.services;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.blackstar.common.Globals;
import com.blackstar.db.dao.interfaces.UserDAO;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.blackstar.services.AbstractService;
import com.blackstar.services.EmailServiceFactory;
import com.blackstar.web.controller.AddFollowUpController;
import com.blackstar.web.controller.AddFollowUpController.AssignType;
import com.bloom.common.bean.CatalogoBean;
import com.bloom.common.bean.DeliverableTraceBean;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.bean.TicketTeamBean;
import com.bloom.common.exception.DAOException;
import com.bloom.common.exception.ServiceException;
import com.bloom.common.utils.DataTypeUtil;
import com.bloom.db.dao.CatalogInternalTicketsDao;
import com.bloom.db.dao.InternalTicketsDao;
import com.bloom.model.dto.AdvisedUserDTO;
import com.bloom.model.dto.DeliverableFileDTO;
import com.bloom.model.dto.DeliverableTypeDTO;
import com.bloom.model.dto.PendingAppointmentsDTO;
import com.bloom.model.dto.PendingSurveysDTO;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;

public class InternalTicketsServiceImpl extends AbstractService 
                                        implements InternalTicketsService {

  private InternalTicketsDao internalTicketsDao = null;
  private UserDAO uDAO = null;
  
  public void setInternalTicketsDao(InternalTicketsDao internalTicketsDao) {
	this.internalTicketsDao = internalTicketsDao;
  }
  
  public void setuDAO(UserDAO uDAO) {
	this.uDAO = uDAO;
  }
  
  private CatalogInternalTicketsDao catalogInternalTicketsDao;


    @Override
    public List<InternalTicketBean> getPendingTickets(Long userId) throws ServiceException {
    	return getInternalTicketsDao().getPendingTickets(userId);
    }
    
    
    @Override
    public List<InternalTicketBean> getTickets(Long userId) throws ServiceException {
    	return getInternalTicketsDao().getTickets(userId);
    }

    @Override
    public List<InternalTicketBean> getHistoricalTickets(String startCreationDateTicket, String endCreationDateTicket, Integer idStatusTicket, Integer showHidden, String user) throws ServiceException {
    	return getInternalTicketsDao().getHistoricalTickets(startCreationDateTicket,endCreationDateTicket,idStatusTicket, showHidden, user);
    }
    
    @Override
    public String generarTicketNumber() throws ServiceException {
    	return getInternalTicketsDao().generarTicketNumber();
    }

    @Override
    public void validarNuevoTicket(InternalTicketBean ticket) throws ServiceException {
    	
    	 if (ticket.getDescription().isEmpty()) {
             throw new ServiceException("Describa el motivo del ticket, por favor.");
         }
    	     	 
    	 Date fechaActual = new Date();
    	 
    	 if(ticket.getDueDate().getTime()<fechaActual.getTime()){
    		 throw new ServiceException("La fecha limite debe ser mayor a la fecha actual.");
    	 }
    	
    }

    

    @Override
    public void registrarNuevoTicket(InternalTicketBean ticket) throws ServiceException {
    	ticket.setStatusId(1);//ticket nuevo.
    	
    	List<AdvisedUserDTO> teamDto;
    	List<CatalogoBean<Integer>> doctos;
    	
    	List<TicketTeamBean> members= new ArrayList<TicketTeamBean>();
    	
    	Long idTicket= getInternalTicketsDao().registrarNuevoTicket(ticket);

    	if (idTicket > 0) {

    		//El creador del ticket entra con rol colaborador (2)
    		members.add(
    				new TicketTeamBean(idTicket, 2L, ticket.getCreatedUserId(),ticket.getCreatedUserEmail(),ticket.getCreatedUserName(), "creator"));

    		//obtener coordinadores
    		//miebrosDtos=catalogInternalTicketsDao.getEmployeesByGroup("sysCoordinador");

    		//obtenemos la lista de usuarios de enterados para bloomTicketTeam
    		teamDto = catalogInternalTicketsDao.getAdviceUsers(ticket.getApplicantAreaId(), ticket.getServiceTypeId());

    		for(AdvisedUserDTO teamM : teamDto){

    			members.add(new TicketTeamBean(
    					idTicket,
    					(long)teamM.getWorkerRoleTypeId(), 
    					(long)teamM.getId(),
    					teamM.getEmail(),
    					teamM.getName(),
    					teamM.getUserGroup()));

    		}


    		for(TicketTeamBean member:members){
    			//registrar bloomTicketTeam  Responsables
    			getInternalTicketsDao().addTicketTeam(idTicket.intValue(), member.getWorkerRoleId().intValue(), member.getEmail(), member.getUserGroup());
    		}

    		//registrar bloomDeliverableTrace. Documentos
    		doctos=catalogInternalTicketsDao.consultarDocumentosPorServicio(ticket.getServiceTypeId());
    		DeliverableTraceBean document;
    		for(CatalogoBean<Integer> doc:doctos){

    			document = new DeliverableTraceBean(idTicket,(long)doc.getId(),0,new Date());

    			getInternalTicketsDao().registrarDocumentTrace(document);
    		}


    		//Funcionalidad para el envio de correo a los incolucrados:
    		//Creador del ticket y usuarios coordiandores.
    		StringBuilder emailList = new StringBuilder();
    		for(TicketTeamBean member:members){
    			//enviar correos a los involucrados.
    			if(member.getWorkerRoleId() == 1){
    				//AddFollowUpController.AssignBloomTicket(idTicket.intValue(), miembro.getEmail(), ticket.getCreatedUserEmail());
    			}
    			else{
    				if(emailList.length() == 0){
    					emailList.append(member.getEmail());
    				}
    				else{
    					emailList.append("," + member.getEmail());
    				}
    			}
    		}
    		// enviando el email
    		AddFollowUpController.NotifyBloomTicket(idTicket.intValue(), emailList.toString(), ticket.getCreatedUserEmail(), ticket.getDescription());
    	}
    }
   
 
 public InternalTicketsDao getInternalTicketsDao() {
		return internalTicketsDao;
	}

    
 public TicketDetailDTO getTicketDetail(Integer ticketId){
	 List<TicketDetailDTO> details = internalTicketsDao.getTicketDetail(ticketId);
		if(details.size() > 0){
			TicketDetailDTO retVal = details.get(0);
						
			return retVal;
		}
		return null;
 }
  public TicketDetailDTO getTicketDetail(Integer ticketId, String user){
	List<TicketDetailDTO> details = internalTicketsDao.getTicketDetail(ticketId);
	
	if(details.size() > 0){
		TicketDetailDTO detail = details.get(0);
		
		detail.setUserCanClose(detail.getCreatedByUsr().equals(user));
		detail.setUserCanAssign(internalTicketsDao.userCanAssign(ticketId, user) > 0);
		if(detail.getResponseDate() != null && detail.getDueDate() != null){
			detail.setResolvedOnTime(detail.getDueDate().compareTo(detail.getResponseDate()));
		}
		
		
		return detail;
	}
	return null;
  }
  
  public List<TicketTeamDTO> getTicketTeam(Integer ticketId){
	return internalTicketsDao.getTicketTeam(ticketId);
  }
  
  public void addFollowUp(Integer ticketId, String asignee, String sender, String comment){
	  
	  internalTicketsDao.addFollowUp(ticketId, asignee, sender, comment);

	  if(asignee != null && asignee != null && !asignee.equals("")){
		  addTicketTeam(ticketId, 2, asignee, "followUp");
		  AddFollowUpController.AssignBloomTicket(ticketId, asignee, sender, comment);
	  }
  }
  
  public void addTicketTeam(Integer ticketId, Integer roleId, String userId, String userGroup){
	internalTicketsDao.addTicketTeam(ticketId, roleId, userId, userGroup);
  }
  
  public List<Followup> getFollowUps(Integer ticketId){
	return internalTicketsDao.getFollowUps(ticketId);
  }
  
  public List<DeliverableTypeDTO> getDeliverableTypes(Integer ticketTypeId){
	 return internalTicketsDao.getDeliverableTypes(ticketTypeId);
  }
  
  public void addDeliverableTrace(Integer ticketId, Integer deliverableTypeId, String docId, String name){
	internalTicketsDao.addDeliverableTrace(ticketId, deliverableTypeId, docId, name);
  }
  
  public User getAsigneed(Integer ticketId){
	List<User> users = internalTicketsDao.getAsigneedUser(ticketId);
	User asigneed = null;
	if(users.size() > 0){
	  asigneed = users.get(0);
	}
	return asigneed;
  }
  
  public User getResponseUser(Integer ticketId){
	List<User> users = internalTicketsDao.getResponseUser(ticketId);
	User toResponse = null;
	if(users.size() > 0){
	  toResponse = users.get(0);
	}
	return toResponse;
  }
  
  public void sendNotification(String from, String to , Integer ticketId, String detail, String fromName){
	  if(to != null && !to.isEmpty()){
		StringBuilder message = new StringBuilder();

		TicketDetailDTO ticket = getTicketDetail(ticketId);
		IEmailService mail = EmailServiceFactory.getEmailService();
		message.append(String.format("La requisicion %s le ha sido asignada para dar seguimiento. Por favor revise a continuación los detalles: ", ticket.getTicketNumber()));
		message.append(String.format("\r\n\r\n Solicitante: %s", ticket.getApplicantUserName() + " - " + ticket.getApplicantAreaName()));
		message.append(String.format("\r\n\r\n Oficina: %s", ticket.getApplicantUserName() + " - " + ticket.getOfficeName()));
		message.append(String.format("\r\n\r\n Tipo de Servicio: %s", ticket.getServiceTypeName()));
		message.append(String.format("\r\n\r\n Proyecto: %s", ticket.getProject()));
		message.append(String.format("\r\n\r\n Descripción: %s", ticket.getDescription()));
		message.append(String.format("\r\n\r\n"));
		message.append(String.format("\r\n\r\n Usuario que asignó: %s", fromName));
		message.append(String.format("\r\n\r\n Mensaje: %s", detail));
		mail.sendEmail(Globals.GPOSAC_DEFAULT_SENDER, to, "Asignacion de Requisicion " + ticket.getTicketNumber(), message.toString());
	  }
  }

  public void closeTicket(Integer ticketId, Integer userId, Integer statusId, String sender){
	  if(statusId == 5){
		  List<TicketDetailDTO> ticketDetail = internalTicketsDao.getTicketDetail(ticketId);
		  String to = null;
		  StringBuilder message = null;
		  TicketDetailDTO ticket = null;
		  IEmailService mail = EmailServiceFactory.getEmailService();
		  String timeStamp = Globals.getLocalTimeString();

		  if(ticketDetail.size() > 0){
			  ticket = ticketDetail.get(0);
			  to = ticket.getCreatedByUsr();
			  if(to != null){

				  String subject = "Requisición " + ticket.getTicketNumber() + " atendida";
				  StringBuilder bodySb = new StringBuilder();
				  String ticketLink = String.format("<a href='%s/bloom/ticketDetail/show.do?ticketId=%s'>%s</a>", Globals.GOOGLE_CONTEXT_URL, ticket.get_id(), ticket.getTicketNumber());
				  String surveyLink = String.format("<a href='%s/bloom/survey/create.do?ticketNumber=%s'>Aplicar encuesta</a>", Globals.GOOGLE_CONTEXT_URL, ticket.getTicketNumber());

				  bodySb.append("<img src='" + Globals.GPOSAC_LOGO_DEFAULT_URL + "'>");
				  bodySb.append("<div style='font-family:sans-serif;margin-left:50px;'>");
				  bodySb.append("<h3 >Requisición atendida</h3>");
				  bodySb.append("<p>La requisición  ha sido marcada como resuelta</p>");
				  bodySb.append("<br>Resuelto por: " + sender);
				  bodySb.append("<br>Fecha: " + timeStamp);
				  bodySb.append("<br>");
				  bodySb.append("<p>Haga click en el siguiente link para revisar la respuesta y cerrar la requisición</p>");
				  bodySb.append(ticketLink);
				  bodySb.append("<p>Por favor resoponda la encuesta de servicio de la requisición usando el siguiente link</p>");
				  bodySb.append(surveyLink);
				  bodySb.append("</div>");
				  bodySb.append("<hr>");
				  bodySb.append("<small>Favor de no responder a este email. En caso de duda póngase en contacto con la persona que le asignó la tarea</small>");

				  mail.sendEmail(Globals.GPOSAC_DEFAULT_SENDER, to, subject, bodySb.toString());
			  }
		  }
	  }

	  internalTicketsDao.closeTicket(ticketId, userId, statusId);
  }

	/**
	 * @return the catalogInternalTicketsDao
	 */
	public CatalogInternalTicketsDao getCatalogInternalTicketsDao() {
		return catalogInternalTicketsDao;
	}


	/**
	 * @param catalogInternalTicketsDao the catalogInternalTicketsDao to set
	 */
	public void setCatalogInternalTicketsDao(
			CatalogInternalTicketsDao catalogInternalTicketsDao) {
		this.catalogInternalTicketsDao = catalogInternalTicketsDao;
	}

	public Integer getTicketId(String ticketNumber){
	  return internalTicketsDao.getTicketId(ticketNumber);
	}
	
	public List<DeliverableFileDTO> getTicketDeliverable(Integer ticketId){
		return internalTicketsDao.getTicketDeliverable(ticketId);
	}

	public void sendPendingAppointments(){
	  List<PendingAppointmentsDTO> pendingAppointments = internalTicketsDao
				                                 .getPendingAppointments();
	  IEmailService mail = EmailServiceFactory.getEmailService();
	  StringBuilder message = new StringBuilder();
	  for(PendingAppointmentsDTO pendingAppointment : pendingAppointments){
		message = new StringBuilder();
		message.append("Ticket Interno : " + pendingAppointment.getTicketNumber())
	           .append("\r\n")
	           .append("Fecha de asignación: " + pendingAppointment.getAssignedDate())
		       .append("\r\n")
		       .append("Fecha límite: " + pendingAppointment.getDueDate())
		       .append("\r\n")
		       .append("Descripción: " + pendingAppointment.getDescription())
		       .append("\r\n");
		mail.sendEmail(Globals.GPOSAC_DEFAULT_SENDER, pendingAppointment.getResponsibleMail(), "Ticket interno por vencer: " 
		                                   + pendingAppointment.getTicketNumber(), message.toString());
	  }
	}
	
	public void sendPendingSurveys(){
	  List<PendingSurveysDTO> pendingSurveys = internalTicketsDao.getPendingSurveys();
	  IEmailService mail = EmailServiceFactory.getEmailService();
	  StringBuilder message = new StringBuilder();
	  for(PendingSurveysDTO pendingSurvey : pendingSurveys){
		message = new StringBuilder();
		message.append("Ticket Interno : " + pendingSurvey.getTicketNumber())
		       .append("\r\n")
		       .append("Fecha de cierre: " + pendingSurvey.getResponseDate())
		       .append("\r\n")
			   .append("Descripción: " + pendingSurvey.getDescription())
			   .append("\r\n");
	    mail.sendEmail(Globals.GPOSAC_DEFAULT_SENDER, pendingSurvey.getEmail(), "Favor de completar al encuesta de servicio"
	    		                                          , message.toString());
    }
  }

}