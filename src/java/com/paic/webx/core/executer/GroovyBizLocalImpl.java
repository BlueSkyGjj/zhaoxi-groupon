package com.paic.webx.core.executer;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.paic.webx.core.XActionException;
import com.paic.webx.core.executer.ExecuterFilter.ExecuterFilterConf;

public class GroovyBizLocalImpl implements GroovyBizLocal {

	Logger log = Logger.getLogger(GroovyBizLocalImpl.class);

	public Map<String, Object> exe(String module, String action,
			Map<String, Object> params, boolean withFilter)
			throws XActionException {
		log.debug("Begin execute : " + module + "." + action);

		IExecuter executer = ExecuterFactory.getExecuter();
		if (params != null) {
			params.put("_module", module);
			params.put("_action", action);
		}

		ExecuterFilter filter = ExecuterFilter.getInstance();
		if (withFilter) {
			List<ExecuterFilterConf> list = filter.getFilterList(module,
					action, "before");
			for (ExecuterFilterConf one : list) {
				Map<String, Object> preFilter = this.exe(one.module,
						one.action, params, false);
				if (preFilter != null)
					return preFilter;
			}
		}

		Map<String, Object> rmap = executer.exeXAction(module, action, params);
		if (withFilter) {
			List<ExecuterFilterConf> listAfter = filter.getFilterList(module,
					action, "after");
			for (ExecuterFilterConf one : listAfter) {
				Map<String, Object> afterFilter = this.exe(one.module,
						one.action, rmap, false);
				if (afterFilter != null)
					return afterFilter;
			}
		}

		return rmap;
	}

}
