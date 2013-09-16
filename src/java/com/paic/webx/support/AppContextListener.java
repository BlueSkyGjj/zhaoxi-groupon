package com.paic.webx.support;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.paic.webx.core.AppConf;
import com.paic.webx.core.AppContext;
import com.paic.webx.core.AppPath;

public class AppContextListener implements ServletContextListener {

	Logger log = Logger.getLogger(AppContextListener.class);

	ClassPathXmlApplicationContext webContext = null;

	public void contextDestroyed(ServletContextEvent e) {
		if (webContext != null)
			webContext.close();
	}

	public void contextInitialized(ServletContextEvent e) {
		ServletContext context = e.getServletContext();
		String contextPath = context.getRealPath("/");

		String warName = AppConf.c("war_name");
		if (warName == null)
			warName = context.getContextPath();

		AppPath.setWarInfo(warName, contextPath.replaceAll("\\\\", "/"));
		log.info("Initialize web application context path.");
		log.info("War dir: " + AppPath.WAR_DIR);
		log.info("War name: " + AppPath.WAR_NAME);

		log.info("Initialize web application context in web container.");
		webContext = AppContext.getContext();
	}
}
