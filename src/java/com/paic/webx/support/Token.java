package com.paic.webx.support;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

public class Token {

	private static final String TOKEN_LIST_NAME = "tokenList";

	public static final String TOKEN_STRING_NAME = "token";

	private static List<String> getTokenList(HttpSession session) {
		@SuppressWarnings("unchecked")
		List<String> list = (List<String>) session
				.getAttribute(TOKEN_LIST_NAME);
		if (list != null) {
			return list;
		} else {
			List<String> tokenList = new ArrayList<String>();
			session.setAttribute(TOKEN_LIST_NAME, tokenList);
			return tokenList;
		}
	}

	private static void saveTokenString(String tokenStr, HttpSession session) {
		List<String> tokenList = getTokenList(session);
		tokenList.add(tokenStr);
		session.setAttribute(TOKEN_LIST_NAME, tokenList);
	}

	private static String generateTokenString() {
		return new Long(System.currentTimeMillis()).toString();
	}

	public static String getTokenString(HttpSession session) {
		String tokenStr = generateTokenString();
		saveTokenString(tokenStr, session);
		return tokenStr;
	}

	public static boolean isTokenStringValid(String tokenStr,
			HttpSession session) {
		boolean valid = false;
		if (session != null) {
			List<String> tokenList = getTokenList(session);
			if (tokenList.contains(tokenStr)) {
				valid = true;
				tokenList.remove(tokenStr);
			}
		}
		return valid;
	}
}
