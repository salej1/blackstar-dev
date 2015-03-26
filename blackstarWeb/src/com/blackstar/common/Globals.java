package com.blackstar.common;

import java.io.IOException;
import java.io.InputStreamReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

import com.google.api.client.extensions.appengine.datastore.AppEngineDataStoreFactory;
import com.google.api.client.extensions.appengine.http.UrlFetchTransport;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.Preconditions;
import com.google.api.client.util.store.DataStoreFactory;

public class Globals {
	
	public static final String SESSION_KEY_PARAM = "uSession";
	
	  public static final String GOOGLE_DRIVER_CLASS = "com.mysql.jdbc.GoogleDriver";
	  public static final String CONNECTION_STRING_TEMPLATE = "jdbc:google:rdbms://gposac-blackstar-pro:gposac-blackstar-pro/%s";
	  public static final String DEFAULT_DRIVER_CLASS = "com.mysql.jdbc.Driver";
	  public static final String LOCAL_CONNECTION_STRING_TEMPLATE = "jdbc:mysql://localhost:3306/%s";
	  /**
	   * Global instance of the {@link DataStoreFactory}. The best practice is to make it a single
	   * globally shared instance across your application.
	   */
	  public static final AppEngineDataStoreFactory DATA_STORE_FACTORY =
	      AppEngineDataStoreFactory.getDefaultInstance();

	  public static GoogleClientSecrets clientSecrets = null;
	  public static final String MAIN_SERVLET_PATH = "/dashboard/show.do";
	  public static final String AUTH_CALLBACK_SERVLET_PATH = "/oauth2callback";
	  public static final HttpTransport HTTP_TRANSPORT = new UrlFetchTransport();
	  public static final JacksonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();

	  public static GoogleClientSecrets getClientSecrets() throws IOException {
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
	  
	  public static final String HOMEPAGE_URL = "/";
	  // User Groups
	  public static final String GROUP_SERVICE = "Implementacion y Servicio";
	  public static final String GROUP_CALL_CENTER = "Call Center";
	  public static final String GROUP_COORDINATOR = "Coordinador";
	  public static final String GROUP_CUSTOMER = "Cliente";
	  public static final String GROUP_HR = "Capital Humano";
	  public static final String GROUP_CEO = "Direccion";
	  public static final String GROUP_SALES_MANAGER = "Gerente comercial";
	  public static final String GROUP_CST= "CST";
	  public static final String GROUP_PURCHASE = "Compras";
	  public static final String GROUP_PURCHASE_MANAGER = "Jefe de Compras";
	  public static final String GROUP_INVOICING = "Facturacion";
	  
	  // time format
	  public static final String DEFAULT_TIME_ZONE = "America/Mexico_City";
	  public static final String DATE_FORMAT_PATTERN = "dd/MM/yyyy hh:mm:ss a";
	  public static final String SQL_FORMAT_PATTERN = "yyyy-MM-dd HH:mm:ss";

	  public static Date getLocalTime() throws ParseException{
		  SimpleDateFormat sdf = new SimpleDateFormat(Globals.DATE_FORMAT_PATTERN);
		  sdf.setTimeZone(TimeZone.getTimeZone(Globals.DEFAULT_TIME_ZONE));

		  SimpleDateFormat sdf2 = new SimpleDateFormat(Globals.DATE_FORMAT_PATTERN);
		  Date d = sdf2.parse(sdf.format(new Date()));
		  return d;
	  }
	  
	  public static String getLocalTimeString(){
		  SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_PATTERN);
		  sdf.setTimeZone(TimeZone.getTimeZone(DEFAULT_TIME_ZONE));
		  return sdf.format(new Date());
	  }
	  
	  public static String getLocalDateString(){
		  SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		  sdf.setTimeZone(TimeZone.getTimeZone(DEFAULT_TIME_ZONE));
		  try {
			return sdf.format(getLocalTime());
		} catch (ParseException e) {
			return sdf.format(new Date());
		}
	  }
	   
	  // Google 
	  public static final String GOOGLE_DRIVE_URL_PREFIX = "https://docs.google.com/a/gposac.com.mx/file/d/";
	  public static final String GOOGLE_DRIVE_URL_SUFIX = "/edit";
	  public static final String GOOGLE_LOGOUT_URL = "https://www.google.com/accounts/Logout";
	  public static final String GOOGLE_CONTEXT_URL = "http://gposac-blackstar-pro.appspot.com";
	  
	  // Gpo SAC
	  public static final String GPOSAC_LOGO_DEFAULT_URL = "http://www.gposac.com.mx/images/grupo-sac-logo.png";
	  public static final String GPOSAC_DEFAULT_SENDER = "portal-servicios@gposac.com.mx";
	  public static final String GPOSAC_CALL_CENTER_GROUP = "call-center@gposac.com.mx";
	  public static final String GPOSAC_QA_GROUP = "calidad@gposac.com.mx";
}
