package com.paic.webx.tool.cache.bean;

import org.springframework.beans.factory.FactoryBean;

import net.sf.cache4j.Cache;

@SuppressWarnings("rawtypes")
public class Cache4jProxyFactoryBean extends Cache4jProxy implements
		FactoryBean {
	private Class cacheInterface;

	public Cache4jProxyFactoryBean() {
		this.cacheInterface = Cache.class;
	}

	public Object getObject() throws Exception {
		return getProxy();
	}

	public Class getObjectType() {
		return ((this.cacheInterface == null) ? this.cacheInterface
				: getProxy().getClass());
	}

	public boolean isSingleton() {
		return false;
	}

	public Class getCacheInterface() {
		return this.cacheInterface;
	}

	public void setCacheInterface(Class cacheInterface) {
		this.cacheInterface = cacheInterface;
	}
}