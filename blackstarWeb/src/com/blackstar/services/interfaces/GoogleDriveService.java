package com.blackstar.services.interfaces;

public interface GoogleDriveService {
	
  public String getAttachmentFolderId(Integer serviceOrderId) throws Exception;
  public String getReportsFolderId(Integer serviceOrderId) throws Exception;
  public String insertFileFromStream(Integer serviceOrderId, String type
		  , String fileName, String parentId,  byte[] report) throws Exception;
  public String getAccessToken() throws Exception;

}
