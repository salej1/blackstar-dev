package com.blackstar.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.ServiceOrderController;
import com.blackstar.model.TicketController;
import com.blackstar.model.User;

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
			String sender = request.getParameter("sender"); // Se usa solo en caso de que falle recuperacion del usuario en sesion
			String timeStamp = request.getParameter("timeStamp");
			String asignee = request.getParameter("asignee");
			String message = request.getParameter("message");
			String redirect = request.getParameter("redirect");
			
			BlackstarDataAccess da = new BlackstarDataAccess();
			String sql = null;
			
			User thisUser = (User) request.getSession().getAttribute("user");
			if(thisUser != null){
				sender = thisUser.getUserEmail();
			}
			else{
				Logger.Log(LogLevel.WARNING, Thread.currentThread().getStackTrace()[1].toString(), "No se pudo recuperar el usuario de sesion", "");
			}
			if(type.equals("ticket")){
				sql = "CALL AddFollowUpToTicket(%s, '%s', '%s', '%s', '%s')";
			}
			else{
				sql = "CALL AddFollowUpToOS(%s, '%s', '%s', '%s', '%s')";
			}
			sql = String.format(sql, id, timeStamp, sender, asignee, message);
			
			Logger.Log(LogLevel.DEBUG, Thread.currentThread().getStackTrace()[1].toString(), "Invocando asignacion de ticket: " + sql, "");
			da.executeUpdate(sql);
			
			da.closeConnection();
			
			if(type.equals("ticket")){
				int ticketId;
				try {
					ticketId = Integer.parseInt(id);
					TicketController.AssignTicket(ticketId, asignee, sender, message);
				} catch (Exception e) {
					Logger.Log(LogLevel.WARNING, e.getStackTrace()[0].toString(), "Error al agrear FollowUp a ticket " + id + ". No se puede convertir ID a entero", "");
				}
			}
			else if(type.equals("os")){
				try {
					int osId = Integer.parseInt(id);
					ServiceOrderController.AssignServiceOrder(osId, asignee, sender, message);
				} catch (Exception e) {
					Logger.Log(LogLevel.WARNING, e.getStackTrace()[0].toString(), "Error al agrear FollowUp a OS " + id + ". No se puede convertir ID a entero", "");
				}
			}
			
			response.sendRedirect(redirect);
			
		} catch (Exception e) {
			Logger.Log(LogLevel.FATAL, e.getStackTrace()[0].toString(), e);
		}
	}

}
