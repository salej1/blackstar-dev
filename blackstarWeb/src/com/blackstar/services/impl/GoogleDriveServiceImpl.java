package com.blackstar.services.impl;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson.JacksonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.Drive.Files;
import com.google.api.services.drive.DriveScopes;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.FileList;
import com.google.api.services.drive.model.ParentReference;
import com.google.api.services.drive.model.Permission;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.GoogleDriveService;

public class GoogleDriveServiceImpl extends AbstractService implements GoogleDriveService {
	
  public static final String FOLDER_FILE_TYPE = "application/vnd.google-apps.folder";
  
  private static  Map<String, String> sysFolderIds = new HashMap<String, String>();
  private static Drive drive = null;
  private static GoogleCredential credential = null;

  static {
	String folderId = null;
	try {
	     setDriveService();
	     folderId = getFolderId("os_attachment", null);
	 	 if(folderId == null){
	 	   folderId = createFile("os_attachment", null , FOLDER_FILE_TYPE);
	 	   setPermissions(folderId);
	 	 } 	
	 	 sysFolderIds.put("OS_ATTACHMENTS", folderId);
	} catch(Exception e){
		e.printStackTrace();
	}
	
  }
  
  public GoogleDriveServiceImpl(){  
  }
  
  public static void setDriveService() throws Exception {
    HttpTransport httpTransport = new NetHttpTransport();
    JacksonFactory jsonFactory = new JacksonFactory();
    credential = new GoogleCredential.Builder()
                     .setTransport(httpTransport)
                     .setJsonFactory(jsonFactory)
                     .setServiceAccountId("1045304195726-4bscobcnja1npkifsseorp02rdb1casf@developer.gserviceaccount.com")
                     .setServiceAccountScopes(Arrays.asList(DriveScopes.DRIVE))
                     .setServiceAccountPrivateKeyFromP12File(new java.io.File(GoogleDriveServiceImpl
                    		 .class.getClassLoader().getResource("auth/serviceKey.p12").getPath()))
                     .setServiceAccountUser("admin@somnustechnologies.com.mx")
                     .build();
    credential.refreshToken();
    credential.getAccessToken();
    drive = new Drive.Builder(httpTransport, jsonFactory, null)
            .setHttpRequestInitializer(credential).build();
  }

  public String getAttachmentFolderId(Integer serviceOrderId) throws Exception {
	String osAttachmentFolderId = null; 
	osAttachmentFolderId = getFolderId("os_" + serviceOrderId, sysFolderIds.get("OS_ATTACHMENTS"));		
	if(osAttachmentFolderId == null){
	  osAttachmentFolderId = createFile("os_" + serviceOrderId , sysFolderIds.get("OS_ATTACHMENTS") 
			                                                                   , FOLDER_FILE_TYPE);
	  setPermissions(osAttachmentFolderId);
	}
	return osAttachmentFolderId;
  }	
  
  public String getAccessToken() throws Exception {
	credential.refreshToken();
	return credential.getAccessToken();
  }
  
  private static void setPermissions(String fileId) throws Exception{
	Permission p = new Permission();
	p.setRole("owner");
	p.setType("user");
	p.setValue("admin@somnustechnologies.com.mx");
	drive.permissions().insert(fileId, p).execute();
	p = new Permission();
	p.setRole("writer");
	p.setType("domain");
	p.setValue("somnustechnologies.com.mx");
	drive.permissions().insert(fileId, p).execute();
  }
  
  public static String getFolderId(String folderName, String parentId) throws Exception {
	Files.List request = null;
	FileList files = null;
	String id = null;
	StringBuilder criteria = new StringBuilder().append("title='").append(folderName).append("'")
			                           .append(" and mimeType='application/vnd.google-apps.folder'")
			                           .append(" and trashed = false");
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
	
  public static String createFile(String title, String parentId, String type) throws Exception {
	File file = new File();
	file.setTitle(title);
	file.setMimeType(type);
	if(parentId != null){
	  file.setParents(Arrays.asList(new ParentReference().setId(parentId)));
	}
	file = drive.files().insert(file).execute();
    return file.getId();
  }
	
}
