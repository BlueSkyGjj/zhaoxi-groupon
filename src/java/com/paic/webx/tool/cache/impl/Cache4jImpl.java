package com.paic.webx.tool.cache.impl;

import net.sf.cache4j.Cache;
import net.sf.cache4j.CacheException;

import org.apache.log4j.Logger;

import com.paic.webx.tool.cache.ICache;

public class Cache4jImpl implements ICache {
	Logger log = Logger.getLogger(Cache4jImpl.class);

	private Cache cache;

	private String name = "cache4j";

	public void init() {
	}

	public Object get(Object id) {
		try {
			return cache.get(id);
		} catch (CacheException e) {
			log.error(e);
			return null;
		}
	}

	public Cache getCache() {
		return cache;
	}

	public void setCache(Cache cache) {
		this.cache = cache;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void put(Object id, Object value) {
		try {
			cache.put(id, value);
		} catch (CacheException e) {
			log.error(e);
		}
	}

	public void remove(Object id) {
		try {
			cache.remove(id);
		} catch (CacheException e) {
			log.error(e);
		}
	}

	public long size() {
		return cache.size();
	}

	public void clear() {
		try {
			cache.clear();
		} catch (CacheException e) {
			log.error(e);
		}
	}

	public void destroy() {
		cache = null;
	}

	public String getCacheName() {
		return name;
	}
}