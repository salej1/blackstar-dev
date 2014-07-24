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
            			new TicketTeamBean(idTicket, 2L, ticket.getCreatedUserId(),ticket.getCreatedUserEmail(),ticket.getCreatedUserName()));
            	
            	//obtener coordinadores
            	//miebrosDtos=catalogInternalTicketsDao.getEmployeesByGroup("sysCoordinador");
            	
            	//obtenemos la lista de usuarios de enterados para bloomTicketTeam
            	teamDto = catalogInternalTicketsDao.getAdviceUsers(ticket.getApplicantAreaId(), ticket.getServiceTypeId());
            	
            	for(AdvisedUserDTO teamM : teamDto){

            		miembros.add(new TicketTeamBean(idTicket, (long)teamM.getWorkerRoleTypeId(), 
            				(long)teamM.getId(),
            				teamM.getName(),
            				teamM.getEmail()));
            		
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
            		//enviar correos a los coordinadores involucrados.
            		sendAssignationEmail(ticket,miembro);
            	}
            }
        } catch (DAOException ex) {
            throw new ServiceException("No se pudo registrar requisicion ");
        }

    }
    
    
    private void sendAssignationEmail(InternalTicketBean ticket,TicketTeamBean member){
    	
		// Enviar el email
    	SimpleDateFormat sdf = new SimpleDateFormat(Globals.DATE_FORMAT_PATTERN);
		IEmailService mail = EmailServiceFactory.getEmailService();
		String to = member.getEmail();

		String subject = String.format("Requisición General Interna %s ", ticket.getTicketNumber());

		StringBuilder bodySb = new StringBuilder();

		bodySb.append(String.format("Nueva requisicion: %s.",ticket.getTicketNumber()));

		bodySb.append("\r\n Información adicional:");

		bodySb.append(String.format("\r\n\r\n Usuario Solicitante: %s", ticket.getCreatedUserName()));
		bodySb.append(String.format("\r\n\r\n Numero de ticket interno %s",ticket.getTicketNumber()));
		bodySb.append(String.format("\r\n\r\n Fecha y Hora de recepcion: %s", sdf.format(ticket.getCreated())));
		bodySb.append(String.format("\r\n\r\n Departamento Solicitante: %s", ticket.getPetitionerArea()));
		bodySb.append(String.format("\r\n\r\n Requerimiento: %s", ticket.getDescription()));
		bodySb.append(String.format("\r\n\r\n Fecha Solicitada: %s", sdf.format(ticket.getDueDate())));
		bodySb.append(String.format("\r\n\r\n Proyecto: %s", ticket.getProject()));
		bodySb.append(String.format("\r\n\r\n Oficina: %s", ticket.getOfficeName()));
		bodySb.append(String.format("\r\n\r\n Nota o liga de Anexos: %s", ""));
		bodySb.append(String.format("\r\n\r\n Tiempo de respuesta máximo en días: %s %s", ticket.getServiceTypeDescr(),ticket.getReponseInTime()));


		String who = "portal-servicios@gposac.com.mx";

		mail.sendEmail(who, to, subject, bodySb.toString());
    }
 
 public InternalTicketsDao getInternalTicketsDao() {
		return internalTicketsDao;
	}

    
 public TicketDetailDTO getTicketDetail(Integer ticketId){
	 List<TicketDetailDTO> details = internalTicketsDao.getTicketDetail(ticketId);
		if(details.size() > 0){
			return details.get(0);
		}
		return null;
 }
  public TicketDetailDTO getTicketDetail(Integer ticketId, Integer userId){
	List<TicketDetailDTO> details = internalTicketsDao.getTicketDetail(ticketId);
	if(details.size() > 0){
		List<TicketTeamDTO> team = internalTicketsDao.getTicketTeam(ticketId);
		for(TicketTeamDTO tm : team){
			if(tm.getBlackstarUserId() == userId && tm.getWorkerRoleTypeId() == 1){
				details.get(0).setUserCanClose(true);
				break;
			}
		}

		return details.get(0);
	}
	return null;
  }
  
  public List<TicketTeamDTO> getTicketTeam(Integer ticketId){
	return internalTicketsDao.getTicketTeam(ticketId);
  }
  
  public void addFollow(Integer ticketId, Integer userId, String comment){
	internalTicketsDao.addFollow(ticketId, userId, comment);
  }
  
  public void addTicketTeam(Integer ticketId, Integer roleId, Integer userId){
	internalTicketsDao.addTicketTeam(ticketId, roleId, userId);
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
  
  public void sendNotification(Integer fromUserId, Integer toUserId , Integer ticketId, String detail){
	  if(toUserId > 0){
		StringBuilder message = new StringBuilder();
		User to = uDAO.getUserById(toUserId);
		User from = uDAO.getUserById(toUserId);
		TicketDetailDTO ticket = getTicketDetail(ticketId);
		IEmailService mail = EmailServiceFactory.getEmailService();
		message.append(String.format("La requisicion %s le ha sido asignada para dar seguimiento. Por favor revise a continuación los detalles: ", ticket.getTicketNumber()));
		message.append(String.format("\r\n\r\n Solicitante: %s", ticket.getApplicantUserName() + " - " + ticket.getApplicantAreaName()));
		message.append(String.format("\r\n\r\n Oficina: %s", ticket.getApplicantUserName() + " - " + ticket.getOfficeName()));
		message.append(String.format("\r\n\r\n Tipo de Servicio: %s", ticket.getServiceTypeName()));
		message.append(String.format("\r\n\r\n Proyecto: %s", ticket.getProject()));
		message.append(String.format("\r\n\r\n Descripción: %s", ticket.getDescription()));
		message.append(String.format("\r\n\r\n"));
		message.append(String.format("\r\n\r\n Usuario que asignó: %s", from.getUserName()));
		message.append(String.format("\r\n\r\n Mensaje: %s", detail));
		mail.sendEmail(from.getUserEmail(), to.getUserEmail(), "Asignación de Ticket Interno " + ticket.getTicketNumber(), message.toString());
	  }
  }

  public void closeTicket(Integer ticketId, Integer userId, Integer statusId){
	  if(statusId == 5){
		List<TicketDetailDTO> ticketDetail = internalTicketsDao.getTicketDetail(ticketId);
		User to = null;
		StringBuilder message = null;
		TicketDetailDTO ticket = null;
		IEmailService mail = null;
		if(ticketDetail.size() > 0){
		  ticket = ticketDetail.get(0);
		  to = uDAO.getUserById(ticket.getCreatedByUsr());
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
		     mail.sendEmail(sysMailer, to.getUserEmail(), "Requisicion atendida: " 
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