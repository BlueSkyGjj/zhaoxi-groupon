package com.paic.webx.upload;

import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.apache.commons.fileupload.FileUploadException;

public class MultipartHttpServletRequest extends HttpServletRequestWrapper {

	private MultipartFormBean bean;
	private HttpServletRequest request;

	private String deniedExtensions;
	private String allowExtensions;
	private int maxSize = 1024 * 1024;
	private String encoding = "utf-8";

	public MultipartHttpServletRequest(HttpServletRequest req) {
		super(req);
		this.request = req;
	}

	public void init() throws FileUploadException {
		UploadUtil uu = new UploadUtil();
		uu.setDeniedExtensions(deniedExtensions);
		uu.setAllowedExtensions(allowExtensions);
		uu.setMaxSize(maxSize);
		uu.setEncoding(encoding);

		this.bean = uu.getFileFromRequest(request);
	}

	public String getEncoding() {
		return encoding;
	}

	public void setEncoding(String encoding) {
		this.encoding = encoding;
	}

	public Map getParameterMap() {
		Map paramMap = new HashMap();
		paramMap.putAll(super.getParameterMap());
		paramMap.putAll(this.bean.getFields());
		return paramMap;
	}

	public String[] getParameterValues(String name) {
		Object[] values = this.bean.getFeildValues(name);
		if (values != null) {
			String[] arr = new String[values.length];
			for (int i = 0; i < arr.length; i++) {
				arr[i] = (String) values[i];
			}
			return arr;
		}
		return super.getParameterValues(name);
	}

	public String getParameter(String name) {
		return this.bean.getFieldValue(name);
	}

	public Enumeration getParameterNames() {
		Set paramNames = new HashSet();
		Enumeration paramEnum = super.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			paramNames.add(paramEnum.nextElement());
		}
		paramNames.addAll(this.bean.getFields().keySet());
		return Collections.enumeration(paramNames);
	}

	public FormFileBean getBlobParameter(String name) {
		return this.bean.getOne(name);
	}

	public String getDeniedExtensions() {
		return deniedExtensions;
	}

	public void setDeniedExtensions(String deniedExtensions) {
		this.deniedExtensions = deniedExtensions;
	}

	public int getMaxSize() {
		return maxSize;
	}

	public void setMaxSize(int maxSize) {
		this.maxSize = maxSize;
	}

	public MultipartFormBean getBean() {
		return bean;
	}

	public String getAllowExtensions() {
		return allowExtensions;
	}

	public void setAllowExtensions(String allowExtensions) {
		this.allowExtensions = allowExtensions;
	}

}
