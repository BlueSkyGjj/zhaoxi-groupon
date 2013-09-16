package com.paic.webx.core;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import org.springframework.beans.BeansException;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.paic.webx.core.executer.GroovyBizLocal;

public class AppContext {
	private static final Logger log = Logger.getLogger(AppContext.class);

	private static final String CONTEXT_CONFIG_FILE = "classpath:webx-context.xml";

	private static final String GROOVY_EXE_BEAN = "groovyExecutor";

	private static Map<String, ClassPathXmlApplicationContext> instances = new HashMap<String, ClassPathXmlApplicationContext>();

	public static ClassPathXmlApplicationContext getContext(String config) {
		ClassPathXmlApplicationContext context = (ClassPathXmlApplicationContext) instances
				.get(config);
		if (context == null) {
			synchronized (instances) {
				if (context == null) {
					try {
						String[] configs = config.split(",");
						context = new ClassPathXmlApplicationContext(configs);
						log.info("Initialize bean context ok : " + config);
						instances.put(config, context);
					} catch (BeansException e) {
						log.error("Initialize bean context error : ", e);
					}
				}
			}
		}
		return context;
	}

	public static ClassPathXmlApplicationContext getContext() {
		String configFile = AppConf.c("web_context_config");
		return getContext(configFile != null ? configFile : CONTEXT_CONFIG_FILE);
	}

	public static GroovyBizLocal getGroovyExecutor() {
		ClassPathXmlApplicationContext context = getContext();
		return context == null ? null : (GroovyBizLocal) context
				.getBean(GROOVY_EXE_BEAN);
	}

	public static void clear() {
		instances.clear();
	}

}
