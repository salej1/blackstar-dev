package com.blackstar.services;

import com.blackstar.common.Globals;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;

public class GmailService implements IEmailService{

	private JavaMailSenderImpl  mailSender;
	private String defaultFrom = Globals.GPOSAC_DEFAULT_SENDER;
	
	public void setDefaultFrom(String defaultFrom) {
		this.defaultFrom = defaultFrom;
	}

	public void setMailSender(JavaMailSenderImpl mailSender) {
		this.mailSender = mailSender;
	}

	@Override
	public void sendEmail(String from, String toList, String subject, String body) {
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");

		Session session = Session.getInstance(props, null);
 
		try {
 
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(defaultFrom));
			
			// Filter out spaces
			toList = toList.replace(" ", "");
			message.setRecipients(Message.RecipientType.TO,  InternetAddress.parse(toList));		
			message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "Q"));
			Multipart mp = new MimeMultipart();
	        MimeBodyPart htmlPart = new MimeBodyPart();
	        htmlPart.setContent(body, "text/html; charset=utf-8");
	        mp.addBodyPart(htmlPart);
			message.setContent(mp);
			
			Transport.send(message);
			
		} 
		catch (Exception e) 
		{
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			//throw new RuntimeException(e);
		}
	}
		
	@Override
	public void sendEmail(String to, final String subject, final String body,
			final String attachmentName, final byte[] file) {
		try {
			final String toList = to.replace(" ", "");
			mailSender.send(new MimeMessagePreparator() {
				public void prepare(MimeMessage mimeMessage) throws Exception {
					MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
					if(attachmentName != null && file != null){
						helper.addAttachment(attachmentName, new ByteArrayResource(file));
					}
					
					helper.setTo(InternetAddress.parse(toList));
					helper.setFrom(defaultFrom);
					helper.setSubject(subject);
					helper.setText(body);
				} 
			});
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			e.printStackTrace();
			//throw new RuntimeException(e);
		}
	}
}
