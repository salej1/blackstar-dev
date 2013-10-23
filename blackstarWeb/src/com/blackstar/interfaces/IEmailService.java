package com.blackstar.interfaces;

public interface IEmailService {
	void sendEmail(String from, String to, String subject, String body);
}
