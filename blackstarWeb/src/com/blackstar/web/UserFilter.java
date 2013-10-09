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

import com.blackstar.interfaces.IUserService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.User;
import com.blackstar.services.UserServiceFactory;

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
		User usr = (User)req.getSession().getAttribute("user");
		
		if(usr == null){
			try{
				
				IUserService dir = UserServiceFactory.getUserService();
				String uid = dir.getCurrentUserId();
				String name = dir.getCurrentUserName();
				List<String> groups = dir.getCurrentUserGroups();
				
				User myUser = new User(name, uid);
				
				Iterator<String> itr= groups.iterator();
				while(itr.hasNext()){
					myUser.addGroup(itr.next());
				}
				
				req.getSession().setAttribute("user", myUser);
			}
			catch(Exception e){
				Logger.Log(LogLevel.CRITICAL, e);
			}
		}
		// pass the request along the filter chain
		chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
