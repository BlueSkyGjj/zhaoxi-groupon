package com.paic.webx.core.executer;

import java.util.Map;

import com.paic.webx.core.XActionException;

public interface GroovyBizLocal {
	public Map<String, Object> exe(String module, String action,
			Map<String, Object> params, boolean withFilter) throws XActionException;
}