package com.blackstar.web;
import java.io.IOException;
import javax.servlet.http.*;

@SuppressWarnings("serial")
public class BlackstarWebServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		resp.setContentType("text/plain");
		resp.getWriter().println("ora perro");
	}
}
