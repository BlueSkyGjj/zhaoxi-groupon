package com.paic.webx.support;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.TimerTask;

import org.apache.log4j.Logger;

import com.paic.webx.core.executer.GroovyBizLocal;
import com.paic.webx.core.executer.GroovyBizLocalImpl;
import com.paic.webx.tool.PropHelper;

public class ActionExecuteTask extends TimerTask {
	private static final String CONF_FILE = "/task.properties";

	private Logger log = Logger.getLogger(ActionExecuteTask.class);
	private List<TaskConf> taskList = new ArrayList<TaskConf>();

	public ActionExecuteTask() {
		Properties prop = PropHelper.loadProperties(CONF_FILE);
		Set<Object> set = prop.keySet();
		for (Iterator iterator = set.iterator(); iterator.hasNext();) {
			String key = (String) iterator.next();
			String line = prop.getProperty(key);

			log.info("Task defination : " + line);
			String[] arr = line.split(",");
			if (arr.length == 2) {
				taskList.add(new TaskConf(arr[0], arr[1]));
			}
		}
	}

	@Override
	public void run() {
		GroovyBizLocal executer = new GroovyBizLocalImpl();
		for (TaskConf task : taskList) {
			executer.exe(task.module, task.action, null, false);
		}
	}

	static class TaskConf {
		public TaskConf(String module, String action) {
			this.module = module;
			this.action = action;
		}

		String module;
		String action;
	}

}
