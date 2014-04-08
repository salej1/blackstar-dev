package com.bloom.services;

import java.util.ArrayList;
import java.util.List;

import com.blackstar.db.dao.interfaces.UserDomainDAO;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.model.dto.EmployeeDTO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.EmailServiceFactory;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.bean.TicketTeamBean;
import com.bloom.common.exception.DAOException;
import com.bloom.common.exception.ServiceException;
import com.bloom.common.utils.DataTypeUtil;
import com.bloom.db.dao.InternalTicketsDao;

public class InternalTicketsServiceImpl extends AbstractService implements
	InternalTicketsService {

	private InternalTicketsDao internalTicketsDao;
	
	private UserDomainDAO userDomainDAO;
	
	
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
            
        	//LOGGER.error(ERROR_CONSULTA_CAT, e);
            
            throw new ServiceException("Error al obtener tickets", e);
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
    public void registrarNuevoTicket(InternalTicketBean ticket) throws ServiceException {

    	ticket.setDeadline(DataTypeUtil.obtenerFecha(ticket.getDeadlineStr(), "MM/dd/yyyy"));
    	ticket.setCreated(DataTypeUtil.obtenerFecha(ticket.getCreatedStr(), "MM/dd/yyyy HH:mm:ss"));
    	ticket.setStatusId(1);//ticket nuevo.
    	
    	List<EmployeeDTO> miebrosDtos;
    	
    	List<TicketTeamBean> miembros= new ArrayList<TicketTeamBean>();
    	
    	
    	
        try {
        	Long idTicket= getInternalTicketsDao().registrarNuevoTicket(ticket);

            if (idTicket > 0) {
                
            	//El creador del ticket entra con rol colaborador (2)
            	miembros.add(new TicketTeamBean(ticket.getId(), 2L, ticket.getCreatedUserId()));
            	
            	//obtener coordinadores
            	miebrosDtos=userDomainDAO.getStaff("sysCoordinador");
            	
            	
            	for(EmployeeDTO coordinador:miebrosDtos){
            		//los cordinadores entran con rol de colaborador.
            		miembros.add(new TicketTeamBean(ticket.getId(), 2L, (long)coordinador.getUserId()));
            		
            		//enviar correos a los coordinadores involucrados.
            		sendAssignationEmail(ticket,coordinador);
            	}
            	
            	
            	for(TicketTeamBean miembro:miembros){
                	//registrar bloomTicketTeam  Responsables
                	getInternalTicketsDao().registrarMiembroTicket(miembro);
            	}
            	
            	//registrar bloomDeliverableTrace. Documentos
            	
            }
        	

        } catch (DAOException ex) {
            throw new ServiceException("No se pudo registrar ticket ");
        }

    }
    
    
    private void sendAssignationEmail(InternalTicketBean ticket,EmployeeDTO member){
    	
		// Enviar el email
		IEmailService mail = EmailServiceFactory.getEmailService();
		String to = member.getName() + ", " + member.getEmail();
		
		String subject = String.format("Ticket %s  Nuevo", ticket.getTicketNumber());
		
		StringBuilder bodySb = new StringBuilder();

		bodySb.append(String.format("El ticket interno %s le ha sido asignada para dar seguimiento.",ticket.getTicketNumber()));
		
		bodySb.append("\r\n Información adicional:");
		
		bodySb.append(String.format("\r\n\r\n Solicitante: %s", ticket.getCreatedUserName()));
		bodySb.append(String.format("\r\n\r\n Area Solicitante: %s", ticket.getPetitionerArea()));
		bodySb.append(String.format("\r\n\r\n Oficina: %s", ticket.getOfficeName()));
		bodySb.append(String.format("\r\n\r\n Tipo de Solicitud: %s", ticket.getServiceTypeDescr()));
		bodySb.append(String.format("\r\n\r\n Fecha de Registro: %s", ticket.getCreatedStr()));
		bodySb.append(String.format("\r\n\r\n Proyecto: %s", ticket.getProject()));
		
		String who = ticket.getCreatedUserEmail();
		
		mail.sendEmail(who, to, subject, bodySb.toString());
    }
    
	
	/**
	 * @return the internalTicketsDao
	 */
	public InternalTicketsDao getInternalTicketsDao() {
		return internalTicketsDao;
	}



	/**
	 * @param internalTicketsDao the internalTicketsDao to set
	 */
	public void setInternalTicketsDao(InternalTicketsDao internalTicketsDao) {
		this.internalTicketsDao = internalTicketsDao;
	}


	/**
	 * @return the userDomainDAO
	 */
	public UserDomainDAO getUserDomainDAO() {
		return userDomainDAO;
	}


	/**
	 * @param userDomainDAO the userDomainDAO to set
	 */
	public void setUserDomainDAO(UserDomainDAO userDomainDAO) {
		this.userDomainDAO = userDomainDAO;
	}




	
	

}
