package com.blackstar.common;

public class StringUtils {
	
  public static String notNull(String input){
	if(input == null){
		return "";
	}
	return input;
  }
  
  public static String leftPad(String sValue, int iMinLength) {

      StringBuilder sb = new StringBuilder(iMinLength);
      sb.append(sValue);

      while (sb.length() < iMinLength) {

          sb.append(" ");

      }

      return sb.toString();

  }

  public static String rightPad(String sValue, int iMinLength) {

      StringBuilder sb = new StringBuilder(iMinLength);
      sb.append(sValue);

      while (sb.length() < iMinLength) {

          sb.insert(0, " ");

      }

      return sb.toString();

  }

  public static String centerPad(String sValue, int iMinLength) {

      if (sValue.length() < iMinLength) {

          int length = sValue.length();
          int left = (iMinLength - sValue.length()) / 2;
          int right = iMinLength - sValue.length() - left;

          StringBuilder sb = new StringBuilder(sValue);
          for (int index = 0; index < left; index++) {
              sb.insert(0, " ");
          }
          for (int index = 0; index < right; index++) {
              sb.append(" ");
          }

          sValue = sb.toString();

      }

      return sValue;

  }

  public static String justifyPad(String sValue, int iMinLength) {

      if (sValue.length() < iMinLength) {

          int length = sValue.length();
          int left = (iMinLength - sValue.length()) / 2;
          int right = iMinLength - sValue.length() - left;

          StringBuilder sb = new StringBuilder(sValue);
          for (int index = 0; index < left; index++) {
              sb.insert(0, " ");
          }
          for (int index = 0; index < right; index++) {
              sb.append(" ");
          }

          sValue = sb.toString();

      }

      return sValue;

  }
}
