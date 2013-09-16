package com.paic.webx.tool;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;

public class LManager {

	private static Logger getLogger(String str) {
		return LogManager.getLogger(str);
	}

	// 根据约定制定几个相对固定的logger
	// refer log4j.properties in classpath
	public static Logger ltrace() {
		return getLogger("ltrace");
	}

	public static Logger lprofiling() {
		return getLogger("lprofiling");
	}

	// define your logger here
}