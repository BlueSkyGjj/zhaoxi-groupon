package com.paic.webx.core.executer;

import java.util.Map;

import com.paic.webx.core.XActionException;

public interface IExecuter {
	Map<String, Object> exeXAction(String module, String action,
			Map<String, Object> params) throws XActionException;
}
