package com.paic.webx.tool.cache.bean;

import net.sf.cache4j.CacheConfig;
import net.sf.cache4j.CacheException;
import net.sf.cache4j.impl.BlockingCache;
import net.sf.cache4j.impl.SynchronizedCache;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.BeanNameAware;
import org.springframework.beans.factory.InitializingBean;

public abstract class Cache4jProxy implements InitializingBean, BeanNameAware {
	private CacheConfig configBean;
	private String cacheId;
	private String cacheDesc;
	private Object proxy;
	private String cacheMode;
	protected final Logger logger;

	public Cache4jProxy() {
		this.cacheId = "defaultCache";
		this.cacheDesc = "des";
		this.cacheMode = "sync";

		this.logger = Logger.getLogger(Cache4jProxy.class);
	}

	public void afterPropertiesSet() throws Exception {
		this.logger.info("creating cache for config" + this.configBean);
		((Cache4jConfigBean) this.configBean).setCacheDesc(this.cacheDesc);
		((Cache4jConfigBean) this.configBean).setCacheId(this.cacheId);

		if ("sync".equals(this.cacheMode)) {
			this.logger.info("you set the cache mode is syncronized!!");
			SynchronizedCache cache = new SynchronizedCache();
			cache.setCacheConfig(this.configBean);
			this.proxy = cache;
		} else if ("blocking".equals(this.cacheMode)) {
			this.logger.info("you set the cache mode is blocking!!");
			BlockingCache cache = new BlockingCache();
			cache.setCacheConfig(this.configBean);
			this.proxy = cache;
		} else {
			this.logger
					.error("you must set the cache mode with blocking or sync");
			throw new CacheException(
					"you must set the cache mode with blocking or sync");
		}
		this.logger.info("the cache " + this.cacheId + " created ok!!");
	}

	public CacheConfig getConfigBean() {
		return this.configBean;
	}

	public void setConfigBean(CacheConfig configBean) {
		this.configBean = configBean;
	}

	public void setBeanName(String name) {
		this.cacheId = name;
	}

	public Object getProxy() {
		return this.proxy;
	}

	public void setProxy(Object proxy) {
		this.proxy = proxy;
	}

	public String getCacheMode() {
		return this.cacheMode;
	}

	public void setCacheMode(String cacheMode) {
		this.cacheMode = cacheMode;
	}

	public String getCacheDesc() {
		return this.cacheDesc;
	}

	public void setCacheDesc(String cacheDesc) {
		this.cacheDesc = cacheDesc;
	}

	public String getCacheId() {
		return this.cacheId;
	}

	public void setCacheId(String cacheId) {
		this.cacheId = cacheId;
	}
}