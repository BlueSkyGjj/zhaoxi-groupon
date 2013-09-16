package com.paic.webx.handler.impl;

import java.util.Arrays;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.paic.webx.core.AppConf;

@SuppressWarnings("rawtypes")
public class AttributeRequestFilter extends BaseHandler {

	public Map<String, Object> preHandleInternal(Map<String, Object> rmap,
			HttpServletRequest request, HttpServletResponse response) {
		// request parameters
		Map map = request.getParameterMap();
		Iterator it = map.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry entry = (Map.Entry) it.next();
			String key = (String) entry.getKey();
			Object v = entry.getValue();
			if (v != null) {
				if (v instanceof String[]) {
					String[] arr = (String[]) v;
					if (key.startsWith("l_"))
						rmap.put(key, Arrays.asList(arr));
					else
						rmap.put(key, arr[0]);
				} else {
					rmap.put(
							key,
							key.startsWith("l_") ? Arrays
									.asList(new Object[] { v }) : v);
				}
			}
		}

		// session attributes
		HttpSession s = request.getSession();
		Enumeration e = s.getAttributeNames();
		while (e.hasMoreElements()) {
			String k = (String) e.nextElement();
			rmap.put(k, s.getAttribute(k));
		}

		return rmap;
	}

	public void afterHandleInternal(Map<String, Object> rmap,
			HttpServletRequest request, HttpServletResponse response) {
		String skipPre = AppConf.c("web_request_handle_skip_pre");
		// request parameters
		Map map = request.getParameterMap();
		Iterator it = map.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry entry = (Map.Entry) it.next();
			String key = (String) entry.getKey();

			if (skipPre != null && key.startsWith(skipPre))
				continue;

			Object v = entry.getValue();
			if (v != null) {
				if (v instanceof String[]) {
					String[] arr = (String[]) v;
					if (key.startsWith("l_"))
						rmap.put("r_" + key, Arrays.asList(arr));
					else
						rmap.put("r_" + key, arr[0]);
				} else {
					rmap.put(
							"r_" + key,
							key.startsWith("l_") ? Arrays
									.asList(new Object[] { v }) : v);
				}
			}
		}

		// session attributions
		HttpSession s = request.getSession();
		Iterator it2 = rmap.entrySet().iterator();
		while (it2.hasNext()) {
			Map.Entry entry = (Map.Entry) it2.next();
			String rk = (String) entry.getKey();

			if (rk.startsWith("s_")) {
				// clear session attributes
				if (rk.equals("s_clear")) {
					Enumeration attNames = s.getAttributeNames();
					while (attNames.hasMoreElements()) {
						String attName = (String) attNames.nextElement();
						s.removeAttribute(attName);
						attNames = s.getAttributeNames();
					}
				} else {
					// delete or add
					if (rk.startsWith("s_del_"))
						s.removeAttribute(rk.replaceAll("s_del", "s"));
					else {
						Object value = entry.getValue();
						s.setAttribute(rk, value);
					}
				}
			}
		}

		Enumeration e = s.getAttributeNames();
		while (e.hasMoreElements()) {
			String k = (String) e.nextElement();
			if (!rmap.keySet().contains(k))
				rmap.put(k, s.getAttribute(k));
		}

		// cookies
		Iterator<Map.Entry<String, Object>> it3 = rmap.entrySet().iterator();
		int expiredAgeInSec = 60 * 60 * 24 * 7;
		Integer expiredAgeInSecVal = (Integer) rmap.get("expired");
		if (expiredAgeInSecVal != null)
			expiredAgeInSec = expiredAgeInSecVal.intValue();
		while (it3.hasNext()) {
			Map.Entry<String, Object> entry = it3.next();
			String rk = (String) entry.getKey();

			if (rk.startsWith("cookie_")) {
				// delete or add
				if (rk.startsWith("cookie_del_")) {
					Cookie cc = new Cookie(
							rk.substring("cookie_del_".length()), null);
					cc.setPath("/");
					cc.setMaxAge(0);
					response.addCookie(cc);
				} else {
					List<String> domains = (List<String>) rmap.get("domain_ll");
					if (domains != null) {
						Object value = entry.getValue();
						for (int i = 0; i < domains.size(); i++) {
							String domain = (String) domains.get(i);
							Cookie cc = new Cookie(rk.substring("cookie_"
									.length()), value.toString());
							cc.setPath("/");
							cc.setMaxAge(expiredAgeInSec);
							cc.setDomain(domain);
							response.addCookie(cc);
						}
					}
				}
			}
		}
	}
}
