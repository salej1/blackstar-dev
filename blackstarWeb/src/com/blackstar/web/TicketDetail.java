package com.blackstar.web;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.ResultSet;
import java.text.SimpleDateFormat;
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
import com.blackstar.model.TicketController;
import com.blackstar.model.Ticketstatus;
import com.blackstar.model.User;
import com.blackstar.model.dto.EmployeeDTO;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.UserServiceFactory;
import com.google.appengine.api.datastore.RawValue;

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
					
				List<User> UsuariosAsignados = UserServiceFactory.getUserService().getEmployeeList(); 
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
			Logger.Log(LogLevel.FATAL, e.getStackTrace()[0].toString(), e);
		}
				
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		String ticketId = request.getParameter("closeTicketId");
		User thisUser = (User)request.getSession().getAttribute("user");
		String userId = null;
		SimpleDateFormat sdf;
		String sender = request.getParameter("sender");
		
		if(action.equals("closeTicket")){
			String closureOs = request.getParameter("osId");
			String employee = request.getParameter("attendingEmployee");
			String rawClosed = request.getParameter("closeDatetime");
			Date closed;

			if(thisUser != null){
				userId = thisUser.getUserEmail();
			}
			
			try {
				sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
				closed = sdf.parse(rawClosed);
				
				sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				String sql = "CALL CloseTicket(%s, '%s', '%s', '%s', '%s')";
				sql = String.format(sql, ticketId, closureOs, sdf.format(closed), userId, employee);
				
				BlackstarDataAccess da = new BlackstarDataAccess();
		
				da.executeQuery(sql);
			} catch (Exception e) {
				Logger.Log(LogLevel.FATAL, e.getStackTrace()[0].toString(), e);
			}
		}
		else if(action.endsWith("reopenTicket")){
			ticketId = request.getParameter("reopenTicketId");
			
			if(thisUser != null){
				userId = thisUser.getUserEmail();
			}
			
			String sql = "CALL ReopenTicket(%s, '%s')";
			sql = String.format(sql, ticketId, userId);
			
			BlackstarDataAccess da = new BlackstarDataAccess();
			try {
				da.executeQuery(sql);
			} catch (Exception e) {
				Logger.Log(LogLevel.FATAL, e.getStackTrace()[0].toString(), e);
			}
		}
		else if(action.equals("updateArrival")){
			String rawArrival = request.getParameter("arrival");
			Date arrival;
			ticketId = request.getParameter("ticketId");
			
			if(thisUser != null){
				userId = thisUser.getUserEmail();
			}
			
			try{
				sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
				
				arrival = sdf.parse(rawArrival);

				String sql = "CALL UpdateTicketArrival(%s, '%s', '%s', '%s')";
				
				sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				sql = String.format(sql, ticketId, sdf.format(arrival), "TicketDetail", userId);
				
				BlackstarDataAccess da = new BlackstarDataAccess();
				
				da.executeUpdate(sql);
			}
			catch(Throwable t){
				t.printStackTrace();
				Logger.Log(LogLevel.FATAL, t.getStackTrace()[0].toString(), t);
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		        response.flushBuffer();
				return;
			}
		}
		
		if(sender == null){
			sender = "/ticketDetail?ticketId="+ticketId;
		}
		
		response.sendRedirect(sender);
				
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
		catch(Exception e){
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
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
						String.format("%s", rs.getTimestamp("timeStamp")),
						rs.getString("asignee"), 
						rs.getString("createdBy"), 
						rs.getString("followUp")
				);
				list.add(fu);
			}
		}
		catch(Exception e){
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			da.closeConnection();
		}
		return list;
	}
}

