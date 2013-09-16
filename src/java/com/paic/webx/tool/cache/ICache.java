package com.paic.webx.tool.cache;

public interface ICache {
	public void init();

	public Object get(Object id);

	public void put(Object id, Object value);

	public void remove(Object id);

	public long size();

	public void destroy();

	public void clear();

	public String getCacheName();
}