package com.paic.webx.support;

import java.util.Timer;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

public class ScheduleListener implements ServletContextListener {
	private Logger log = Logger.getLogger(ScheduleListener.class);

	// 5 mins
	private int interval = 60 * 1000 * 5;
	private int delay = 0;

	private Timer timer = null;

	@Override
	public void contextDestroyed(ServletContextEvent e) {
		timer.cancel();
	}

	@Override
	public void contextInitialized(ServletContextEvent e) {
		String s = e.getServletContext().getInitParameter("schedule-delay");
		if (s != null) {
			this.delay = Integer.parseInt(s);
		}
		s = e.getServletContext().getInitParameter("schedule-interval");
		if (s != null) {
			this.interval = Integer.parseInt(s);
		}

		log.info("Begin task schedule with delay : " + this.delay
				+ " - interval : " + this.interval);

		timer = new Timer(true);
		timer.schedule(new ActionExecuteTask(), delay, interval);
	}

}
