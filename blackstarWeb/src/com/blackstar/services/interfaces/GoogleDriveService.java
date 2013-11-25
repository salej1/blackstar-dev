package com.blackstar.services.interfaces;

import com.google.api.client.auth.oauth2.Credential;

public interface GoogleDriveService {
	
  public String getAttachmentFolderId(Integer serviceOrderId, Credential credential) throws Exception;

}
