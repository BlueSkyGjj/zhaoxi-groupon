package com.paic.webx.core;

public class AppPath {
	// it sucks as weblogic hot deploy donot trigger AppContextListener
	public static String WAR_NAME = "/webx-core";
	public static String WAR_DIR = "/webx-core/";

	public static String GROOVY_DIR_WAR = "/WEB-INF/classes/";

	public static void setWarInfo(String name, String dir) {
		WAR_NAME = name;
		WAR_DIR = dir;
	}

	public static String getWarPath(String str) {
		if (str != null && str.startsWith("/") && WAR_DIR != null
				&& WAR_DIR.endsWith("/"))
			str = str.substring(1);

		return WAR_DIR + str;
	}

	public static String getAppClassPath() {
		return getWarPath(GROOVY_DIR_WAR);
	}
}
