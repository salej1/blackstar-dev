package com.blackstar.web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import com.blackstar.common.ResultSetConverter;

import com.google.cloud.sql.jdbc.ResultSet; 
import com.google.cloud.sql.jdbc.*;

import com.blackstar.db.DataAccess;
//import com.blackstar.dataAccess.*;
//import java.sql.ResultSet;

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
		JSONArray jsServiceOrdersToReview = new JSONArray();
		JSONArray jsServiceOrdersPending = new JSONArray();
		ResultSet rsServiceOrdersToReview;
		ResultSet rsServiceOrdersPending;

		try
		{		
			rsServiceOrdersToReview = DataAccess.executeQuery("CALL GetServiceOrders(\"CERRADO\")");
			jsServiceOrdersToReview = ResultSetConverter.convertResultSetToJSONArray(rsServiceOrdersToReview);

			rsServiceOrdersPending = DataAccess.executeQuery("CALL GetServiceOrders(\"nada\")");
			jsServiceOrdersPending = ResultSetConverter.convertResultSetToJSONArray(rsServiceOrdersPending);	
		}
		catch (Exception ex)
		{
			 ex.printStackTrace();
		}

		request.setAttribute("serviceOrdersToReview", jsServiceOrdersToReview.toString());
		request.setAttribute("serviceOrdersPending", jsServiceOrdersPending.toString());	
		request.getRequestDispatcher("/ordenesServicio.jsp").forward(request, response);

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}