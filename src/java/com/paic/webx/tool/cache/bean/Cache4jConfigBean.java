package com.paic.webx.tool.cache.bean;

import net.sf.cache4j.impl.CacheConfigImpl;

public class Cache4jConfigBean extends CacheConfigImpl {
	static final String LRU = "lru";
	static final String LFU = "lfu";
	static final String FIFO = "fifo";
	static final String REF_STRONG = "strong";
	static final String REF_SOFT = "soft";
	static final int STRONG = 1;
	static final int SOFT = 2;

	public void setCacheId(Object cacheId) {
		this._cacheId = cacheId;
	}

	public void setCacheDesc(String cacheDesc) {
		this._cacheDesc = cacheDesc;
	}

	public void setTtl(long ttl) {
		this._ttl = ((ttl < 0L) ? 0L : ttl);
	}

	public void setIdleTime(long idleTime) {
		this._idleTime = ((idleTime < 0L) ? 0L : idleTime);
	}

	public void setMaxMemorySize(long maxMemorySize) {
		this._maxMemorySize = ((maxMemorySize < 0L) ? 0L : maxMemorySize);
	}

	public void setMaxSize(int maxSize) {
		this._maxSize = ((maxSize < 0) ? 0 : maxSize);
	}

	public void setType(String type) {
		this._type = type == null ? "common" : type;
	}

	public void setAlgorithm(String algorithm) {
		this._algorithm = algorithm == null ? LRU : algorithm;
	}

	public void setReference(String reference) {
		this._reference = reference == null ? REF_STRONG : reference;
		setRefernceint();
	}

	public String toString() {
		return getCacheId() + "::" + getCacheDesc() + "$$";
	}
}