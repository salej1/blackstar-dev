package com.blackstar.web;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.db.DAOFactory;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Equipmenttype;
import com.blackstar.model.Followup;
import com.blackstar.model.Office;
import com.blackstar.model.Policy;
import com.blackstar.model.Servicecenter;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.Ticket;
import com.blackstar.model.Ticketstatus;
import com.blackstar.model.User;
import com.blackstar.model.dto.EmployeeDTO;
import com.blackstar.model.dto.OrderserviceDTO;


public class TicketDetail extends HttpServlet{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = -1L;
	private DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
	
	
	
	public TicketDetail() {
		// TODO Auto-generated constructor stub
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
				/// obtener del request el id del ticket
				Ticket ticket = null;
				String idTicket = null;
				String numTicket = null;
				
				Object rawTicket = request.getParameter("ticketId");
				if(rawTicket == null){
					rawTicket = request.getParameter("ticketNumber");
					numTicket = rawTicket.toString();
				}
				else{
					idTicket = rawTicket.toString();
				}

				int parsedTicketId = 0;
				
				if(idTicket != null){
					parsedTicketId = Integer.parseInt(idTicket);
					ticket = this.daoFactory.getTicketDAO().getTicketById(parsedTicketId);
				}
				else if(numTicket != null){
					ticket = this.daoFactory.getTicketDAO().getTicketByNumber(numTicket);
					parsedTicketId = ticket.getTicketId();
				}
				
				if(ticket!= null && parsedTicketId > 0){
					
					request.setAttribute("ticketF", ticket);
								
					Ticketstatus ticketstatus = this.daoFactory.getTicketStatusDAO().getTicketStatusById(ticket.getTicketStatusId());
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
						
					List<EmployeeDTO> UsuariosAsignados = getEmployeeList(); // TODO: Obtener los usuarios posibles a asignar un ticket
					request.setAttribute("UsuariosAsignados", UsuariosAsignados);
						
					// Obtener los followups asociados a la orden de servicio
					List<Followup> followUps =  this.daoFactory.getFollowUpDAO().getFollowUpByTicketId(parsedTicketId);
					request.setAttribute("Comentarios", followUps);
					
					// Obtener las ordenes de servicio que pueden cerrar este ticket
					Map<String, String> serviceOrdersList = getServiceOrderList(ticket.getPolicyId());
					request.setAttribute("potentialOs", serviceOrdersList);
				}
				request.getRequestDispatcher("/ticketDetail.jsp").forward(request, response);
				
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

	private Map<String, String> getServiceOrderList(int policyId){
		Map<String, String> list = new HashMap<String, String>();
		try{
			BlackstarDataAccess da = new BlackstarDataAccess();
			ResultSet rs = da.executeQuery("CALL GetServicesByPolicyId(" + policyId + ")");
			
			while(rs.next()){
				list.put(rs.getString("serviceOrderId"), rs.getString("serviceOrderNumber") );
			}
			
			da.closeConnection();
		}
		catch(Exception ex){
			Logger.Log(LogLevel.ERROR, ex);
		}
		return list;
	}
	
	private List<EmployeeDTO> getEmployeeList(){
		List<EmployeeDTO> list = new ArrayList<EmployeeDTO>();
		try{
			BlackstarDataAccess da = new BlackstarDataAccess();
			ResultSet rs = da.executeQuery("CALL GetDomainEmployess()");
			
			while(rs.next()){
				EmployeeDTO emp = new EmployeeDTO();
				emp.setEmail(rs.getString("email"));
				emp.setName(rs.getString("name"));
				list.add(emp);
			}
			
			da.closeConnection();
		}
		catch(Exception ex){
			Logger.Log(LogLevel.ERROR, ex);
		}
		return list;
	}
}

