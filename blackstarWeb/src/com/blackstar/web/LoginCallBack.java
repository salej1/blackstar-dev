package com.blackstar.web;

import com.blackstar.common.*;
import com.google.api.client.auth.oauth2.AuthorizationCodeFlow;
import com.google.api.client.auth.oauth2.AuthorizationCodeResponseUrl;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.appengine.auth.oauth2.AbstractAppEngineAuthorizationCodeCallbackServlet;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class LoginCallBack
 */
public class LoginCallBack extends AbstractAppEngineAuthorizationCodeCallbackServlet {

	  private static final long serialVersionUID = 1L;

	  @Override
	  protected void onSuccess(HttpServletRequest req, HttpServletResponse resp, Credential credential)
	      throws ServletException, IOException {
	    resp.sendRedirect(Utils.MAIN_SERVLET_PATH);
	  }

	  @Override
	  protected void onError(
	      HttpServletRequest req, HttpServletResponse resp, AuthorizationCodeResponseUrl errorResponse)
	      throws ServletException, IOException {
	    String nickname = UserServiceFactory.getUserService().getCurrentUser().getNickname();
	    resp.setStatus(200);
	    resp.addHeader("Content-Type", "text/html");
	    resp.getWriter().print("<h3>" + nickname + ", why don't you want to play with me?</h3>");
	    return;
	  }

	  @Override
	  protected AuthorizationCodeFlow initializeFlow() throws ServletException, IOException {
	    return Utils.initializeFlow();
	  }

	  @Override
	  protected String getRedirectUri(HttpServletRequest req) throws ServletException, IOException {
	    return Utils.getRedirectUri(req);
	  }

	}
