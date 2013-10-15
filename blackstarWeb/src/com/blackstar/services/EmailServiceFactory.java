package com.blackstar.services;

import com.blackstar.interfaces.IEmailService;

public class EmailServiceFactory {
	public static IEmailService getEmailService(){
		return new GmailService();
	}
}
