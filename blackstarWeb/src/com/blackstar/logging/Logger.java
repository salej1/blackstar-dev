package com.blackstar.logging;

import java.util.logging.Level;

import com.blackstar.db.ManageDataAccess;

public class Logger {
	public static void Log(LogLevel level, Throwable ex){
		if(ex.getCause() != null){
			Log(level, ex.getCause());
		}
		else{
			Log(level, ex.getClass().toString(), ex.getMessage(), ex.getStackTrace().toString());
		}
	}
	
	public static void Log(LogLevel level, String who, String message, String stackTrace){
		WriteToLog(level, who, message, stackTrace);
	}
	
	private static void WriteToLog(LogLevel level, String who, String message,
			String stackTrace) {

		String propLogLvl = "INFO";  //System.getProperty("AppLogLevel");
		LogLevel appLogLevel = LogLevel.INFO;
		switch (propLogLvl) {
		case "DEBUG":
			appLogLevel = LogLevel.DEBUG;
			break;
		case "INFO":
			appLogLevel = LogLevel.INFO;
			break;
		case "WARNING":
			appLogLevel = LogLevel.WARNING;
			break;
		case "ERROR":
			appLogLevel = LogLevel.ERROR;
			break;
		case "FATAL":
			appLogLevel = LogLevel.FATAL;
			break;
		case "CRITICAL":
			appLogLevel = LogLevel.CRITICAL;
			break;
		case "EMERGENCY":
			appLogLevel = LogLevel.EMERGENCY;
			break;
		}
		
		if(level.ordinal()>=appLogLevel.ordinal()){
			String sql = String.format("CALL blackstarManage.WriteLog(%s, %s, %s, %s)", level, message, who, stackTrace);
			
			try {
				ManageDataAccess.executeQuery(sql);
			} catch (Exception e) {
				// Utilizando el logger del container! no hay acceso a la BD
				java.util.logging.Logger log = java.util.logging.Logger.getLogger(ManageDataAccess.class.getName());
				log.log(Level.ALL, String.format("$s: Error: %s",who, e.getMessage()));
			}
		}
	}
}


