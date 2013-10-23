package com.blackstar.common;


import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.http.GenericUrl;
import com.google.api.services.admin.directory.DirectoryScopes;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

public class Utils {

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
        Globals.HTTP_TRANSPORT, Globals.JSON_FACTORY, Globals.getClientSecrets(), scopes)
        .setDataStoreFactory(Globals.DATA_STORE_FACTORY)
        .setAccessType("offline")
        .build();
  }

  public static String getRedirectUri(HttpServletRequest req) {
    GenericUrl requestUrl = new GenericUrl(req.getRequestURL().toString());
    requestUrl.setRawPath(Globals.AUTH_CALLBACK_SERVLET_PATH);
    return requestUrl.build();
  }
}