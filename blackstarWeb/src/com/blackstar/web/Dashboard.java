package com.blackstar.web;

import java.io.IOException;
import java.sql.ResultSet;
import java.util.Enumeration;

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
import com.blackstar.services.*;

/**
 * Servlet implementation class dashboard
 */
public class Dashboard extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Dashboard() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		JSONArray jsServiceOrdersToReview = new JSONArray();
		JSONArray jsServiceOrdersPending = new JSONArray();
		JSONArray jsticketsToAssign = new JSONArray();

		ResultSet rsServiceOrdersToReview;
		ResultSet rsServiceOrdersPending;
		ResultSet rsTicketsToAssign;

		// Recuperando los tickets y ordenes de servicio de la BD
		try {
			BlackstarDataAccess da = new BlackstarDataAccess();
			rsTicketsToAssign = da.executeQuery("CALL GetUnassignedTickets();");
			jsticketsToAssign = ResultSetConverter.convertResultSetToJSONArray(rsTicketsToAssign);

			rsServiceOrdersToReview = da.executeQuery(String.format("CALL GetServiceOrders('%s')", "NUEVO"));
			jsServiceOrdersToReview = ResultSetConverter.convertResultSetToJSONArray(rsServiceOrdersToReview);

			rsServiceOrdersPending = da.executeQuery(String.format("CALL GetServiceOrders ('%s')", "PENDIENTE"));
			jsServiceOrdersPending = ResultSetConverter.convertResultSetToJSONArray(rsServiceOrdersPending);

			request.setAttribute("ticketsToAssignDashboard", jsticketsToAssign.toString());
			request.setAttribute("serviceOrdersToReviewDashboard", jsServiceOrdersToReview.toString());
			request.setAttribute("serviceOrdersPendingDashboard", jsServiceOrdersPending.toString());
			
			da.closeConnection();
			// Recuperando la lista de empleados del directorio
			IUserService dir = UserServiceFactory.getUserService();
			request.setAttribute("employees", dir.getEmployeeList());
			
		} 
		
		catch (Exception ex) {
			
			Logger.Log(LogLevel.ERROR, ex);
			if (jsticketsToAssign.length() == 0) {
				request.setAttribute("ticketsToAssignDashboard", "Error al recuperar tickets por asignar");
			}
			if (jsServiceOrdersToReview.length() == 0) {
				request.setAttribute("serviceOrdersToReviewDashboard", "Error al recuperar ordenes de servicio por revisar");
			}
			if (jsServiceOrdersPending.length() == 0) {
				request.setAttribute("serviceOrdersPendingDashboard", "Error al recuperar ordenes de servicio pendientes");
			}
		}

		request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		JSONArray jsServiceOrdersToReview = new JSONArray();
		JSONArray jsServiceOrdersPending = new JSONArray();
		JSONArray jsticketsToAssign = new JSONArray();

		ResultSet rsServiceOrdersToReview;
		ResultSet rsServiceOrdersPending;
		ResultSet rsTicketsToAssign;
		BlackstarDataAccess da = new BlackstarDataAccess();
		
		try {
			String ticket = request.getParameter("ticketNumber");
			String employee = request.getParameter("employee");		
			
			da.executeQuery(String.format("CALL AssignTicket('%s', '%s', '%s', '%s')", ticket, employee, "sergio.aga", "Dashboard"));
			
			rsTicketsToAssign = da.executeQuery("CALL GetUnassignedTickets();");
			jsticketsToAssign = ResultSetConverter.convertResultSetToJSONArray(rsTicketsToAssign);

			response.getWriter().print(jsticketsToAssign);
			request.setAttribute("serviceOrdersToReviewDashboard", jsServiceOrdersToReview.toString());
			request.setAttribute("serviceOrdersPendingDashboard", jsServiceOrdersPending.toString());
			
			da.closeConnection();
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally{
			da.closeConnection();
			response.sendRedirect("/dashboard");
		}
	}

}