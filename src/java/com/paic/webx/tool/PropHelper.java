package com.paic.webx.tool;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.Iterator;
import java.util.Properties;

import org.apache.log4j.Logger;

public class PropHelper {

	private static Logger log = Logger.getLogger(PropHelper.class);

	public static final int SCOPE_CP = 0;
	public static final int SCOPE_ABS = 1;

	private static final String ENCODING = "utf-8";

	public static Properties loadProperties(String name, int scope) {
		// MBProperties prop = new MBProperties();
		Properties prop = new Properties();

		try {
			switch (scope) {
			case SCOPE_CP:
				// src/my.properties <- name = my.properties
				prop.load(new InputStreamReader(PropHelper.class
						.getResourceAsStream(name), ENCODING));
				// prop.load(PropHelper.class.getResourceAsStream(name),
				// ENCODING);
				break;
			default:
				File f = new File(name);
				if (f.exists()) {
					if (f.isFile()) {
						prop.load(new InputStreamReader(new FileInputStream(f),
								ENCODING));
						// prop.load(new FileInputStream(f), ENCODING);
					} else {
						File[] fl = f.listFiles();
						for (int i = 0; i < fl.length; i++) {
							File sf = fl[i];
							prop.putAll(loadProperties(sf.getAbsolutePath(),
									SCOPE_ABS));
						}
					}
				}
				break;
			}
		} catch (Exception e) {
			log.error("Try load properties failed : " + e.getMessage(), e);
		}
		return prop;
	}

	public static Properties loadProperties(String name) {
		return loadProperties(name, SCOPE_CP);
	}

	public static Properties loadProperties(String name, String pre, int scope) {
		Properties prop = loadProperties(name, scope);
		Properties rprop = new Properties();

		Iterator<?> it = prop.keySet().iterator();
		while (it.hasNext()) {
			String rkey = (String) it.next();
			if (rkey.startsWith(pre)) {
				rprop.put(rkey.substring(pre.length()), prop.get(rkey));
			}
		}
		return rprop;
	}

	public static String getProperty(String propName, String key,
			String defaultValue, int scope) {
		String v = loadProperties(propName, scope).getProperty(key);
		return v == null ? defaultValue : v;
	}
}
