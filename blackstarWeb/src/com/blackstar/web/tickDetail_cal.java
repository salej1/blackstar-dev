package com.blackstar.web;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.blackstar.db.DAOFactory;
import com.blackstar.model.Equipmenttype;
import com.blackstar.model.Followup;
import com.blackstar.model.Office;
import com.blackstar.model.Policy;
import com.blackstar.model.Servicecenter;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.Ticket;
import com.blackstar.model.Ticketstatus;
import com.blackstar.model.User;
import com.blackstar.model.dto.OrderserviceDTO;


public class tickDetail_cal extends HttpServlet{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = -1L;
	private DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
	
	
	
	public tickDetail_cal() {
		// TODO Auto-generated constructor stub
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
				/// obtener del request el id del ticket
				String idTicket = request.getAttribute("ticketId").toString();
				Ticket ticket = this.daoFactory.getTicketDAO().getTicketById(Integer.parseInt(idTicket));
				request.setAttribute("ticketF", ticket);
				
				Serviceorder serviceOrder = this.daoFactory.getServiceOrderDAO().getServiceOrderById(ticket.getServiceId());
				request.setAttribute("serviceOrderT", serviceOrder);
				
				Ticketstatus ticketstatus = this.daoFactory.getTicketStatusDAO().getTicketStatusById(ticket.getTicketStatusId()());
				request.setAttribute("ticketstatusT", ticketstatus);

				/// Obtener la poliza asociada a la orden de servicio
				Policy policy  = this.daoFactory.getPolicyDAO().getPolicyById(ticket.getPolicyId());
				request.setAttribute("policyt", policy);
				
				/// Obtener el tipo de equipo asociada a la orden de servicio
				Equipmenttype equipmenttype  = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
				request.setAttribute("EquipmenttypeT", equipmenttype);
				
				/// Obtener la oficina asociada a la orden de servicio
				Office office =  this.daoFactory.getOfficeDAO().getOfficeById(policy.getOfficeId());
				request.setAttribute("officeT", office);
				
				Servicecenter Servicecenter =  this.daoFactory.getServiceCenterDAO().getServiceCenterById(policy.getServiceCenterId());
				request.setAttribute("ServicecenterT", Servicecenter);
					
				List<User> UsuariosAsignados = null; // TODO: Obtener los usuarios posibles a asignar una orden de servicio
				request.setAttribute("UsuariosAsignados", UsuariosAsignados);
					
				// Obtener los followups asociados a la orden de servicio
				List<Followup> followUps =  this.daoFactory.getFollowUpDAO().getFollowUpByServiceOrderId(serviceOrder.getServiceOrderId());
				request.setAttribute("ComentariosOS", followUps);
			
				request.getRequestDispatcher("/tickDetail_cal.jsp").forward(request, response);
				
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		if(request.getParameter("datosComentario").toString().equals("")== false){
			  
			String[] datosComentario=request.getParameter("datosComentario").toString().split("&&");
			  String comentario = datosComentario[0];
			  String asignadoA = datosComentario[1];
			  String folioOS = datosComentario[2];
			  
			  //TODO: Guardar followup
			  Followup followup =  new Followup();
			  followup.setModified(new Date());
			  followup.setCreated(new Date());
		}
		
		
	}

	
}

