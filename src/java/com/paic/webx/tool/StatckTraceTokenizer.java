package com.paic.webx.tool;

public class StatckTraceTokenizer {
	private static String token(StackTraceElement el) {
		return null;
	}

	public static String[] tokenEx(Exception ex, String pat) {
		StackTraceElement[] arr = ex.getStackTrace();
		String[] r = new String[arr.length];
		for (int i = 0; i < arr.length; i++) {
			r[i] = token(arr[i]);
		}
		return r;
	}
}
