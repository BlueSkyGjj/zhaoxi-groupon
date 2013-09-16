package com.paic.webx.handler.impl;

import java.io.IOException;
import java.io.Writer;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletContext;

import org.lilystudio.smarty4j.Context;
import org.lilystudio.smarty4j.Engine;
import org.lilystudio.smarty4j.Template;
import org.lilystudio.smarty4j.TemplateException;

import com.paic.webx.handler.ITplResolver;
import com.paic.webx.handler.TplException;
import com.paic.webx.tool.PropHelper;

public class Smarty4jTplResolver implements ITplResolver {

	static Engine engine = new Engine();

	static final String encoding = "utf-8";
	static final String CONF_FILE_NAME = "/tpl.properties";

	public void init(ServletContext context, String contextPath)
			throws TplException {
		String templatePath = context.getRealPath(contextPath);
//		if(templatePath != null && !templatePath.endsWith("/"))
//			templatePath += "/";
		
		engine.setTemplatePath(templatePath);

		Properties props = PropHelper.loadProperties(CONF_FILE_NAME);

		engine.setDebug("true".equals(props.get("debug")));

		String en = (String) props.get("encoding");
		engine.setEncoding(en == null ? encoding : en);
	}

	public void out(Map<String, Object> map, Writer out, String fileName)
			throws TplException {
		try {
			Template template = engine.getTemplate(fileName);
			Context ctx = new Context();
			ctx.putAll(map);
			template.merge(ctx, out);
		} catch (IOException e) {
			throw new TplException(e);
		} catch (TemplateException e) {
			throw new TplException(e);
		}
	}

	@Override
	public String getSuf() {
		return ".tpl";
	}

}
