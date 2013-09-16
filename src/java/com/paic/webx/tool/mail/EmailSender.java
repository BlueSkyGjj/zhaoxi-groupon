package com.paic.webx.tool.mail;

import javax.activation.CommandMap;
import javax.activation.MailcapCommandMap;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;

import com.paic.webx.core.AppContext;

public class EmailSender {

	public static void send(String from, String title, String content, String[] toList) throws MessagingException {
		MailcapCommandMap mc = (MailcapCommandMap) CommandMap.getDefaultCommandMap();
        mc.addMailcap("text/html;; x-java-content-handler=com.sun.mail.handlers.text_html");
        mc.addMailcap("text/xml;; x-java-content-handler=com.sun.mail.handlers.text_xml");
        mc.addMailcap("text/plain;; x-java-content-handler=com.sun.mail.handlers.text_plain");
        mc.addMailcap("multipart/*;; x-java-content-handler=com.sun.mail.handlers.multipart_mixed");
        mc.addMailcap("message/rfc822;; x-java-content-handler=com.sun.mail.handlers.message_rfc822");
        CommandMap.setDefaultCommandMap(mc);
		
		ClassPathXmlApplicationContext context = AppContext.getContext();
		JavaMailSender sender = (JavaMailSender) context.getBean("mailSender");
		
		 MimeMessage msg = sender.createMimeMessage();  
		 MimeMessageHelper message = new MimeMessageHelper(msg, true, "UTF-8");  
		 
         message.setFrom(from);  
         message.setSubject(title);  
         message.setTo(toList);
		 message.setText(content, true);  
         
         sender.send(msg);
	}
}
