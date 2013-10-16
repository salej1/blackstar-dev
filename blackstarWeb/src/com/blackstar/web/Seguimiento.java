package com.blackstar.web;

import java.io.IOException;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;

import com.blackstar.common.ResultSetConverter;
import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.interfaces.IUserService;
import com.blackstar.logging.*;
import com.blackstar.model.User;
import com.blackstar.services.UserServiceFactory;

/**
 * Servlet implementation class Seguimiento
 */
public class Seguimiento extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Seguimiento() {
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
			if(myUser.belongsToGroup("Call Center")){
				processCallCenterFollowUp(da, request);
			}
			else{
				processFollowUp(da, request);
			}
		}
		catch (Exception ex)
		{
			 Logger.Log(LogLevel.FATAL, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		
		request.getRequestDispatcher("/tickets.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}
	
	private void processCallCenterFollowUp(BlackstarDataAccess da, HttpServletRequest request) throws Exception{
		ResultSet rsTickets;
		JSONArray jsTickets = new JSONArray();
		
		rsTickets = da.executeQuery("CALL GetBigTicketTable()");
		jsTickets = ResultSetConverter.convertResultSetToJSONArray(rsTickets);
		
		for(int i = 0; i < jsTickets.length(); i++){
			ResultSet rsFollowUp = da.executeQuery(String.format("CALL GetFollowUpbyTicket(%d)", jsTickets.getJSONObject(i).getInt("DT_RowId")));
			JSONArray jsTicketFollowup = ResultSetConverter.convertResultSetToJSONArray(rsFollowUp);
			jsTickets.getJSONObject(i).append("followUps", jsTicketFollowup);
		}
		
		request.setAttribute("ticketsList", jsTickets.toString());	
		
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

}
