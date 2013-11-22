package com.blackstar.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;

import com.blackstar.common.ResultSetConverter;

import java.sql.ResultSet;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;


/**
 * Servlet implementation class OrdenesServicio
 */
public class OrdenesServicio extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OrdenesServicio() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		JSONArray jsServiceOrders = new JSONArray();
		
		ResultSet rsServiceOrders;

		try
		{		
			BlackstarDataAccess da = new BlackstarDataAccess();
			rsServiceOrders = da.executeQuery("CALL GetAllServiceOrders()");
			jsServiceOrders = ResultSetConverter.convertResultSetToJSONArray(rsServiceOrders);
		
			request.setAttribute("serviceOrders", jsServiceOrders.toString());
			
			da.closeConnection();
		}
		catch (Exception ex)
		{
			 Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}

		request.getRequestDispatcher("/ordenesServicio.jsp").forward(request, response);

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}