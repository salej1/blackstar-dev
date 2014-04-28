package com.bloom.services;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.blackstar.db.dao.interfaces.UserDomainDAO;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.model.dto.EmployeeDTO;
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

public class InternalTicketsServiceImpl extends AbstractService implements
	InternalTicketsService {

	private InternalTicketsDao internalTicketsDao;

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
            
        	//LOGGER.error(ERROR_CONSULTA_CAT, e);
            
            throw new ServiceException("Error al obtener tickets", e);
        }
    }
    
    
    @Override
    public List<InternalTicketBean> getHistoricalTickets(String fechaIni, String fechaFin, Integer idStatusTicket, Long idResponsable) throws ServiceException {
    	
    	String formatoFechaStrEntrada="MM/dd/yyyy";
    	String formatoFechaStrSalida="yyyy-MM-dd";
    	
    	Date dIni=DataTypeUtil.getFecha(fechaIni, formatoFechaStrEntrada);
    	Date dFin=DataTypeUtil.getFecha(fechaFin, formatoFechaStrEntrada);
    	
    	fechaIni= DataTypeUtil.formatearFecha(dIni, formatoFechaStrSalida);
    	fechaFin= DataTypeUtil.formatearFecha(dFin, formatoFechaStrSalida);
    	
    	fechaIni = fechaIni+DataTypeUtil.MIN_TIME;
    	fechaFin = fechaFin+DataTypeUtil.MAX_TIME;
    	
        try {
        	return getInternalTicketsDao().getHistoricalTickets(fechaIni,fechaFin,idStatusTicket,idResponsable);
            
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
    	 
    	 ticket.setDeadline(DataTypeUtil.obtenerFecha(ticket.getDeadlineStr(), "MM/dd/yyyy"));
    	 Date fechaActual = new Date();
    	 
    	 
    	 if(ticket.getDeadline().getTime()<fechaActual.getTime()){
    		 throw new ServiceException("La fecha limite debe ser mayor a la fecha actual.");
    	 }
    	
    }

    
	
    @Override
    public void registrarNuevoTicket(InternalTicketBean ticket) throws ServiceException {

    	ticket.setDeadline(DataTypeUtil.obtenerFecha(ticket.getDeadlineStr(), "MM/dd/yyyy"));
    	ticket.setCreated(DataTypeUtil.obtenerFecha(ticket.getCreatedStr(), "MM/dd/yyyy HH:mm:ss"));
    	ticket.setStatusId(1);//ticket nuevo.
    	
    	List<CatalogoBean<Integer>> miebrosDtos;
    	List<CatalogoBean<Integer>> doctos;
    	
    	List<TicketTeamBean> miembros= new ArrayList<TicketTeamBean>();
    	
    	
    	
        try {
        	Long idTicket= getInternalTicketsDao().registrarNuevoTicket(ticket);

            if (idTicket > 0) {
                
            	//El creador del ticket entra con rol colaborador (2)
            	miembros.add(
            			new TicketTeamBean(idTicket, 2L, ticket.getCreatedUserId(),ticket.getCreatedUserEmail(),ticket.getCreatedUserName()));
            	
            	//obtener coordinadores
            	miebrosDtos=catalogInternalTicketsDao.getEmployeesByGroup("sysCoordinador");
            	
            	
            	for(CatalogoBean<Integer> coordinador:miebrosDtos){
            		//los cordinadores entran con rol de colaborador.
            		//coordinador.getId() --idUser
            		//coordinador.getExtra()--email
            		//coordinador.getDescripcion() --UserName
            		miembros.add(new TicketTeamBean(idTicket, 2L, 
            				(long)coordinador.getId(),
            				coordinador.getExtra(),
            				coordinador.getDescripcion()));
            		
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
            throw new ServiceException("No se pudo registrar ticket ");
        }

    }
    
    
    private void sendAssignationEmail(InternalTicketBean ticket,TicketTeamBean member){
    	
		// Enviar el email
		IEmailService mail = EmailServiceFactory.getEmailService();
		String to = member.getUserName() + ", " + member.getEmail();
		
		String subject = String.format("Requisición General Interna %s ", ticket.getTicketNumber());
		
		StringBuilder bodySb = new StringBuilder();

		bodySb.append(String.format("El ticket interno %s se ha creado.",ticket.getTicketNumber()));
		
		bodySb.append("\r\n Información adicional:");
		
		bodySb.append(String.format("\r\n\r\n Usuario Solicitante: %s", ticket.getCreatedUserName()));
		bodySb.append(String.format("\r\n\r\n Numero de ticket interno %s",ticket.getTicketNumber()));
		bodySb.append(String.format("\r\n\r\n Fecha y Hora de recepcion: %s", ticket.getCreatedStr()));
		bodySb.append(String.format("\r\n\r\n Departamento Solicitante: %s", ticket.getPetitionerArea()));
		bodySb.append(String.format("\r\n\r\n Requerimiento: %s", ticket.getDescription()));
		bodySb.append(String.format("\r\n\r\n Fecha Solicitada: %s", ticket.getDeadlineStr()));
		bodySb.append(String.format("\r\n\r\n Proyecto: %s", ticket.getProject()));
		bodySb.append(String.format("\r\n\r\n Oficina: %s", ticket.getOfficeName()));
		bodySb.append(String.format("\r\n\r\n Nota o liga de Anexos: %s", ""));
		bodySb.append(String.format("\r\n\r\n Tiempo de respuesta máximo en días: %s %s", ticket.getServiceTypeDescr(),ticket.getReponseInTime()));
		
		
		String who = "mesa-de-ayuda@gposac.com.mx";
		
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

}
