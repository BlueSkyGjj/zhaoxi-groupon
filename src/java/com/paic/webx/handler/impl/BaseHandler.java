package com.paic.webx.handler.impl;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.paic.webx.handler.IRequestFilter;
import com.paic.webx.tool.LManager;

public abstract class BaseHandler implements IRequestFilter {
	protected Logger log = LManager.lprofiling();
	private boolean profiling = false;

	public void setProfiling(boolean profiling) {
		this.profiling = profiling;
	}

	@Override
	public Map<String, Object> preHandle(Map<String, Object> map,
			HttpServletRequest request, HttpServletResponse response) {
		long beginTime = System.currentTimeMillis();
		if (map == null)
			map = new HashMap<String, Object>();
		Map<String, Object> r = preHandleInternal(map, request, response);
		if (profiling) {
			long costs = System.currentTimeMillis() - beginTime;
			log.info("[Request Filter preHandle : " + getName() + "]" + costs
					+ " : " + request.getRequestURI());
		}
		return r;
	}

	@Override
	public void afterHandle(Map<String, Object> map,
			HttpServletRequest request, HttpServletResponse response) {
		long beginTime = System.currentTimeMillis();
		afterHandleInternal(map, request, response);
		if (profiling) {
			long costs = System.currentTimeMillis() - beginTime;
			log.info("[Request Filter afterHandle : " + getName() + "]" + costs
					+ " : " + request.getRequestURI());
		}
	}

	@Override
	public String getName() {
		return this.getClass().getSimpleName();
	}

	abstract void afterHandleInternal(Map<String, Object> map,
			HttpServletRequest request, HttpServletResponse response);

	abstract Map<String, Object> preHandleInternal(Map<String, Object> map,
			HttpServletRequest request, HttpServletResponse response);
}
