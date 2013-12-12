package com.blackstar.common;

public class StringUtils {
	
  public static String notNull(String input){
	if(input == null){
		return "";
	}
	return input;
  }

}
