package com.blackstar.model;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.db.DAOFactory;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.services.EmailServiceFactory;

public class TicketController {
	public static void AssignTicket(int ticketId, String asignee, String who, String message){
		BlackstarDataAccess da = new BlackstarDataAccess();
		
		try {

			da.executeUpdate(String.format("CALL AssignTicket('%s', '%s', '%s', '%s')", ticketId, asignee, who, "Dashboard"));
			
			SendAssignationEmail(ticketId, asignee, who, message);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			da.closeConnection();
		}
	}
	
	private static void SendAssignationEmail(int ticketId, String employee, String who, String message){
		String officeMail = "";
		String ssMail = "";
		String ticketNum;
		String equipmentType = "";
		DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
		
		Ticket myTicket = daoFactory.getTicketDAO().getTicketById(ticketId);
		if(myTicket != null){
			
			ticketNum = myTicket.getTicketNumber();
			
			int policyId = myTicket.getPolicyId();
			
			if(policyId > 0)
			{
				Policy tickPolicy;
				tickPolicy = daoFactory.getPolicyDAO().getPolicyById(policyId);
				
				if(tickPolicy != null){
					char officeId = tickPolicy.getOfficeId();
					
					
					try {
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
						StringBuilder bodySb = new StringBuilder();
						
						bodySb.append(String.format("El reporte de emergencia con número de ticket %s le ha sido asignado. Por favor revise a continuación los detalles del reporte ", ticketNum));
						if(message != null){
							bodySb.append(" y la invormación adicional.");
						}
						bodySb.append(String.format("\r\n\r\n Marca temporal: %s", myTicket.getCreated()));
						bodySb.append(String.format("\r\n\r\n Contacto: %s", tickPolicy.getContactName()));
						bodySb.append(String.format("\r\n\r\n Teléfono de Contacto: %s", tickPolicy.getContactPhone()));
						bodySb.append(String.format("\r\n\r\n Email de Contacto: %s", tickPolicy.getContactEmail()));
						bodySb.append(String.format("\r\n\r\n Número de serie: %s", tickPolicy.getSerialNumber()));
						bodySb.append(String.format("\r\n\r\n Observaciones: %s", myTicket.getObservations()));
						bodySb.append(String.format("\r\n\r\n Cliente: %s", tickPolicy.getCustomer()));
						bodySb.append(String.format("\r\n\r\n Equipo: %s", equipmentType));
						bodySb.append(String.format("\r\n\r\n Marca: %s", tickPolicy.getBrand()));
						bodySb.append(String.format("\r\n\r\n Modelo: %s", tickPolicy.getModel()));
						bodySb.append(String.format("\r\n\r\n Capacidad: %s", tickPolicy.getCapacity()));
						bodySb.append(String.format("\r\n\r\n Tiempo de respuesta compromiso: %s", tickPolicy.getResponseTimeHR()));
						bodySb.append(String.format("\r\n\r\n Dirección del equipo: %s", tickPolicy.getEquipmentAddress()));
						bodySb.append(String.format("\r\n\r\n Ubicación del equipo: %s", tickPolicy.getEquipmentLocation()));
						if(tickPolicy.getIncludesParts()){
							bodySb.append(String.format("\r\n\r\n Incluye partes: %s", "SI"));
						}
						else{
							bodySb.append(String.format("\r\n\r\n Incluye partes: %s", "NO"));
						}
						bodySb.append(String.format("\r\n\r\n Excepcion partes: %s", tickPolicy.getExceptionParts()));
						bodySb.append(String.format("\r\n\r\n Centro de servicio: %s", ss.getServiceCenter()));
						bodySb.append(String.format("\r\n\r\n Oficina: %s", off.getOfficeName()));
						bodySb.append(String.format("\r\n\r\n Proyecto: %s", tickPolicy.getProject()));
						bodySb.append(String.format("\r\n\r\n Informacón adicional: %s", message));
						mail.sendEmail(who, to, subject, bodySb.toString()
								);
					} catch (Exception e) {
						Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
					}
				}
			}
		}
	}
}
