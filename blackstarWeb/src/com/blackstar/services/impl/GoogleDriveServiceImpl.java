package com.blackstar.services.impl;

import java.util.Arrays;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson.JacksonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.Drive.Files;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.FileList;
import com.google.api.services.drive.model.ParentReference;
import com.google.api.services.drive.model.Permission;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.GoogleDriveService;

public class GoogleDriveServiceImpl extends AbstractService 
                                    implements GoogleDriveService {
	
  public static final String FOLDER_FILE_TYPE = "application/vnd.google-apps.folder";
  
  private static final HttpTransport TRANSPORT = new NetHttpTransport();
  private static final JsonFactory JSON_FACTORY = new JacksonFactory();

  public GoogleDriveServiceImpl(){  
  }
  
  public String getAttachmentFolderId(Integer serviceOrderId, Credential credential) throws Exception {
	String osAttachmentFolderId = null; 
	Drive service = new Drive.Builder(TRANSPORT, JSON_FACTORY, credential).build();
	osAttachmentFolderId = getFolderId(service, "os_attachment", null);
	if(osAttachmentFolderId == null){
	  osAttachmentFolderId = createFile(service, "os_attachment", null , FOLDER_FILE_TYPE);
	  setPermissions(service, osAttachmentFolderId);
	}
	osAttachmentFolderId = getFolderId(service, "os_" + serviceOrderId, osAttachmentFolderId);		
	if(osAttachmentFolderId == null){
	  osAttachmentFolderId = createFile(service, "os_" + serviceOrderId , null , FOLDER_FILE_TYPE);
	  setPermissions(service, osAttachmentFolderId);
	}
	return osAttachmentFolderId;
  }	
  
  
  private void setPermissions(Drive service, String fileId) throws Exception{
	Permission p = new Permission();
	p.setRole("owner");
	p.setType("user");
	p.setValue("sergio.gomez@innso.com.mx");
	service.permissions().insert(fileId, p).execute();
	p = new Permission();
	p.setRole("writer");
	p.setType("domain");
	p.setValue("innso.com.mx");
	service.permissions().insert(fileId, p).execute();
  }
  
  public String getFolderId(Drive service, String folderName, String parentId) throws Exception {
	Files.List request = null;
	FileList files = null;
	String id = null;
	StringBuilder criteria = new StringBuilder().append("title='").append(folderName).append("'")
			                           .append(" and mimeType='application/vnd.google-apps.folder'")
			                           .append(" and trashed = false");
    if(parentId != null){
    	criteria.append(" and '").append(parentId).append("' in parents");
    }			                           
	request = service.files().list();
	request.setQ(criteria.toString());
	files = request.execute();
	if(files.getItems().size() > 0){
		id = files.getItems().get(0).getId();
    }
	return id;
  }
	
  public String createFile(Drive service, String title, String parentId, String type
		                                                        ) throws Exception {
	File file = new File();
	file.setTitle(title);
	file.setMimeType(type);
	if(parentId != null){
	  file.setParents(Arrays.asList(new ParentReference().setId(parentId)));
	}
	file = service.files().insert(file).execute();
    return file.getId();
  }
	
}
