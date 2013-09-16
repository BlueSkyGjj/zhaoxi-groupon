package com.paic.webx.core.executer;

import groovy.lang.GroovyObject;

import java.util.Map;

import org.apache.log4j.Logger;
import org.codehaus.groovy.control.CompilationFailedException;

import com.paic.webx.core.AppConf;
import com.paic.webx.core.XActionException;

public class GroovycExecuter implements IExecuter {
	final Logger log = Logger.getLogger(GroovycExecuter.class);

	boolean loadPerformanceDebug = false;

	public boolean isLoadPerformanceDebug() {
		return loadPerformanceDebug;
	}

	public void setLoadPerformanceDebug(boolean loadPerformanceDebug) {
		this.loadPerformanceDebug = loadPerformanceDebug;
	}

	public static GroovycExecuter newInstance() {
		GroovycExecuter executer = new GroovycExecuter();
		executer.setLoadPerformanceDebug("true".equals(AppConf
				.c("groovy_load_debug")));
		return executer;
	}

	public Map<String, Object> exeXAction(String module, String action,
			Map<String, Object> params) {
		try {
			long beginTime = System.currentTimeMillis();

			GroovyObject obj = (GroovyObject) Class.forName(module)
					.newInstance();
			// invoke initialized method if return value is not null just return
			@SuppressWarnings("unchecked")
			Map<String, Object> r = (Map<String, Object>) obj.invokeMethod(
					action, new Object[] { params });

			if (loadPerformanceDebug)
				log.info("Exe - " + obj.getClass().getName() + "." + action
						+ " : " + (System.currentTimeMillis() - beginTime));

			return r;
		} catch (InstantiationException e) {
			throw new XActionException(e);
		} catch (IllegalAccessException e) {
			throw new XActionException(e);
		} catch (CompilationFailedException e) {
			throw new XActionException(e);
		} catch (Exception e) {
			throw new XActionException(e);
		}
	}
}
