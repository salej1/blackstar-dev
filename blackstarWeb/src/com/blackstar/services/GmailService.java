package com.blackstar.services;

import com.blackstar.interfaces.IEmailService;

import java.io.ByteArrayInputStream;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.util.ByteArrayDataSource;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;

public class GmailService implements IEmailService{

	private JavaMailSenderImpl  mailSender;
	
	public void setMailSender(JavaMailSenderImpl mailSender) {
		this.mailSender = mailSender;
	}

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
	
	
  @Override
  public void sendEmail(final String to, final String subject, final String body,
	                           final String attachmentName, final byte[] file) {
    try {
		 mailSender.send(new MimeMessagePreparator() {
			public void prepare(MimeMessage mimeMessage) throws Exception {
			  MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);
			  if(attachmentName != null && file != null){
		        helper.addAttachment(attachmentName, new ByteArrayResource(file));
			  }
			  helper.setTo(to);
			  helper.setSubject(subject);
			  helper.setText(body);
			} 
		 });
    } catch (Exception e) {
		throw new RuntimeException(e);
	}
  }

}
