package com.paic.webx.handler.impl;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.paic.webx.upload.MultipartHttpServletRequest;

public class MultipartRequestFilter extends BaseHandler {

	public Map<String, Object> preHandleInternal(Map<String, Object> rmap,
			HttpServletRequest request, HttpServletResponse response) {
		// upload files
		if (request instanceof MultipartHttpServletRequest) {
			final String key = "_files";
			MultipartHttpServletRequest mreq = (MultipartHttpServletRequest) request;
			rmap.put(key, mreq.getBean());
		}
		return rmap;
	}

	public void afterHandleInternal(Map<String, Object> map,
			HttpServletRequest request, HttpServletResponse response) {
	}
}
