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
import com.blackstar.interfaces.IUserService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
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
			rsTickets = da.executeQuery("CALL GetAllTickets()");
			jsTickets = ResultSetConverter.convertResultSetToJSONArray(rsTickets);
			
			request.setAttribute("ticketsList", jsTickets.toString());	
			
			da.closeConnection();
			
			IUserService dir = UserServiceFactory.getUserService();
			request.setAttribute("employees", dir.getEmployeeList());
		}
		catch (Exception ex)
		{
			 Logger.Log(LogLevel.FATAL, ex);
		}
		
		request.getRequestDispatcher("/tickets.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			BlackstarDataAccess da = new BlackstarDataAccess();
			
			String ticket = request.getParameter("ticketId");
			String employee = request.getParameter("employee");		
			
			da.executeQuery(String.format("CALL AssignTicket('%s', '%s', '%s', '%s')", ticket, employee, "sergio.aga", "Dashboard"));
			
			da.closeConnection();
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
