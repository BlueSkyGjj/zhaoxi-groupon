package com.paic.webx.core;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import com.paic.webx.tool.PropHelper;

public class AppConf {

	private static Properties props = null;

	private static Map<String, Properties> propsExt = new HashMap<String, Properties>();

	private static final String APP_FILE_NAME = "/webx-app.properties";
	private static final String CONF_FILE_NAME = "/conf.properties";

	static {
		reload();
	}

	public static void reload() {
		props = PropHelper.loadProperties(APP_FILE_NAME, PropHelper.SCOPE_CP);
		propsExt.clear();
	}

	public static String c(String key) {
		return props.getProperty(key);
	}

	public static int ci(String key) {
		String str = c(key);
		return str != null ? Integer.parseInt(str) : -1;
	}

	public static Properties load(String ext) {
		Properties props2 = (Properties) propsExt.get(ext);
		if (props2 == null) {
			props2 = PropHelper.loadProperties(ext, PropHelper.SCOPE_CP);
			propsExt.put(ext, props2);
		}
		return props2;
	}

	public static Properties loadConf() {
		return load(CONF_FILE_NAME);
	}
}
