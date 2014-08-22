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
  String sysMailer = "mesa-de-ayuda@gposac.com.mx";
  
  public void setInternalTicketsDao(InternalTicketsDao internalTicketsDao) {
	this.internalTicketsDao = internalTicketsDao;
  }
  
  public void setuDAO(UserDAO uDAO) {
	this.uDAO = uDAO;
  }
  
  private CatalogInternalTicketsDao catalogInternalTicketsDao;


    @Override
    public List<InternalTicketBean> getPendingTickets(Long userId) throws ServiceException {
    	
        try {
        	return getInternalTicketsDao().getPendingTickets(userId);
            
        } catch (DAOException e) {
            
        	//LOGGER.error(ERROR_CONSULTA_CAT, e);
            
            throw new ServiceException("Error al obtener tickets", e);
        }
    }
    
    
    @Override
    public List<InternalTicketBean> getTickets(Long userId) throws ServiceException {
    	
        try {
        	return getInternalTicketsDao().getTickets(userId);
            
        } catch (DAOException e) {
        	System.out.println("Error => " + e);
        	//LOGGER.error(ERROR_CONSULTA_CAT, e);
            
            throw new ServiceException("Error al obtener tickets", e);
        }
    }

    @Override
    public List<InternalTicketBean> getHistoricalTickets(String startCreationDateTicket, String endCreationDateTicket, Integer idStatusTicket, Integer showHidden) throws ServiceException {
    	
    	//startCreationDateTicket = DataTypeUtil.transformDateFormat(startCreationDateTicket,DataTypeUtil.MIN_TIME);
    	//endCreationDateTicket = DataTypeUtil.transformDateFormat(endCreationDateTicket,DataTypeUtil.MAX_TIME);
    	
        try {
        	return getInternalTicketsDao().getHistoricalTickets(startCreationDateTicket,endCreationDateTicket,idStatusTicket, showHidden);
            
        } catch (DAOException e) {
            
        	//LOGGER.error(ERROR_CONSULTA_CAT, e);
            
            throw new ServiceException("Error al obtener el historico tickets", e);
        }
    }

    

    
    @Override
    public String generarTicketNumber() throws ServiceException {
    	
        try {
        	return getInternalTicketsDao().generarTicketNumber();
            
        } catch (DAOException e) {
            
        	//LOGGER.error(ERROR_CONSULTA_CAT, e);
            
            throw new ServiceException("Error al obtener tickets", e);
        }
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
    	
    	List<TicketTeamBean> miembros= new ArrayList<TicketTeamBean>();
    	
        try {
        	Long idTicket= getInternalTicketsDao().registrarNuevoTicket(ticket);

            if (idTicket > 0) {
                
            	//El creador del ticket entra con rol colaborador (2)
            	miembros.add(
            			new TicketTeamBean(idTicket, 2L, ticket.getCreatedUserId(),ticket.getCreatedUserEmail(),ticket.getCreatedUserName(), "creator"));
            	
            	//obtener coordinadores
            	//miebrosDtos=catalogInternalTicketsDao.getEmployeesByGroup("sysCoordinador");
            	
            	//obtenemos la lista de usuarios de enterados para bloomTicketTeam
            	teamDto = catalogInternalTicketsDao.getAdviceUsers(ticket.getApplicantAreaId(), ticket.getServiceTypeId());
            	
            	for(AdvisedUserDTO teamM : teamDto){

            		miembros.add(new TicketTeamBean(
            				idTicket,
            				(long)teamM.getWorkerRoleTypeId(), 
            				(long)teamM.getId(),
            				teamM.getEmail(),
            				teamM.getName(),
            				teamM.getUserGroup()));
            		
            	}
            	
            	
            	for(TicketTeamBean miembro:miembros){
                	//registrar bloomTicketTeam  Responsables
                	getInternalTicketsDao().registrarMiembroTicket(miembro);
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
            	for(TicketTeamBean miembro:miembros){
            		//enviar correos a los involucrados.
            		if(miembro.getWorkerRoleId() == 1){
            			AddFollowUpController.AssignBloomTicket(idTicket.intValue(), miembro.getEmail(), ticket.getCreatedUserEmail());
            		}
            		else{
            			AddFollowUpController.NotifyBloomTicket(idTicket.intValue(), miembro.getEmail(), ticket.getCreatedUserEmail());
            		}
            	}
            }
        } catch (DAOException ex) {
            throw new ServiceException("No se pudo registrar requisicion ");
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
		
		return detail;
	}
	return null;
  }
  
  public List<TicketTeamDTO> getTicketTeam(Integer ticketId){
	return internalTicketsDao.getTicketTeam(ticketId);
  }
  
  public void addFollowUp(Integer ticketId, String asignee, String sender, String comment){
	internalTicketsDao.addFollowUp(ticketId, asignee, sender, comment);
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
  
  public void addDeliverableTrace(Integer ticketId, Integer deliverableTypeId, String docId){
	internalTicketsDao.addDeliverableTrace(ticketId, deliverableTypeId, docId);
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
		mail.sendEmail(from, to, "Asignación de Ticket Interno " + ticket.getTicketNumber(), message.toString());
	  }
  }

  public void closeTicket(Integer ticketId, Integer userId, Integer statusId){
	  if(statusId == 5){
		List<TicketDetailDTO> ticketDetail = internalTicketsDao.getTicketDetail(ticketId);
		String to = null;
		StringBuilder message = null;
		TicketDetailDTO ticket = null;
		IEmailService mail = null;
		if(ticketDetail.size() > 0){
		  ticket = ticketDetail.get(0);
		  to = ticket.getCreatedByUsr();
		  if(to != null){
			 mail = EmailServiceFactory.getEmailService();
			 message = new StringBuilder();
		     message.append("La requisicion " + ticket.getTicketNumber()  + " ha sido atendida y resuelta.")
		            .append("\r\n\r\n")
		            .append("Requisicion : " + ticket.getTicketNumber())
	                .append("\r\n")
	                .append("Fecha de creación: " + ticket.getCreated())
	                .append("\r\n")
	                .append("Descripción: " + ticket.getDescription());
		     mail.sendEmail(sysMailer, to, "Requisicion atendida: " 
	                                   + ticket.getTicketNumber(), message.toString());
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
		mail.sendEmail(sysMailer, pendingAppointment.getResponsibleMail(), "Ticket interno por vencer: " 
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
	    mail.sendEmail(sysMailer, pendingSurvey.getEmail(), "Favor de completar al encuesta de servicio"
	    		                                          , message.toString());
    }
  }

}