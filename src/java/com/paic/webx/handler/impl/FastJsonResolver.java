package com.paic.webx.handler.impl;

import com.alibaba.fastjson.JSON;
import com.paic.webx.handler.IJsonResolver;

public class FastJsonResolver implements IJsonResolver {

	public String toJsonString(Object r) {
		return JSON.toJSONString(r);
	}

	public void init() {
	}

	public Object fromString(String str) {
		return JSON.parse(str);
	}

}
