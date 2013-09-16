package com.paic.webx.core;

import org.apache.log4j.Logger;

public abstract class XAction {

	public static final String KEY_MODULE = "c_module";
	public static final String KEY_ACTION = "c_action";

	protected Logger log = Logger.getLogger(this.getClass());

	public XAction() {
	}
}
