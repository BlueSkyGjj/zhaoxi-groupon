package com.paic.webx.core.executer;

import com.paic.webx.core.AppConf;

public class ExecuterFactory {

	private static final String KEY_EXECUTER = "groovy_executer_type";
	private static final String EXECUTER_DEFAULT = "dynamic";

	public static IExecuter getExecuter() {
		if (EXECUTER_DEFAULT.equals(AppConf.c(KEY_EXECUTER)))
			return GroovyExecuter.newInstance();
		else
			return GroovycExecuter.newInstance();
	}
}
