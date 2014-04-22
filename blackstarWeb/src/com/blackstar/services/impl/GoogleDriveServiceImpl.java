package com.blackstar.services.impl;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.InputStreamContent;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson.JacksonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.Drive.Files;
import com.google.api.services.drive.DriveScopes;
import com.google.api.services.drive.model.About;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.FileList;
import com.google.api.services.drive.model.ParentReference;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.GoogleDriveService;
import com.google.api.services.drive.model.Permission;

public class GoogleDriveServiceImpl extends AbstractService 
                                    implements GoogleDriveService {
	
  public static final String FOLDER_FILE_TYPE = "application/vnd.google-apps.folder";
  public static final String DOC_FILE_TYPE = "application/vnd.google-apps.document";
  
  public static final String P12_KEY_PATH = "auth/serviceKey.p12";
  
  private static  Map<String, String> sysFolderIds = new HashMap<String, String>();
  private static Drive drive = null;
  private static GoogleCredential credential = null;
  
  private String serviceAccountId = null;
  private String serviceAccountUser = null;
  
  public void setServiceAccountId(String serviceAccountId) {
	this.serviceAccountId = serviceAccountId;
  }

  public void setServiceAccountUser(String serviceAccountUser) {
	this.serviceAccountUser = serviceAccountUser;
  }

  public GoogleDriveServiceImpl(){  
  }
  
  public void init(){
	String folderId = null;
	try {
	     setDriveService();
	     folderId = getFolderId("os_attachment", null);
	 	 if(folderId == null){
	 	   folderId = insertFile("os_attachment", null , FOLDER_FILE_TYPE);
	 	   setPermissions(folderId);
	 	 } 	
	 	 sysFolderIds.put("OS_ATTACHMENTS", folderId);
	 	 folderId = getFolderId("os_reports", null);
	 	 if(folderId == null){
	 	   folderId = insertFile("os_reports", null , FOLDER_FILE_TYPE);
	 	  setPermissions(folderId);
	 	 } 
	 	sysFolderIds.put("OS_REPORTS", folderId);
	 	
	 	 About about = drive.about().get().execute(); 
	 	 folderId = about.getRootFolderId();
	 	 if(folderId != null){
	 		 sysFolderIds.put("ROOT", folderId);
	 	 } 	
	 	
	} catch(Exception e){
		e.printStackTrace();
		Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
	}
  }
  
  private void setDriveService() {
    HttpTransport httpTransport = new NetHttpTransport();
    JacksonFactory jsonFactory = new JacksonFactory();
    try {
         credential = new GoogleCredential.Builder()
             .setTransport(httpTransport)
             .setJsonFactory(jsonFactory)
             .setServiceAccountId(serviceAccountId)
             .setServiceAccountScopes(Arrays.asList(DriveScopes.DRIVE))
             .setServiceAccountPrivateKeyFromP12File(new java.io.File(getClass()
                    	 .getClassLoader().getResource(P12_KEY_PATH).getPath()))
             .setServiceAccountUser(serviceAccountUser)
             .build();
    getAccessToken();
    drive = new Drive.Builder(httpTransport, jsonFactory, null)
                .setHttpRequestInitializer(credential).build();
    } catch(Exception e){
    	e.printStackTrace();
    	Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
    }
  }

  public String getAttachmentFolderId(String id) throws Exception {
	return getSysFolderId(id, sysFolderIds.get("OS_ATTACHMENTS"));
  }	
  
  public String getReportsFolderId(Integer id) throws Exception {
	return getSysFolderId(String.valueOf(id), sysFolderIds.get("OS_REPORTS"));
  }	
  
  public String getRootFolderId() throws Exception{
	 return sysFolderIds.get("ROOT");
  }
  
  public String getSysFolderId(String id, String parentId) 
		                                          throws Exception {
	String osAttachmentFolderId = getFolderId(id, parentId);		
	if(osAttachmentFolderId == null){
	  osAttachmentFolderId = insertFile(id ,parentId , FOLDER_FILE_TYPE);
	  setPermissions(osAttachmentFolderId);
	}
	return osAttachmentFolderId;
  }	

  public String insertFileFromStream(Integer serviceOrderId, String type
		  , String fileName, String parentId,  byte[] report) throws Exception {
	File body = new File();
	body.setParents(Arrays.asList(new ParentReference()
	      .setId(getReportsFolderId(serviceOrderId))));
	body.setTitle(fileName);
	body.setMimeType(type);
	body.setFileSize((long) report.length);
	InputStreamContent mediaContent = new InputStreamContent(type,
		             new BufferedInputStream(new ByteArrayInputStream(report)));
	mediaContent.setLength(report.length);
	return drive.files().insert(body, mediaContent).execute().getId();
  }
  
  public String getAccessToken() throws Exception {
	String accessToken = null;
	if(credential != null){
	  credential.refreshToken();
	  accessToken = credential.getAccessToken();
	}
	return accessToken;
  }
  
  private void setPermissions(String fileId) throws Exception{
	Permission p = new Permission();
	p.setRole("owner");
	p.setType("user");
	p.setValue(serviceAccountUser);
	drive.permissions().insert(fileId, p).execute();
	p = new Permission();
	p.setRole("writer");
	p.setType("domain");
	p.setValue(serviceAccountUser.split("@")[1]);
	drive.permissions().insert(fileId, p).execute();
  }
  
  public String getFolderId(String folderName, String parentId) 
		                                     throws Exception {
	return getObjectId(folderName, parentId, FOLDER_FILE_TYPE);
  }
    
  public String getReportFileId(Integer serviceOrderId, String reportName) 
		                                               throws Exception {
	String parentId = getReportsFolderId(serviceOrderId);
    return getObjectId(reportName, parentId, null);
  }
  
  public String getObjectId(String name, String parentId, String type) 
                                                        throws Exception {
    Files.List request = null;
    FileList files = null;
    String id = null;
    StringBuilder criteria = new StringBuilder().append("title='")
                  .append(name).append("'").append(" and trashed = false");
    if(type != null){
    	criteria.append(" and mimeType='" + type + "'");
    }
    if(parentId != null){
      criteria.append(" and '").append(parentId).append("' in parents");
    }			                           
    request = drive.files().list();
    request.setQ(criteria.toString());
    files = request.execute();
    if(files.getItems().size() > 0){
      id = files.getItems().get(0).getId();
    }
    return id;
  }
	
  public String insertFile(String title, String parentId, String type) 
		                                                   throws Exception {
	File file = new File();
	file.setTitle(title);
	file.setMimeType(type);
	if(parentId != null){
	  file.setParents(Arrays.asList(new ParentReference().setId(parentId)));
	}
	file = drive.files().insert(file).execute();
    return file.getId();
  }
	
  public void LoadOSFile(String osFileId, Integer serviceOrderId) throws Exception{
	  File osFile = new File();
	  osFile.setTitle("ServiceOrder.pdf");
	  osFile.setParents(Arrays.asList(new ParentReference()
	  		.setId(getReportsFolderId(serviceOrderId))));
	  osFile.setMimeType( "application/pdf");
	  
	  try{
		  osFile = drive.files().copy(osFileId, osFile).execute();		  
	  }
	  catch(Exception e){
		  Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		  throw e;
	  }
  }
}
