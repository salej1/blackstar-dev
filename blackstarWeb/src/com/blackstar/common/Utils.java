package com.blackstar.common;


import com.google.api.client.extensions.appengine.datastore.AppEngineDataStoreFactory;
import com.google.api.client.extensions.appengine.http.UrlFetchTransport;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.http.GenericUrl;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.Preconditions;
import com.google.api.client.util.store.DataStoreFactory;
import com.google.api.services.admin.directory.DirectoryScopes;

import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

public class Utils {

  /**
   * Global instance of the {@link DataStoreFactory}. The best practice is to make it a single
   * globally shared instance across your application.
   */
  private static final AppEngineDataStoreFactory DATA_STORE_FACTORY =
      AppEngineDataStoreFactory.getDefaultInstance();

  private static GoogleClientSecrets clientSecrets = null;
  public static final String MAIN_SERVLET_PATH = "/dashboard";
  public static final String AUTH_CALLBACK_SERVLET_PATH = "/oauth2callback";
  public static final HttpTransport HTTP_TRANSPORT = new UrlFetchTransport();
  public static final JacksonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();

  private static GoogleClientSecrets getClientSecrets() throws IOException {
    if (clientSecrets == null) {
      clientSecrets = GoogleClientSecrets.load(JSON_FACTORY,
          new InputStreamReader(Utils.class.getResourceAsStream("/client_secrets.json")));
      Preconditions.checkArgument(!clientSecrets.getDetails().getClientId().startsWith("Enter ")
          && !clientSecrets.getDetails().getClientSecret().startsWith("Enter "),
          "Download client_secrets.json file from "
          + "https://code.google.com/apis/console/?api=admin#project:864392602951 into "
          + "src/main/resources/client_secrets.json");
    }
    return clientSecrets;
  }

  public static GoogleAuthorizationCodeFlow initializeFlow() throws IOException {
    // Ask for only the permissions you need. Asking for more permissions will reduce the number of
    // users who finish the process for giving you access to their accounts. It will also increase
    // the amount of effort you will have to spend explaining to users what you are doing with their
    // data.
    // Here we are listing all of the available scopes. You should remove scopes that you are not
    // actually using.
    Set<String> scopes = new HashSet<String>();
    scopes.add(DirectoryScopes.ADMIN_DIRECTORY_GROUP);
    scopes.add(DirectoryScopes.ADMIN_DIRECTORY_GROUP_MEMBER);
    scopes.add(DirectoryScopes.ADMIN_DIRECTORY_GROUP_MEMBER_READONLY);
    scopes.add(DirectoryScopes.ADMIN_DIRECTORY_GROUP_READONLY);
    scopes.add(DirectoryScopes.ADMIN_DIRECTORY_ORGUNIT);
    scopes.add(DirectoryScopes.ADMIN_DIRECTORY_ORGUNIT_READONLY);
    scopes.add(DirectoryScopes.ADMIN_DIRECTORY_USER);
    scopes.add(DirectoryScopes.ADMIN_DIRECTORY_USER_ALIAS);
    scopes.add(DirectoryScopes.ADMIN_DIRECTORY_USER_ALIAS_READONLY);
    scopes.add(DirectoryScopes.ADMIN_DIRECTORY_USER_READONLY);

    return new GoogleAuthorizationCodeFlow.Builder(
        HTTP_TRANSPORT, JSON_FACTORY, getClientSecrets(), scopes)
        .setDataStoreFactory(DATA_STORE_FACTORY)
        .setAccessType("offline")
        .build();
  }

  public static String getRedirectUri(HttpServletRequest req) {
    GenericUrl requestUrl = new GenericUrl(req.getRequestURL().toString());
    requestUrl.setRawPath(AUTH_CALLBACK_SERVLET_PATH);
    return requestUrl.build();
  }
}