package com.paic.webx.handler;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface IActionResultHandler {
	void init(ServletContext context) throws ServletException;

	void process(Map<String, Object> map, HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException;

	void warn(String str, HttpServletRequest request,
			HttpServletResponse response);
}
