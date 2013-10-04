package com.blackstar.db;

import com.google.appengine.api.utils.SystemProperty;

public class DBConnectionString {
	private DBConnectionString(){
		
	}
	
	public static String getConnectionString(){
		String prodUrl = "jdbc:google:rdbms://salej1-blackstar-dev:salej1-blackstar-dev/blackstarDb";
		String localUrl = "jdbc:mysql://localhost:3306/blackstarDb";
		String retVal;
		
		if (SystemProperty.environment.value() ==
			    SystemProperty.Environment.Value.Production) {
			    retVal = prodUrl;
			}
		else{
			retVal = localUrl;
		}
		
		return retVal;
	}
}
