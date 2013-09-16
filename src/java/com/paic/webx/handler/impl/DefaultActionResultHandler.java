package com.paic.webx.handler.impl;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.paic.webx.core.AppConf;
import com.paic.webx.core.AppPath;
import com.paic.webx.handler.IActionResultHandler;
import com.paic.webx.handler.IJsonResolver;
import com.paic.webx.handler.ITplResolver;
import com.paic.webx.handler.TplException;
import com.paic.webx.upload.FormFileBean;
import com.paic.webx.upload.UploadUtil;

public class DefaultActionResultHandler implements IActionResultHandler {
	private IJsonResolver jsonResolver;
	private ITplResolver tplResolver;
	private String encoding = "utf-8";
	private String callbackKey = "callback";

	public void setCallbackKey(String callbackKey) {
		this.callbackKey = callbackKey;
	}

	Logger log = Logger.getLogger(DefaultActionResultHandler.class);

	public void setJsonResolver(IJsonResolver jsonResolver) {
		this.jsonResolver = jsonResolver;
	}

	public void setTplResolver(ITplResolver tplResolver) {
		this.tplResolver = tplResolver;
	}

	public void setEncoding(String encoding) {
		this.encoding = encoding;
	}

	public String getViewSuffix() {
		return this.tplResolver.getSuf();
	}

	private void writeResponse(String str, HttpServletResponse response)
			throws IOException {
		PrintWriter writer = response.getWriter();
		writer.write(str);
		writer.flush();
		writer.close();
	}

	@Override
	public void init(ServletContext context) throws ServletException {
		try {
			this.tplResolver.init(context, "/");
		} catch (TplException e) {
			throw new ServletException(e);
		}
	}

	@Override
	public void process(Map<String, Object> r, HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String v = (String) r.get("v");
		if (v == null || v.trim().equals("")) {
			// download file
			String downFileName = (String) r.get("downFileName");
			if (downFileName != null) {
				String contentType = (String) r.get("contentType");
				byte[] binary = (byte[]) r.get("downBytes");

				if (contentType != null) {
					response.setContentType(contentType);
					ServletOutputStream os = response.getOutputStream();

					os.write(binary);
					os.flush();
					os.close();
				} else {
					FormFileBean binaryBean = new FormFileBean();
					binaryBean.setFileName(downFileName);
					binaryBean.setBinary(binary);
					UploadUtil uu = new UploadUtil();
					uu.downloadFile(binaryBean, response);
				}

				return;
			}

			// output string
			String sss = (String) r.get("output");
			if (sss != null) {
				String eee = (String) r.get("encoding");
				eee = eee != null ? eee : AppConf.c("web_output_encoding");
				// weblogic 8.1.5 not support
				// response.setCharacterEncoding(eee);
				String contentType = (String) r.get("contentType");
				if (contentType == null)
					contentType = "text/plain;charset=" + eee;
				response.setContentType(contentType);

				writeResponse(sss, response);
				return;
			}

			// json output item
			Object jsonObj = r.get("jsonObj");
			if (jsonObj != null) {
				String eee = (String) r.get("encoding");
				eee = eee != null ? eee : AppConf.c("web_output_encoding");

				String contentType = (String) r.get("contentType");
				if (contentType == null)
					contentType = "application/json;charset=" + eee;

				// weblogic 8.1.5 not support
				// response.setCharacterEncoding(eee);
				response.setContentType(contentType);

				String str = jsonResolver.toJsonString(jsonObj);
				// jsonp
				String callback = request.getParameter(callbackKey);
				if (callback != null
						&& "get".equalsIgnoreCase(request.getMethod())) {
					str = callback + "(" + str + ")";
				}

				writeResponse(str, response);
				return;
			}

			// json output
			Object jsonFlag = r.get("json");
			if (jsonFlag != null) {
				String eee = (String) r.get("encoding");
				eee = eee != null ? eee : AppConf.c("web_output_encoding");

				String contentType = (String) r.get("contentType");
				if (contentType == null)
					contentType = "application/json;charset=" + eee;

				// weblogic 8.1.5 not support
				// response.setCharacterEncoding(eee);
				response.setContentType(contentType);

				String str = jsonResolver.toJsonString(r);
				// jsonp
				String callback = request.getParameter(callbackKey);
				if (callback != null
						&& "get".equalsIgnoreCase(request.getMethod())) {
					str = callback + "(" + str + ")";
				}

				writeResponse(str, response);
				return;
			}

			// response header
			String responseStatus = (String) r.get("responseStatus");
			if (responseStatus != null) {
				int status = Integer.parseInt(responseStatus);
				response.setStatus(status);
				return;
			}

			// return blank page if v is null
			return;
		}

		v = v.trim();
		// redirect or
		final String redirectPrefix = "redirect:";
		if (v.startsWith(redirectPrefix)) {
			v = v.substring(redirectPrefix.length());
			response.sendRedirect(v);
			return;
		}

		// output using template engine
		String ftlViewSuffix = getViewSuffix();
		if (!v.endsWith(ftlViewSuffix))
			v += ftlViewSuffix;

		r.put("app_name", AppPath.WAR_NAME);

		try {
			// download template output source
			if ("true".equals(r.get("down_src"))) {
				// download output to a file local
				if ("file".equals(r.get("down_type"))) {
					Writer pt = new FileWriter(new File(
							(String) r.get("down_file")));
					tplResolver.out(r, pt, v);
				} else {
					final int size = 1024;
					ByteArrayOutputStream bos = new ByteArrayOutputStream(size);
					PrintWriter pt = new PrintWriter(bos);
					tplResolver.out(r, pt, v);

					FormFileBean binaryBean = new FormFileBean();
					binaryBean.setFileName((String) r.get("down_file"));
					binaryBean.setBinary(bos.toByteArray());
					UploadUtil uu = new UploadUtil();
					uu.downloadFile(binaryBean, response);
				}
			} else {
				response.setContentType("text/html;charset=" + encoding);
				tplResolver.out(r, response.getWriter(), v);
			}
		} catch (Exception e) {
			log.error(e.getMessage(), e);
			warn(e.getMessage(), request, response);
		}
	}

	@Override
	public void warn(String str, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			final String errorFtl = "/error" + getViewSuffix();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("msg", str);

			map.put("app_name", AppPath.WAR_NAME);

			tplResolver.out(map, response.getWriter(), errorFtl);
		} catch (TplException e) {
			log.error(e.getMessage(), e);
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}
	}

}
