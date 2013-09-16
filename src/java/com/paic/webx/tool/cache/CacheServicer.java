package com.paic.webx.tool.cache;

import java.util.HashMap;
import java.util.Map;

import org.springframework.context.support.ClassPathXmlApplicationContext;
import com.paic.webx.core.AppContext;

// use spring singleton better
public class CacheServicer {

	private static String BEAN_DEFAULT = "cacheDefault";

	private static Object lock = new Object();
	private static Map<String, ICache> instances = new HashMap<String, ICache>();

	public static ICache getInstance(String beanName) {
		if (beanName == null)
			beanName = BEAN_DEFAULT;
		String cacheKey = beanName;

		ICache inst = instances.get(cacheKey);
		if (inst == null) {
			synchronized (lock) {
				if (inst == null) {
					inst = getCache(beanName);
				}
				instances.put(cacheKey, inst);
			}
		}
		return inst;
	}

	public static ICache getInstance() {
		return getInstance(null);
	}

	private static ICache getCache(String beanName) {
		ClassPathXmlApplicationContext context = AppContext.getContext();
		return (ICache) context.getBean(beanName);
	}
}
