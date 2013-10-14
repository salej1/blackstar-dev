package com.blackstar.web;

import static org.junit.Assert.assertEquals;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.junit.Test;

import com.blackstar.interfaces.IUserService;
import com.blackstar.services.GoogleUserService;
import com.blackstar.services.UserServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.utils.SystemProperty;

/**
 * Servlet implementation class diagnostics
 */
public class diagnostics extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public diagnostics() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Pruebas de usuario
		try{
		IUserService s = UserServiceFactory.getUserService();
		
		request.setAttribute("userId", s.getCurrentUserId());
		request.setAttribute("userName", s.getCurrentUserName());
		request.setAttribute("userGroups", s.getCurrentUserGroups());
		request.setAttribute("employeeList", s.getEmployeeList());
		
		request.getRequestDispatcher("/diagnostics.jsp").forward(request, response);
		}catch(Exception ex){
			request.setAttribute("error", ex.getMessage());
		}
	}
	
	public final void testGetCurrentUserId() {
		GoogleUserService target = new GoogleUserService();
		
		java.lang.String uid = target.getCurrentUserId();
		assertEquals("sergio.aga@gmail.com", uid);
	}

	public final void testGetCurrentUserName() {
		GoogleUserService target = new GoogleUserService();
		
		java.lang.String name = target.getCurrentUserName();
		assertEquals("sergio.aga", name);
	}

}
