package com.paic.webx.handler.impl;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.paic.webx.handler.IRequestFilter;

public class ChainHandler extends BaseHandler {

	private List<IRequestFilter> handlers;

	public void setHandlers(List<IRequestFilter> handlers) {
		this.handlers = handlers;
	}

	@Override
	public Map<String, Object> preHandleInternal(Map<String, Object> map,
			HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> r = map;
		if (handlers != null) {
			for (Iterator<IRequestFilter> iterator = handlers.iterator(); iterator
					.hasNext();) {
				IRequestFilter handle = iterator.next();
				r = handle.preHandle(r, request, response);
			}
		}
		return r;
	}

	@Override
	public void afterHandleInternal(Map<String, Object> map,
			HttpServletRequest request, HttpServletResponse response) {
		if (handlers != null) {
			for (Iterator<IRequestFilter> iterator = handlers.iterator(); iterator
					.hasNext();) {
				IRequestFilter handle = iterator.next();
				handle.afterHandle(map, request, response);
			}
		}
	}

}
