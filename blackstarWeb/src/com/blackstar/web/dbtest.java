package com.blackstar.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.utils.SystemProperty;
import com.google.cloud.sql.jdbc.Connection;
import com.google.cloud.sql.jdbc.ResultSet;

import java.sql.DriverManager;
import java.sql.SQLException;




/**
 * Servlet implementation class dbtest
 */
public class dbtest extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public dbtest() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		int count;
		Connection conn = null;
		try {
			
			String url = null;
			if (SystemProperty.environment.value() ==
			    SystemProperty.Environment.Value.Production) {
			  // Load the class that provides the new "jdbc:google:mysql://" prefix.
			  Class.forName("com.mysql.jdbc.GoogleDriver");
			  url = "jdbc:google:rdbms://salej1-blackstar-dev:salej1-blackstar-dev/blackstarDb";
			  conn =  (Connection) DriverManager.getConnection(url);
			} else {
			  // Local MySQL instance to use during development.
			  Class.forName("com.mysql.jdbc.Driver");
			  url = "jdbc:mysql://localhost:3306/blackstarDb";
			  conn =  (Connection) DriverManager.getConnection(url, "root", "");
			}

			ResultSet rs = conn.createStatement().executeQuery(
			    "SELECT * from policy;");
			count = 0;
			while(rs.next()){
				count++;
			}
			conn.close();
			response.getWriter().print(String.format("%d Records returned from Policy", count));
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			response.getWriter().print("ClassNotFoundException > " + e.getMessage());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			response.getWriter().print("SQLException" + e.getMessage());
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
