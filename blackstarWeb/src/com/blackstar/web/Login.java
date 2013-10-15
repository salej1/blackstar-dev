package com.blackstar.web;

import com.blackstar.model.User;
import com.blackstar.common.*;
import com.google.api.client.auth.oauth2.AuthorizationCodeFlow;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.appengine.auth.oauth2.AbstractAppEngineAuthorizationCodeServlet;
import com.google.api.services.admin.directory.Directory;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Login
 */

/**
 * Entry servlet for the Admin Directory API App Engine Sample.
 * Demonstrates how to make an authenticated API call using OAuth 2 helper classes.
 */
public class Login
    extends AbstractAppEngineAuthorizationCodeServlet {

  /**
   * Be sure to specify the name of your application. If the application name is {@code null} or
   * blank, the application will log a warning. Suggested format is "MyCompany-ProductName/1.0".
   */
  private static final String APPLICATION_NAME = "salej1-blackstar-dev";

  private static final long serialVersionUID = 1L;

  @Override
  public void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws IOException, ServletException {
    // Get the stored credentials using the Authorization Flow
    AuthorizationCodeFlow authFlow = initializeFlow();
    Credential credential = authFlow.loadCredential(getUserId(req));
    // Build the Directory object using the credentials
    @SuppressWarnings("unused")
    Directory admin = new Directory.Builder(
        Utils.HTTP_TRANSPORT, Utils.JSON_FACTORY, credential)
        .setApplicationName(APPLICATION_NAME)
        .build();

    
    // Add the code to make an API call here.
    UserService userService = UserServiceFactory.getUserService();
    
    User usr = new User(userService.getCurrentUser().getEmail(), userService.getCurrentUser().getNickname());
    		
    req.setAttribute("user", usr);
    req.setAttribute("access_token", credential.getAccessToken());

     // Send the results as the response
    req.getRequestDispatcher("/dashboard").forward(req, resp);
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

