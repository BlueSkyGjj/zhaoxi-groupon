package com.paic.webx.handler.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class JsonRequestFilter extends BaseHandler {

	@Override
	void afterHandleInternal(Map<String, Object> map,
			HttpServletRequest request, HttpServletResponse response) {
		// json string
		Map<?, ?> jsonItem = (Map<?, ?>) map.get("jsonItem");
		if (jsonItem != null) {
			map.remove("jsonItem");
			map.put("jsonString", map2json(jsonItem));
		}
	}

	@Override
	Map<String, Object> preHandleInternal(Map<String, Object> rmap,
			HttpServletRequest request, HttpServletResponse response) {
		// json objects
		String str = (String) rmap.get("json");
		if (str != null)
			rmap.put("json", json2map(str));
		return rmap;
	}

	// json转换为普通的Java对象，使用递归
	private Object jsonTransfReverse(Object obj) {
		if (obj instanceof JSONArray) {
			List<Object> ll = new ArrayList<Object>();

			JSONArray arr = (JSONArray) obj;
			for (int i = 0; i < arr.size(); i++) {
				ll.add(jsonTransfReverse(arr.get(i)));
			}
			return ll;
		} else if (obj instanceof JSONObject) {
			JSONObject json = (JSONObject) obj;
			if (json.isNullObject() || json.isEmpty())
				return null;

			Map<String, Object> item = new HashMap<String, Object>();

			Iterator it = json.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry entry = (Map.Entry) it.next();
				String key = (String) entry.getKey();
				Object value = entry.getValue();
				item.put(key, jsonTransfReverse(value));
			}

			return item;
		} else {
			return obj;
		}
	}

	private Object json2map(String str) {
		return jsonTransfReverse(JSONObject.fromObject(str));
	}

	private String map2json(Map<?, ?> r) {
		return JSONObject.fromObject(r).toString();
	}
}
