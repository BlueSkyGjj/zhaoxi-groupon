package com.paic.webx.tool;

import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class CharsetTools {
	CharsetEncoder encoder;
	private static Map<String, CharsetTools> instances = Collections
			.synchronizedMap(new HashMap<String, CharsetTools>());

	private CharsetTools(String encoding) {
		this.encoder = Charset.forName(encoding).newEncoder();
	}

	public static CharsetTools getInstance(String encoding) {
		CharsetTools one = instances.get(encoding);
		if (one == null) {
			one = new CharsetTools(encoding);
			instances.put(encoding, one);
		}
		return one;
	}

	public boolean check(String target) {
		if (target == null)
			return true;

		return encoder.canEncode(target);
	}
}
