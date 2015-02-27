package com.blackstar.services.interfaces;

public interface GoogleDriveService {
	
  public String getAttachmentFolderId(String id) throws Exception;
  public String getReportsFolderId(Integer id) throws Exception;
  public String insertFileFromStream(String type, String fileName, String parentId
		                                       ,  byte[] report) throws Exception;
  public String getAccessToken() throws Exception;
  public String getReportFileId(Integer serviceOrderId, String reportName) 
                                                          throws Exception;
  public void LoadOSFile(String osFileId, Integer serviceOrderId) throws Exception;
  public String getRootFolderId() throws Exception;
  String importFile(String srcId, String title, String parentId) throws Exception;
  
  public String getProposalFolderId(String id) throws Exception;
}
