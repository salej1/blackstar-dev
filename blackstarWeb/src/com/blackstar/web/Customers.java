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
import com.blackstar.services.IUserService;
import com.blackstar.services.UserServiceFactory;

public class Customers extends HttpServlet
{
	private static final long serialVersionUID = 1L;

	public Customers()
	{
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		BlackstarDataAccess blackstarDataAccess;
		JSONArray jsTickets;
		ResultSet rsTickets;

		try
		{
			jsTickets = new JSONArray();
			blackstarDataAccess = new BlackstarDataAccess();
			rsTickets = blackstarDataAccess.executeQuery("CALL GetAllTickets()");
			jsTickets = ResultSetConverter.convertResultSetToJSONArray(rsTickets);

			request.setAttribute("ticketsList", jsTickets.toString());

			blackstarDataAccess.closeConnection();

			IUserService dir = UserServiceFactory.getUserService();
			request.setAttribute("employees", dir.getEmployeeList());
		} catch (Exception e) {
			Logger.Log(LogLevel.FATAL, e.getStackTrace()[0].toString(), e);
		}

		request.getRequestDispatcher("/customers.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
//		try
//		{
//			String ticket = request.getParameter("ticketId");
//			String employee = request.getParameter("employee");
//			int ticketId = Integer.parseInt(ticket);
//			String who = "portal-servicios@gposac.com.mx";
//
//			TicketController.AssignTicket(ticketId, employee, who, null);
//
//		} catch (NumberFormatException e) {
//			// TODO Auto-generated catch block
//			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
//		} finally {
//			response.sendRedirect("/tickets");
//		}
		response.sendRedirect("/customers");
	}
}
