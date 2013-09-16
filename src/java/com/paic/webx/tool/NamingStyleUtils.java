package com.paic.webx.tool;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

public class NamingStyleUtils {
	// camel <-> _
	public static String toCamel(String str) {
		if (str == null)
			return str;

		if (str.length() <= 1)
			return str.toLowerCase();

		String t = "";
		String[] arr = str.toLowerCase().split("_");
		for (int i = 0; i < arr.length; i++) {
			String cc = StringUtils.capitalize(arr[i]);
			if (i == 0)
				t += str.substring(0, 1).toLowerCase() + cc.substring(1);
			else
				t += cc;
		}
		return t;
	}

	public static String toUnderline(String str) {
		String t = "";
		str = str.substring(0, 1).toLowerCase() + str.substring(1);
		for (int i = 0; i < str.length(); i++) {
			char cc = str.charAt(i);
			if (Character.isUpperCase(cc)) {
				t += "_" + Character.toLowerCase(cc);
			} else {
				t += cc;
			}
		}
		return t;
	}

	// change GroovyRowResult -> HashMap
	public static Map<String, Object> transform(Map<String, Object> src) {
		Map<String, Object> r = new HashMap<String, Object>();
		for (Iterator<Map.Entry<String, Object>> iterator = src.entrySet()
				.iterator(); iterator.hasNext();) {
			Map.Entry<String, Object> entry = iterator.next();
			r.put(toCamel((String) entry.getKey()), entry.getValue());
		}
		return r;
	}
}
