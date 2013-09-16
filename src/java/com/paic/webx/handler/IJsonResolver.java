package com.paic.webx.handler;

public interface IJsonResolver {
	void init();

	String toJsonString(Object r);

	Object fromString(String str);
}
