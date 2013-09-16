package com.paic.webx.handler.impl;

import java.sql.Date;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.processors.JsDateJsonBeanProcessor;
import net.sf.json.processors.JsonBeanProcessor;

public class MyJsDateJsonBeanProcessor extends JsDateJsonBeanProcessor
		implements JsonBeanProcessor {

	public JSONObject processBean(Object obj, JsonConfig conf) {
		Date date = (Date) obj;
		JSONObject r = new JSONObject();
		r.put("time", date.getTime() + "");
		return r;
	}

}
