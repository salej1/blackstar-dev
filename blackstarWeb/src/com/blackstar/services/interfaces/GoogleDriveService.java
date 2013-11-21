package com.blackstar.services.interfaces;

public interface GoogleDriveService {
	
  public String getFolderId(String folderName, String parentId, boolean createIfNot) throws Exception;
  public String createFolder(String title, String parentId, String description) throws Exception;
  public String getAttachmentFolderId(Integer serviceOrderId) throws Exception;

}
