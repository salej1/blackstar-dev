package com.blackstar.logging;

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
		WriteToLog(level.toString(), who, message, stackTrace);
	}
	
	private static void WriteToLog(String level, String who, String message, String stackTrace){
		// TODO: mapear a objeto ORM ErrorLog y guardar
	}
}


