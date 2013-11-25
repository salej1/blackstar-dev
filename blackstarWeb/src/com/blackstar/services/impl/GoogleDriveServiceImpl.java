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
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.GoogleDriveService;

public class GoogleDriveServiceImpl extends AbstractService 
                                    implements GoogleDriveService {
	
  private static final HttpTransport TRANSPORT = new NetHttpTransport();
  private static final JsonFactory JSON_FACTORY = new JacksonFactory();

  public GoogleDriveServiceImpl(){  
  }
  
  public String getAttachmentFolderId(Integer serviceOrderId, Credential credential) throws Exception {
	String osAttachmentFolderId = null; 
	osAttachmentFolderId = getFolderId("os_attachment", null, true, credential);
	osAttachmentFolderId = getFolderId("os_" + serviceOrderId, osAttachmentFolderId, true, credential);			
	return osAttachmentFolderId;
  }	
  
  public String getFolderId(String folderName, String parentId, boolean createIfNot, Credential credential) 
			                                                    throws Exception {
	Files.List request = null;
	FileList files = null;
	String id = null;
	Drive service = new Drive.Builder(TRANSPORT, JSON_FACTORY, credential).build();
	StringBuilder criteria = new StringBuilder().append("title='").append(folderName).append("'")
			                           .append(" and mimeType='application/vnd.google-apps.folder'")
			                           .append(" and trashed = false");
    if(parentId != null){
    	criteria.append(" and '").append(parentId).append("' in parents");
    }			                           
	request = service.files().list();
	request.setQ(criteria.toString());
	files = request.execute();
	if(files.getItems().size() == 0){
	  if(createIfNot){
	    id = createFolder(folderName, parentId, "BlackStar System Folder", credential);
	  }
    } else {
		id = files.getItems().get(0).getId();
    }
	return id;
  }
	
  public String createFolder(String title, String parentId, String description, Credential credential) throws Exception {
	File file = new File();
	Drive service = new Drive.Builder(TRANSPORT, JSON_FACTORY, credential).build();
	file.setTitle(title);
	file.setDescription(description);
	file.setMimeType("application/vnd.google-apps.folder");
	if(parentId != null){
	  file.setParents(Arrays.asList(new ParentReference().setId(parentId)));
	}
	file = service.files().insert(file).execute();
    return file.getId();
  }
	
}
