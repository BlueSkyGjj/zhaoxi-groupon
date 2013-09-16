package com.paic.webx.handler.impl;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import com.paic.webx.handler.IJsonResolver;

public class DefaultJsonResolver implements IJsonResolver {
	JsonConfig config = new JsonConfig();

	public String toJsonString(Object r) {
		return JSONObject.fromObject(r, config).toString();
	}

	public void init() {
		config.registerJsonBeanProcessor(java.sql.Date.class,
				new MyJsDateJsonBeanProcessor());
	}

	public Object fromString(String str) {
		return JSONObject.fromObject(str);
	}

}
