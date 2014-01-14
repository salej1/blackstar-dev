package com.blackstar.model;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.db.DAOFactory;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.services.EmailServiceFactory;

public class ServiceOrderController {
	public static void AssignServiceOrder(int osId, String asignee, String who, String message){
		BlackstarDataAccess da = new BlackstarDataAccess();
			
		try {

			da.executeUpdate(String.format("CALL AssignServiceOrder('%s', '%s', '%s', '%s')", osId, asignee, who, "Dashboard"));
			
			SendAssignationEmail(osId, asignee, who, message);
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			da.closeConnection();
		}
	}
	
	private static void SendAssignationEmail(int osId, String employee, String who, String message){
		String officeMail = "";
		String ssMail = "";
		int ticketId;
		DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
		Ticket osTicket = null;
				
		Serviceorder so = daoFactory.getServiceOrderDAO().getServiceOrderById(osId);
		
		if(so != null)
		{
			int policiId = so.getPolicyId();
			if(policiId > 0){
				Policy po = daoFactory.getPolicyDAO().getPolicyById(policiId);
				
				ticketId = so.getTicketId();
				if(ticketId > 0){
					osTicket = daoFactory.getTicketDAO().getTicketById(ticketId);
				}
				
				if(po != null){
					char etId = po.getEquipmentTypeId();
					
					Equipmenttype et = daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(etId);
					if(et != null){
						
						Servicetype st = daoFactory.getServiceTypeDAO().getServiceTypeById(so.getServiceTypeId());
						if(st != null){
							
							// Enviar el email
							IEmailService mail = EmailServiceFactory.getEmailService();
							String to = employee + ", " + ssMail + ", " + officeMail;
							String subject = String.format("Orden de servicio %s asignada", so.getServiceOrderNumber());
							StringBuilder bodySb = new StringBuilder();
							
							bodySb.append(String.format("La orden de servicio %s le ha sido asignada para dar seguimiento. Por favor revise a continuación los detalles de la orden ", so.getServiceOrderNumber()));
							if(message != null){
								bodySb.append(" y la información adicional.");
							}
							bodySb.append(String.format("\r\n\r\n Folio: %s", so.getServiceOrderNumber()));
							bodySb.append(String.format("\r\n\r\n Cliente: %s", po.getCustomer()));
							if(osTicket != null){
								bodySb.append(String.format("\r\n\r\n No ticket: %s", osTicket.getTicketNumber()));
							}
							else{
								bodySb.append("\r\n\r\n Sin ticket asociado");
							}
							bodySb.append(String.format("\r\n\r\n Domicilio: %s", po.getEquipmentAddress()));
							bodySb.append(String.format("\r\n\r\n Solicitante: %s", po.getContactName()));
							bodySb.append(String.format("\r\n\r\n Telefono: %s", po.getContactPhone()));
							bodySb.append(String.format("\r\n\r\n Fecha y hora de llegada: %s", so.getCreated()));
							bodySb.append(String.format("\r\n\r\n Equipo: %s", et.getEquipmentType()));
							bodySb.append(String.format("\r\n\r\n Marca: %s", po.getBrand()));
							bodySb.append(String.format("\r\n\r\n Modelo: %s", po.getModel()));
							bodySb.append(String.format("\r\n\r\n No. Serie: %s", po.getSerialNumber()));
							if(osTicket != null){
								bodySb.append(String.format("\r\n\r\n Falla: %s", so.getServiceComments()));
							}
							bodySb.append(String.format("\r\n\r\n Tipo de servicio: %s", po.getSerialNumber()));
							bodySb.append(String.format("\r\n\r\n Contrato: %s", po.getCustomerContract()));
							if(message != null){
								bodySb.append(String.format("\r\n\r\n Información adicional: %s", message));
							}
							mail.sendEmail(who, to, subject, bodySb.toString());
						}
					}		
				}	
			}
		}
	}
}
