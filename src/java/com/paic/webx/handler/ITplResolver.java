package com.paic.webx.handler;

import java.io.Writer;
import java.util.Map;

import javax.servlet.ServletContext;

public interface ITplResolver {
	void init(ServletContext context, String contextPath) throws TplException;

	void out(Map<String, Object> map, Writer out, String fileName)
			throws TplException;

	String getSuf();
}
