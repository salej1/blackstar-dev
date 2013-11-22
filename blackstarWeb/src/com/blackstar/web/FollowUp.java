package com.blackstar.web;

import java.io.IOException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;

import com.blackstar.common.ResultSetConverter;
import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.interfaces.IUserService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.User;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.UserServiceFactory;
import com.google.api.services.admin.directory.model.UserName;

/**
 * Servlet implementation class FollowUp
 */
public class FollowUp extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FollowUp() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		User myUser = (User)request.getSession().getAttribute("user");
		BlackstarDataAccess da = new BlackstarDataAccess();
		
		try
		{
			if(myUser.getBelongsToGroup().get("Call Center") != null){
				processCallCenterFollowUp(da, request);
				request.getRequestDispatcher("/seguimientoCal.jsp").forward(request, response);
			}
			else{
				processFollowUp(da, request);
				request.getRequestDispatcher("/seguimiento.jsp").forward(request, response);
			}
		}
		catch (Exception ex)
		{
			 Logger.Log(LogLevel.FATAL, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		User thisUser = (User)request.getSession().getAttribute("user");
		String userId = null;
		
		if(action.equals("closeTicket")){
			String ticketId = request.getParameter("ticketId");
			String closureOs = request.getParameter("osId");

			if(thisUser != null){
				userId = thisUser.getUserEmail();
			}
			
			String sql = "CALL CloseTicket(%s, %s, '%s')";
			sql = String.format(sql, ticketId, closureOs, userId);
			
			BlackstarDataAccess da = new BlackstarDataAccess();
			try {
				da.executeQuery(sql);
			} catch (Exception e) {
				Logger.Log(LogLevel.FATAL, Thread.currentThread().getStackTrace()[1].toString(), e);
			}
		}
		else if(action.endsWith("reopenTicket")){
			String ticketId = request.getParameter("reopenTicketId");
			
			if(thisUser != null){
				userId = thisUser.getUserEmail();
			}
			
			String sql = "CALL ReopenTicket(%s, '%s')";
			sql = String.format(sql, ticketId, userId);
			
			BlackstarDataAccess da = new BlackstarDataAccess();
			try {
				da.executeQuery(sql);
			} catch (Exception e) {
				Logger.Log(LogLevel.FATAL, Thread.currentThread().getStackTrace()[1].toString(), e);
			}
		}
		
		response.sendRedirect("/seguimiento");
	}
	

	private void processCallCenterFollowUp(BlackstarDataAccess da, HttpServletRequest request) throws Exception{
		ResultSet rsTickets;
		JSONArray jsTickets = new JSONArray();
		Map<String, String> ticketMap = new HashMap<String, String>();
		
		rsTickets = da.executeQuery("CALL GetBigTicketTable()");
		jsTickets = ResultSetConverter.convertResultSetToJSONArray(rsTickets);
		
		for(int i = 0; i < jsTickets.length(); i++){
			ResultSet rsFollowUp = da.executeQuery(String.format("CALL GetFollowUpByTicket(%d)", jsTickets.getJSONObject(i).getInt("DT_RowId")));
			// Agregando los elementos de seguimiento
			JSONArray jsTicketFollowup = ResultSetConverter.convertResultSetToJSONArray(rsFollowUp);
			jsTickets.getJSONObject(i).append("followUps", jsTicketFollowup);
			
			// Agregado el mapa de tickets
			ticketMap.put(String.format("%s", jsTickets.getJSONObject(i).getInt("DT_RowId")), jsTickets.getJSONObject(i).getString("ticketNumber"));
		}
		
		// obteniendo el listado de OS para cerrar tickets
		List<OrderserviceDTO> serviceOrdersList = getServiceOrderList();
		request.setAttribute("potentialOs", serviceOrdersList);
		
		request.setAttribute("ticketsList", jsTickets.toString());	
		request.setAttribute("ticketMap", ticketMap);
		
		da.closeConnection();
		
		IUserService dir = UserServiceFactory.getUserService();
		request.setAttribute("employees", dir.getEmployeeList());
	}
	
	private void processFollowUp(BlackstarDataAccess da, HttpServletRequest request) throws Exception{
		ResultSet rs;
		JSONArray jsDelayedTickets = new JSONArray();
		JSONArray jsOpenTickets = new JSONArray();
		JSONArray jsPendingSo = new JSONArray();
		
		// Recuperar y mostrarlos tickets retrasados
		rs = da.executeQuery("CALL GetTicketsByStatus('R')");
		jsDelayedTickets = ResultSetConverter.convertResultSetToJSONArray(rs);
		request.setAttribute("delayedTickets", jsDelayedTickets);
		
		// Recuperar y mostrarlos tickets abiertos
		rs = da.executeQuery("CALL GetTicketsByStatus('A')");
		jsOpenTickets = ResultSetConverter.convertResultSetToJSONArray(rs);
		request.setAttribute("openTickets", jsOpenTickets);
		
		// Recuperar y mostrarlas ordenes con pendientes
		rs = da.executeQuery(String.format("CALL GetServiceOrders ('%s')", "PENDIENTE"));
		jsPendingSo = ResultSetConverter.convertResultSetToJSONArray(rs);
		
		for(int i = 0; i < jsPendingSo.length(); i++){
			ResultSet rsFollowUp = da.executeQuery(String.format("CALL GetFollowUpByServiceOrder(%d)", jsPendingSo.getJSONObject(i).getInt("DT_RowId")));
			JSONArray jsOrderFollowUp = ResultSetConverter.convertResultSetToJSONArray(rsFollowUp);
			jsPendingSo.getJSONObject(i).append("followUps", jsOrderFollowUp);
		}
		
		request.setAttribute("pendingSo", jsPendingSo);
	}
	
	private List<OrderserviceDTO> getServiceOrderList(){
		ArrayList<OrderserviceDTO> list = new ArrayList<OrderserviceDTO>();
		OrderserviceDTO dto;
		
		try{
			BlackstarDataAccess da = new BlackstarDataAccess();
			ResultSet rs = da.executeQuery("CALL GetServiceOrders('CERRADO')");
			
			while(rs.next()){
				dto = new OrderserviceDTO();
				dto.setServiceOrderId(rs.getInt("DT_RowId"));
				dto.setServiceOrderNo(rs.getString("serviceOrderNumber"));
				list.add(dto);
			}
			
			da.closeConnection();
		}
		catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		return list;
	}

}
