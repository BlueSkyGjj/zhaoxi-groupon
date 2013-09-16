package com.paic.webx.upload;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileUploadException;

public class MultipartPostFilter implements Filter {

	protected String denyExt = null;
	protected String allowExt = null;
	protected int maxSizeAllow = 1024 * 1024;
	private String encoding = "utf-8";

	public void destroy() {
		denyExt = null;
		allowExt = null;
	}

	public void doFilter(ServletRequest req, ServletResponse resp,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest sreq = (HttpServletRequest) req;
		HttpServletResponse sresp = (HttpServletResponse) resp;

		MultipartHttpServletRequest mreq = new MultipartHttpServletRequest(sreq);
		mreq.setAllowExtensions(allowExt);
		mreq.setDeniedExtensions(denyExt);
		mreq.setMaxSize(maxSizeAllow);
		mreq.setEncoding(encoding);

		try {
			mreq.init();
		} catch (FileUploadException e) {
			// throw new ServletException("Upload Filter Failed " +
			// e.getMessage());

			sresp.getWriter().println(
					"Error Occured, Upload Exception <br /> "
							+ "Upload Filter Failed " + e.getMessage());
			sresp.getWriter().flush();
			sresp.getWriter().close();
			return;
		}

		chain.doFilter(mreq, resp);
	}

	public void init(FilterConfig conf) throws ServletException {
		this.denyExt = conf.getInitParameter("denyext");
		this.allowExt = conf.getInitParameter("allowext");

		String value = conf.getInitParameter("maxsize");
		if (value != null)
			this.maxSizeAllow = Integer.parseInt(value);

		value = conf.getInitParameter("encoding");
		if (value != null)
			this.encoding = value;
	}

}
