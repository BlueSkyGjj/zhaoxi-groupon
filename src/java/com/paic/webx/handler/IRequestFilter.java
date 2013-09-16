package com.paic.webx.handler;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface IRequestFilter {
	String getName();

	Map<String, Object> preHandle(Map<String, Object> map,
			HttpServletRequest request, HttpServletResponse response);

	void afterHandle(Map<String, Object> map, HttpServletRequest request,
			HttpServletResponse response);
}
