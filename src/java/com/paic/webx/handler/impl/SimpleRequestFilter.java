package com.paic.webx.handler.impl;

import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.paic.webx.core.AppConf;
import com.paic.webx.support.Token;

public class SimpleRequestFilter extends BaseHandler {
	private String originPat = "*";

	public void setOriginPat(String originPat) {
		this.originPat = originPat;
	}

	public Map<String, Object> preHandleInternal(Map<String, Object> rmap,
			HttpServletRequest request, HttpServletResponse response) {
		rmap.put("_uri", request.getRequestURI());
		rmap.put("_method", request.getMethod());
		rmap.put("_agent", request.getHeader("user-agent"));
		return rmap;
	}

	public void afterHandleInternal(Map<String, Object> map,
			HttpServletRequest request, HttpServletResponse response) {
		map.put("_uri", request.getRequestURI());
		map.put("_method", request.getMethod());
		map.put("_ip", request.getRemoteAddr());
		map.put("_host", request.getRemoteHost());

		map.put("_agent", request.getHeader("user-agent"));
		map.put("_current_time", System.currentTimeMillis() + "");
		// rmap.put("_conf", AppConf.getPropsFilter("web_"));

		// ie6 sucks
		map.put("isIE6", isIE6(request.getHeader("user-agent")));

		map.put("conf", AppConf.loadConf());

		// set token
		if (map.get("token") != null) {
			String _token = Token.getTokenString(request.getSession());
			map.put("_token", _token);
		}

		response.addHeader("Access-Control-Allow-Origin", originPat);

		// add headers
		Map<String, String> headers = (Map<String, String>) map.get("headers");
		if (headers != null) {
			Iterator<Map.Entry<String, String>> it = headers.entrySet()
					.iterator();
			while (it.hasNext()) {
				Map.Entry<String, String> entry = it.next();
				response.addHeader(entry.getKey(), entry.getValue());
			}
		}
	}

	private Boolean isIE6(String ua) {
		if (ua == null)
			return false;

		ua = ua.toLowerCase();
		return new Boolean(ua.indexOf("opera") == -1
				&& ua.indexOf("msie 6") != -1);
	}
}
