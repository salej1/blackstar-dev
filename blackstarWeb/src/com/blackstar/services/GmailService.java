package com.blackstar.services;

import com.blackstar.interfaces.IEmailService;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class GmailService implements IEmailService{

	@Override
	public void sendEmail(String from, String to, String subject, String body) {
 
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
 
		Session session = Session.getInstance(props, null);
 
		try {
 
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(from));
			message.setRecipients(Message.RecipientType.TO,
				InternetAddress.parse(to));
			message.setSubject(subject);
			message.setText(body);
			
			Transport.send(message);
 
		} 
		catch (MessagingException e) 
		{
			throw new RuntimeException(e);
		}
		catch (Exception e) 
		{
			throw new RuntimeException(e);
		}
	}

}
