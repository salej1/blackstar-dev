package com.blackstar.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;

/**
 * Servlet implementation class AddFollowUp
 */
public class AddFollowUp extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddFollowUp() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String id = request.getParameter("id");
			String type = request.getParameter("type");
			String sender = request.getParameter("sender");
			String timeStamp = request.getParameter("timeStamp");
			String asignee = request.getParameter("asignee");
			String message = request.getParameter("message");
			String redirect = request.getParameter("redirect");
			
			BlackstarDataAccess da = new BlackstarDataAccess();
			String sql = null;
			if(type.equals("ticket")){
				sql = "CALL AddFollowUpToTicket(%s, '%s', '%s', '%s', '%s')";
			}
			else{
				sql = "CALL AddFollowUpToOS(%s, '%s', '%s', '%s', '%s')";
			}
			sql = String.format(sql, id, timeStamp, sender, asignee, message);
			
			da.executeQuery(sql);
			
			da.closeConnection();
			
			response.sendRedirect(redirect);
			
		} catch (Exception e) {
			Logger.Log(LogLevel.FATAL, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
	}

}
