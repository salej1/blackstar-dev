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
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.UserServiceFactory;


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
		
		try {
			/// obtener del request el id del ticket
			Ticket ticket = null;
			String idTicket = null;
			String numTicket = null;
			String  rawTicket = request.getParameter("ticketId");
			
			if(rawTicket == null){
				rawTicket = request.getParameter("ticketNumber");
				if(rawTicket == null){
					Logger.Log(LogLevel.FATAL, Thread.currentThread().getStackTrace()[1].toString(), "TicketDetail se invoca sin parametros validos", "");
					response.getWriter().write("Ticket Detail: Parametros invalidos");
					request.getRequestDispatcher("/dashboard/show.do").forward(request, response);
				}
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
					
				Map<String, String> UsuariosAsignados = UserServiceFactory.getUserService().getEmployeeList(); 
				request.setAttribute("employees", UsuariosAsignados);
					
				// Obtener los followups asociados a la orden de servicio
				List<FollowUpDTO> followUps = getFollowUpList(ticket.getTicketId());
				request.setAttribute("followUps", followUps);
				
				// Obtener las ordenes de servicio que pueden cerrar este ticket
				Map<String, String> serviceOrdersList = getServiceOrderList(ticket.getPolicyId());
				request.setAttribute("potentialOs", serviceOrdersList);
			}
			request.getRequestDispatcher("/ticketDetail.jsp").forward(request, response);
		} catch (NumberFormatException e) {
			Logger.Log(LogLevel.FATAL, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
				
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
				
	}

	private Map<String, String> getServiceOrderList(int policyId){
		Map<String, String> list = new HashMap<String, String>();
		try{
			BlackstarDataAccess da = new BlackstarDataAccess();
			ResultSet rs = da.executeQuery("CALL GetServicesByPolicyId(" + policyId + ")");
			
			while(rs.next()){
				list.put(rs.getString("ServiceOrderId"), rs.getString("serviceOrderNumber") );
			}
			
			da.closeConnection();
		}
		catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		return list;
	}

	private List<FollowUpDTO> getFollowUpList(int ticketId){
		BlackstarDataAccess da = new BlackstarDataAccess();
		
		List<FollowUpDTO> list = new ArrayList<FollowUpDTO>();
		try{
			String sql = "CALL GetFollowUpByTicket(%s)";
			sql = String.format(sql, ticketId);
			
			ResultSet rs = da.executeQuery(sql);
			
			while(rs.next()){
				FollowUpDTO fu = new FollowUpDTO(
						String.format("%s", rs.getTimestamp("created")),
						rs.getString("asignee"), 
						rs.getString("createdBy"), 
						rs.getString("followUp")
				);
				list.add(fu);
			}
		}
		catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		finally{
			da.closeConnection();
		}
		return list;
	}
}

