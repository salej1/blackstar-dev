package com.blackstar.web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


//import com.google.cloud.sql.jdbc.ResultSet;
import java.sql.ResultSet;

import org.json.JSONArray;

import com.blackstar.common.*;
import com.blackstar.db.DataAccess;;

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
			
			rsTickets = DataAccess.executeQuery(String.format("CALL GetTickets('%s')", "ABIERTO"));
			jsTickets = ResultSetConverter.convertResultSetToJSONArray(rsTickets);
		//	List<Ticket> tckts;
		//	MySQLTicketDAO tckDAO = new MySQLTicketDAO();
		//	tckts = tckDAO.selectAllTicket();
		//	jsTickets = ListConverter.getJsonFromTicketsList(tckts);
			
		}
		catch (Exception ex)
		{
			 ex.printStackTrace();
		}
		
	    request.setAttribute("ticketsList", jsTickets.toString());		
		request.getRequestDispatcher("/tickets.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	
	}
}
