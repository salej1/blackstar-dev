package com.blackstar.web;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.junit.Test;

import com.blackstar.interfaces.IUserService;
import com.blackstar.services.GmailService;
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
		PrintWriter out = response.getWriter();
		String resp = "";
		
		try{
		// Email test
		resp = testEmailSend();	
		out.println(resp);
		
		// User Id test
		resp = testGetCurrentUserId();
		out.println(resp);

		// User name test
		resp = testGetCurrentUserName();
		out.println(resp);
		
		// User groups
		resp = testGetCurrentUserGroups();
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
			target.sendEmail("sergio.aga@gmail.com", "Prueba de email", "Este es el cuerpo del mail\r\nEsta es una linea\n\r<a href='www.google.com'>Este es un link a google</a>");
			return "Email sent";
		}catch(Exception ex){
			return ex.getMessage();
		}
	}
	public String testGetCurrentUserId() {
		try {
			GoogleUserService target = new GoogleUserService();
			
			java.lang.String uid = target.getCurrentUserId();

			return "User Id: ".concat(uid);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return e.getMessage();
		}
	}

	public String testGetCurrentUserName() {
		try {
			GoogleUserService target = new GoogleUserService();
			
			java.lang.String name = target.getCurrentUserName();
			return "User Name: ".concat(name);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return e.getMessage();
		}
	}

	public String testGetCurrentUserGroups() {
		try {
			String retGroups = "User Groups";
			
			GoogleUserService target = new GoogleUserService();
			
			List<String> groups = target.getCurrentUserGroups();
			
			java.util.Iterator<String> it = groups.iterator();
			
			int counter = 0;
			while(it.hasNext()){
				counter++;
				String group = it.next();
				
				retGroups.concat(": " + group);
			}
			
			return retGroups;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return e.getMessage();
		}
	}

	public String testGetEmployeeList() {
		try {
			String retEmployees = "Employees";
			GoogleUserService target = new GoogleUserService();
			
			Map<String, String> employees = target.getEmployeeList();
			
			// Verificando emails
			Set<String> keys = employees.keySet();
			java.util.Iterator<String> kit = keys.iterator();
			
			while(kit.hasNext()){
				String key = kit.next();
				assertTrue(key.contains("@"));
				assertTrue(key.contains(".com"));
			}
			
			assertTrue(keys.size() > 5);	
			
			// Verificando nombres
			Collection<String> names = employees.values();
			java.util.Iterator<String> nit = names.iterator();
			
			while(nit.hasNext()){
				String name = nit.next();
				assertTrue(name.contains(" "));
				retEmployees.concat(": " + name);
			}
			
			assertTrue(names.size() > 5);
			
			return retEmployees;
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return e.getMessage();
		}
	}
}
