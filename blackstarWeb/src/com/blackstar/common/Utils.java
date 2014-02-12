package com.blackstar.common;


import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.http.GenericUrl;
import com.google.api.services.admin.directory.DirectoryScopes;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import java.util.TimeZone;

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
  
  public static Date getCurerntDateTime(){
	  Calendar c = Calendar.getInstance(TimeZone.getTimeZone(Globals.DEFAULT_TIME_ZONE));
	  return c.getTime();
  }
  
  public static String getDateString(Date date){
	  SimpleDateFormat sdf = new SimpleDateFormat(Globals.DATE_FORMAT_PATTERN);
	  return sdf.format(date);
  }
  
  public static String noCommas(String string){
	  String retVal = string.trim();
	  retVal = retVal.replaceAll(", $", "");
	  return retVal;
  }
}