package com.blackstar.web;

import java.io.IOException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;

import com.blackstar.common.ResultSetConverter;
import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.db.DAOFactory;
import com.blackstar.db.dao.interfaces.TicketDAO;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.*;
import com.blackstar.services.*;

/**
 * Servlet implementation class dashboard
 */
public class Sales extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Sales() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		JSONArray jsNewSales = new JSONArray();
		JSONArray jsAuthorizedSales = new JSONArray();
		JSONArray jsPendingSales = new JSONArray();

		ResultSet rsNewSales;
		ResultSet rsAuthorizedSales;
		ResultSet rsPendingSales;

		// Recuperar ventas de la base de datos
		try {
			BlackstarDataAccess da = new BlackstarDataAccess();
			
			request.setAttribute("offices", getOfficesList(da));
			da.closeConnection();
			// Recuperando la lista de empleados del directorio
			IUserService dir = null;// = UserServiceFactory.getUserService();
			request.setAttribute("employees", dir.getEmployeeList());
			
		} 
		
		catch (Exception e) {
			
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			if (jsNewSales.length() == 0) {
				request.setAttribute("", "Error al recuperar nuevas ventas");
			}
			if (jsAuthorizedSales.length() == 0) {
				request.setAttribute("", "Error al recuperar ventas autorizadas");
			}
			if (jsPendingSales.length() == 0) {
				request.setAttribute("", "Error al recuperar ventas cotizadas");
			}
		}

		request.getRequestDispatcher("/sales.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try {
			

		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			response.sendRedirect("/dashboard");
		}
	}
	
	private List<String> getOfficesList(BlackstarDataAccess da){
		ArrayList<String> list = new ArrayList<String>();
		try{
			ResultSet rs = da.executeQuery("CALL GetOfficesList();");
			
			while(rs.next()){
				list.add(rs.getString("officeName"));
			}
		}
		catch(Exception e){
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		return list;
	}}

