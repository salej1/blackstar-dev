package com.blackstar.web;

import java.io.IOException;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;

import com.blackstar.common.*;
import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.TicketController;
import com.blackstar.model.UserSession;
import com.blackstar.services.IUserService;
import com.blackstar.services.UserServiceFactory;

/**
 * Servlet implementation class Tickets
 */
public class Tickets extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Tickets() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		JSONArray jsTickets = new JSONArray();
		ResultSet rsTickets;
		try
		{
			BlackstarDataAccess da = new BlackstarDataAccess();
			UserSession user = (UserSession) request.getSession().getAttribute(Globals.SESSION_KEY_PARAM);
			if(user.getUser().getBelongsToGroup().get("Cliente")){
				rsTickets = da.executeQuery(String.format("CALL GetLimitedTicketList('%s')", user.getUser().getUserEmail()));
			}
			else{
				rsTickets = da.executeQuery("CALL GetAllTickets()");
			}
			
			jsTickets = ResultSetConverter.convertResultSetToJSONArray(rsTickets);
			
			request.setAttribute("ticketsList", jsTickets.toString());	
			
			da.closeConnection();
			
			IUserService dir = UserServiceFactory.getUserService();
			request.setAttribute("employees", dir.getEmployeeList());
		}
		catch (Exception e)
		{
			 Logger.Log(LogLevel.FATAL, e.getStackTrace()[0].toString(), e);
		}
		
		request.getRequestDispatcher("/tickets.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String ticket = request.getParameter("ticketId");
			String employee = request.getParameter("employee");
			int ticketId = Integer.parseInt(ticket);
			String who = "portal-servicios@gposac.com.mx";
			
			TicketController.AssignTicket(ticketId, employee, who, null);

		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			response.sendRedirect("/tickets");
		}
	}
}
