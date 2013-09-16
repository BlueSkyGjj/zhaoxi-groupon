package org.dy.thirdpart.sae;

import java.util.Properties;

import com.paic.webx.core.AppConf;

public class SaeConf {
	private static Properties prop = AppConf.load("/saeapp.properties");

	public static String c(String key) {
		return prop.getProperty(key);
	}

	public static String getDomain() {
		return c("domain");
	}
}
