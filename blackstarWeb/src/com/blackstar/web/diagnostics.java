package com.blackstar.web;

import static org.junit.Assert.assertTrue;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.blackstar.model.User;
import com.blackstar.services.GmailService;
import com.blackstar.services.IUserService;
import com.blackstar.services.impl.UserServiceImpl;

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
		PrintWriter out = response.getWriter();
		String resp = "";
		
		try{
		// Email test
		resp = testEmailSend();	
		out.println(resp);
		
		// User Id test
		resp = testGetCurrentUserId((User)request.getSession().getAttribute("user"));
		out.println(resp);

		// User name test
		resp = testGetCurrentUserName((User)request.getSession().getAttribute("user"));
		out.println(resp);

		// Employee list
		resp = testGetEmployeeList();
		out.println(resp);
		
		}catch(Exception ex){
			request.setAttribute("error", ex.getMessage());
		}
	}
	
	public String testEmailSend(){
		try{
			GmailService target = new GmailService();
			target.sendEmail("sergio.aga@gmail.com", "sergio.aga@gmail.com", "Prueba de email", "Este es el cuerpo del mail\r\nEsta es una linea\n\r<a href='www.google.com'>Este es un link a google</a>");
			return "Email sent";
		}catch(Exception ex){
			return ex.getMessage();
		}
	}
	public String testGetCurrentUserId(User usr) {
		try {
			
			return "User Id: ".concat(usr.getUserEmail());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return e.getMessage();
		}
	}

	public String testGetCurrentUserName(User usr) {
		try {

			return "User Name: ".concat(usr.getUserName());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return e.getMessage();
		}
	}


	public String testGetEmployeeList() {
		try {
			String retEmployees = "Employees";
			IUserService target = new UserServiceImpl();
			
			List<User> employees = target.getEmployeeList();
			
			// Verificando emails
			java.util.Iterator<User> kit = employees.iterator();
			
			while(kit.hasNext()){
				User usr = kit.next();
				String key = usr.getUserEmail();
				assertTrue(key.contains("@"));
				assertTrue(key.contains(".com"));
				
				// Verificando nombres
				String name = usr.getUserName();
				assertTrue(name.contains(" "));
				retEmployees.concat(": " + name);
			}
			
			assertTrue(employees.size() > 5);	
			
			return retEmployees;
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return e.getMessage();
		}
	}
}
