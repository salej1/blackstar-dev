package com.blackstar.services.impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URISyntaxException;
import java.security.GeneralSecurityException;
import java.util.Arrays;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.googleapis.extensions.appengine.auth.oauth2.AppIdentityCredential;
import com.google.api.client.googleapis.services.CommonGoogleClientRequestInitializer;
import com.google.api.client.googleapis.services.GoogleClientRequestInitializer;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson.JacksonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.DriveScopes;
import com.google.api.services.drive.Drive.Files;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.FileList;
import com.google.api.services.drive.model.ParentReference;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.GoogleDriveService;

public class GoogleDriveServiceImpl extends AbstractService 
                                    implements GoogleDriveService {
	
  public GoogleDriveServiceImpl(){  
  }
  
  public String getAttachmentFolderId(Integer serviceOrderId) throws Exception {
	String osAttachmentFolderId = null; 
	osAttachmentFolderId = getFolderId("os_attachment", "root", true);
	osAttachmentFolderId = getFolderId("os_" + serviceOrderId, osAttachmentFolderId, true);			
	return osAttachmentFolderId;
  }	
  
  public String getFolderId(String folderName, String parentId, boolean createIfNot) 
			                                                    throws Exception {
	Files.List request = null;
	FileList files = null;
	String id = null;
	StringBuilder criteria = new StringBuilder().append("title='").append(folderName).append("'")
			                           .append(" and mimeType='application/vnd.google-apps.folder'")
			                           .append(" and '").append(parentId).append("' in parents")
			                           .append(" and trashed = false"); 
	try {
		 request = getDriveService().files().list();
		 request.setQ(criteria.toString());
		 files = request.execute();
		 if(files.getItems().size() == 0){
		   if(createIfNot){
			  id = createFolder(folderName, parentId, "BlackStar System Folder");
		   }
		 } else {
			   id = files.getItems().get(0).getId();
		 }
    } catch (IOException e) {
		e.printStackTrace();
		request.setPageToken(null);
    } 
	return id;
  }
	
  public String createFolder(String title, String parentId, String description) throws Exception {
	File file = new File();
	file.setTitle(title);
	file.setDescription(description);
	file.setMimeType("application/vnd.google-apps.folder");
	file.setParents(Arrays.asList(new ParentReference().setId(parentId)));
	file = getDriveService().files().insert(file).execute();
    return file.getId();
  }
	
  private Drive getDriveService() throws GeneralSecurityException, IOException, URISyntaxException {
    HttpTransport httpTransport = new NetHttpTransport();
    JsonFactory jsonFactory = new JacksonFactory();
    AppIdentityCredential credential =new AppIdentityCredential.Builder(Arrays
    		                              .asList(DriveScopes.DRIVE)).build();
    GoogleClientRequestInitializer keyInitializer =new CommonGoogleClientRequestInitializer("");
    Drive service = new Drive.Builder(httpTransport, jsonFactory, null)
                             .setHttpRequestInitializer(credential)
                             .setGoogleClientRequestInitializer(keyInitializer)
                             .setApplicationName("salej1-blackstar-dev")
                             .build();
    return service;
  }
  

	
  
  
  
  
  
  
  
  
  
  

  
	
	/**
	 * Initialize initials attributes.
	 * 
	 * @param String basic configuration parameters.
	 */
	public GoogleDriveServiceImpl(String CLIENT_ID, String CLIENT_SECRET, String REDIRECT_URI){
		this.redirectURI=REDIRECT_URI;
		httpTransport = new NetHttpTransport();
		jsonFactory= new JacksonFactory();
		
		flow= new GoogleAuthorizationCodeFlow.Builder(
				httpTransport, jsonFactory, 
				CLIENT_ID, CLIENT_SECRET, 
				Arrays.asList(DriveScopes.DRIVE))
				.setAccessType("online")
				.setApprovalPrompt("auto").build();
	}
	
	/**
	 * Get the authorization URL for authorize the application.
	 *
	 * @return String URL for authorize the application.
	 */
	public String getURL(){
		String url = flow.newAuthorizationUrl().setRedirectUri(redirectURI).build();
		return url;
	}
	
	
	/**
	 * Set the authorization code and create the service.
	 *
	 * @param String authorization code.
	 */
	public void setCode(String code) throws IOException{
		GoogleTokenResponse response = flow.newTokenRequest(code).setRedirectUri(redirectURI).execute();
		GoogleCredential credential = new GoogleCredential().setFromTokenResponse(response);

		//Create a new authorized API client
		service = new Drive.Builder(httpTransport, jsonFactory, credential).build();
	}
	
	
	
	private static final String CLIENT_ID = "1045304195726.apps.googleusercontent.com";
	private static final String CLIENT_SECRET = "r7j-DfVgASWZoj6vwV0MOAw-";
	private static final String REDIRECT_URI = "urn:ietf:wg:oauth:2.0:oob";
	private String redirectURI;
	HttpTransport httpTransport;
	JsonFactory jsonFactory;
	GoogleAuthorizationCodeFlow flow;
	Drive service;
	
	private static GoogleDriveServiceImpl gd;
	
	public static void main(String[] args) throws Exception{
		// Para permitir a nuestra aplicacion conectarse con nuestro google drive
		// primero tenemos que autorizarla abriendo una url en el navegador, darle
		// a permitir y copiar y pegar el codigo de autorizacion en la aplicacion
		gd=new GoogleDriveServiceImpl(CLIENT_ID, CLIENT_SECRET, REDIRECT_URI);
		
		System.out.println("Abre la siguiente URL en tu navegador:");
		System.out.println(" " + gd.getURL());
		System.out.println("Escribe el codigo de autorizacion:");
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		String code = br.readLine();
		gd.setCode(code);
		gd.getFolderId("os_attachment", "root", true);
		
	}
	
}
