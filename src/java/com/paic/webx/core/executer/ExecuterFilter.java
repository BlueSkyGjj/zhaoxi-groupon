package com.paic.webx.core.executer;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import com.paic.webx.core.AppConf;

public class ExecuterFilter {
	private final static String CONF_PATH = "/filter.properties";
	private static ExecuterFilter instance = new ExecuterFilter();

	private ExecuterFilter() {
		Properties props = AppConf.load(CONF_PATH);
		Set<Object> set = props.keySet();
		for (Object key : set) {
			String val = props.getProperty((String) key);
			addConf(val);
		}
	}

	public static ExecuterFilter getInstance() {
		return instance;
	}

	private List<ExecuterFilterConf> confList = new ArrayList<ExecuterFilterConf>();

	private void addConf(String val) {
		if (val == null)
			return;

		String[] arr = val.split(",");
		if (arr.length != 4)
			return;

		ExecuterFilterConf one = new ExecuterFilterConf();
		one.type = arr[0];
		one.pat = arr[1];
		one.module = arr[2];
		one.action = arr[3];
		confList.add(one);
	}

	public List<ExecuterFilterConf> getFilterList(String module, String action,
			String type) {
		List<ExecuterFilterConf> list = new ArrayList<ExecuterFilterConf>();
		for (int i = 0; i < confList.size(); i++) {
			ExecuterFilterConf one = confList.get(i);
			if (one.type.equals(type) && mat(one.pat, module, action))
				list.add(one);
		}
		return list;
	}

	// TODO
	private boolean mat(String pat, String module, String action) {
		if (pat.equals("*"))
			return true;

		if (pat.equals(module + "." + action))
			return true;

		return false;
	}

	class ExecuterFilterConf {
		String type;
		String pat;
		String module;
		String action;
	}
}
