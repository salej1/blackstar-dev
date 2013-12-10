package com.blackstar.web;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.blackstar.common.Globals;
import com.blackstar.model.User;
import com.blackstar.services.impl.UserServiceImpl;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

/**
 * Servlet Filter implementation class UserFilter
 */
public class UserFilter implements Filter {
	private com.blackstar.interfaces.IUserService userService = new UserServiceImpl();

	public void setUserService(com.blackstar.interfaces.IUserService userService) {
		this.userService = userService;
	}
	
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
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse resp = (HttpServletResponse) response;
		User usr = (User) req.getSession().getAttribute("user");
		if(usr == null){
			// Estamos asumiendo que la configuracion google forzara al usuario a logearse
			UserService gUserService = UserServiceFactory.getUserService();
		    com.google.appengine.api.users.User gUser = gUserService.getCurrentUser();
		    
		    if(gUser == null){
		    	request.getRequestDispatcher(gUserService.createLoginURL(Globals.HOMEPAGE_URL)).forward(req, resp);
		    }
		    if(gUser != null){
		    	String id = gUser.getEmail();

		    	if(id != null && ! id.equals("")){
			    	User myUser = userService.gerUserById(id);
			    	if(myUser != null){
			    		req.getSession().setAttribute("user_id", gUser.getUserId());
			        	req.getSession().setAttribute("user", myUser);
			    	   	chain.doFilter(request, response);
			    	}
			    	else{
			    		req.getRequestDispatcher("noUser.jsp");
			    	}
		    	}
		    }
		}
		else{
			chain.doFilter(request, response);
		}
		//
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}
}
