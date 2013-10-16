package com.blackstar.web;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.User;

/**
 * Servlet Filter implementation class UserFilter
 */
public class UserFilter implements Filter {

    /**
     * Default constructor. 
     */
    public UserFilter() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		// place your code here
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse resp = (HttpServletResponse) response;
		User usr = (User)req.getSession().getAttribute("user");
		
		if(usr == null){
			try{
				// create the user
				com.google.appengine.api.users.UserService srv = com.google.appengine.api.users.UserServiceFactory.getUserService();
				com.google.appengine.api.users.User gUser = srv.getCurrentUser();
				
				if(gUser == null){
					req.getRequestDispatcher(srv.createLoginURL(req.getRequestURI())).forward(req, resp);;
				}
				else{
					String id = gUser.getEmail();
					String name = gUser.getNickname();
					User myUser = new User(id, name);
					req.getSession().setAttribute("user", myUser);
					
					// pass the request along the filter chain
					chain.doFilter(request, response);
				}
			}
			catch(Exception e){
				Logger.Log(LogLevel.CRITICAL, Thread.currentThread().getStackTrace()[1].toString(), e);
			}	
		}
		else{
			chain.doFilter(request, response);
		}
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
