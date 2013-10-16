package com.blackstar.model;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.db.DAOFactory;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.services.EmailServiceFactory;

public class TicketController {
	public static void AssignTicket(int ticketId, String employee, String who){
		BlackstarDataAccess da = new BlackstarDataAccess();
		
		try {

			//User who = (User)request.getSession().getAttribute("user");
			String userName = "portal-servicios@gposac.com.mx";
			da.executeQuery(String.format("CALL AssignTicket('%s', '%s', '%s', '%s')", ticketId, employee, userName, "Dashboard"));
			
			SendAssignationEmail(ticketId, employee, userName);
		} catch (Exception ex) {
			// TODO Auto-generated catch block
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		finally{
			da.closeConnection();
		}
	}
	

	private static void SendAssignationEmail(int ticketId, String employee, String who){
		String officeMail = "";
		String ssMail = "";
		String ticketNum;
		String equipmentType = "";
		DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
		
		Ticket myTicket = daoFactory.getTicketDAO().getTicketById(ticketId);
		ticketNum = myTicket.getTicketNumber();
		
		int policyId = myTicket.getPolicyId();
		
		if(policyId > 0)
		{
			Policy tickPolicy;
			tickPolicy = daoFactory.getPolicyDAO().getPolicyById(policyId);
			
			if(tickPolicy != null){
				char officeId = tickPolicy.getOfficeId();
				
				Office off = null;
				// Office email
				if((int)officeId > 0){
					off = daoFactory.getOfficeDAO().getOfficeById(officeId);
					officeMail = off.getOfficeEmail();
				}
				
				char ssId = tickPolicy.getServiceCenterId();
				// Service center email
				Servicecenter ss = null;
				if(ssId > 0){
					ss = daoFactory.getServiceCenterDAO().getServiceCenterById(ssId);
					ssMail = ss.getServiceCenterEmail();
				}
				
				char eqId = tickPolicy.getEquipmentTypeId();
				// Service center email
				Equipmenttype et = null;
				if((int)eqId > 0){
					et = daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(eqId);
					equipmentType = et.getEquipmentType();
				}
				
				// Enviar el email
				IEmailService mail = EmailServiceFactory.getEmailService();
				String to = employee + ", " + ssMail + ", " + officeMail;
				String subject = String.format("Ticket %s asignado", ticketNum);
				String body = String.format("El reporte de emergencia con número de ticket %s le ha sido asignado. Por favor revise a continuación los detalles del reporte: ", ticketNum);
				body.concat(String.format("\r\n\r\n Marca temporal: ", myTicket.getCreated()));
				body.concat(String.format("\r\n\r\n Usuario: ", myTicket.getCreated()));
				body.concat(String.format("\r\n\r\n Contacto: ", tickPolicy.getContactName()));
				body.concat(String.format("\r\n\r\n Teléfono de Contacto: ", tickPolicy.getContactPhone()));
				body.concat(String.format("\r\n\r\n Email de Contacto: ", tickPolicy.getContactEmail()));
				body.concat(String.format("\r\n\r\n Número de serie: ", tickPolicy.getSerialNumber()));
				body.concat(String.format("\r\n\r\n Observaciones: ", myTicket.getObservations()));
				body.concat(String.format("\r\n\r\n Cliente: ", tickPolicy.getCustomer()));
				body.concat(String.format("\r\n\r\n Equipo: ", equipmentType));
				body.concat(String.format("\r\n\r\n Marca: ", tickPolicy.getBrand()));
				body.concat(String.format("\r\n\r\n Modelo: ", tickPolicy.getModel()));
				body.concat(String.format("\r\n\r\n Capacidad: ", tickPolicy.getCapacity()));
				body.concat(String.format("\r\n\r\n Tiempo de respuesta compromiso: ", tickPolicy.getResponseTimeHR()));
				body.concat(String.format("\r\n\r\n Dirección del equipo: ", tickPolicy.getEquipmentAddress()));
				body.concat(String.format("\r\n\r\n Ubicación del equipo: ", tickPolicy.getEquipmentLocation()));
				if(tickPolicy.getIncludesParts()){
					body.concat(String.format("\r\n\r\n Incluye partes: ", "SI"));
				}
				else{
					body.concat(String.format("\r\n\r\n Incluye partes: ", "NO"));
				}
				body.concat(String.format("\r\n\r\n Excepcion partes: ", tickPolicy.getExceptionParts()));
				body.concat(String.format("\r\n\r\n Centro de servicio: ", ss.getServiceCenter()));
				body.concat(String.format("\r\n\r\n Oficina: ", off.getOfficeName()));
				body.concat(String.format("\r\n\r\n Proyecto: ", tickPolicy.getProject()));
				mail.sendEmail(to, subject, body);
			}
		}
	}
}
