package com.blackstar.web;

import java.io.IOException;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;

import com.blackstar.common.ResultSetConverter;
import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;

/**
 * Servlet implementation class EquipmentService
 */
public class EquipmentService extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EquipmentService() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			// Parametros
			String clientName = request.getParameter("clientName");
			
			if(clientName != null){
				BlackstarDataAccess da = new BlackstarDataAccess();
				ResultSet rs = da.executeQuery(String.format("CALL GetEquipmentByCustomer('%s')", clientName));
				
				JSONArray json = ResultSetConverter.convertResultSetToJSONArray(rs);
				response.setContentType("text/html");
		        response.getWriter().write(json.toString());
		        response.flushBuffer();
			}
		} catch (Exception e) {
			Logger.Log(LogLevel.FATAL, e.getStackTrace()[0].toString(), e);
		}		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
