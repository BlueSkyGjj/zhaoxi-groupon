package com.paic.webx.support;

import java.io.IOException;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.paic.webx.tool.LManager;

public class ProfilingFilter implements Filter {

	protected String pat = null;

	Logger log = LManager.lprofiling();

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		String uri = req.getRequestURI();
		if (pat == null || Pattern.matches(pat, uri)) {
			String queryStr = req.getQueryString();

			long beginTime = System.currentTimeMillis();
			chain.doFilter(request, response);
			log.info("[" + req.getMethod() + " - "
					+ (System.currentTimeMillis() - beginTime) + "]" + uri
					+ "//" + queryStr);
		} else {
			chain.doFilter(request, response);
		}
	}

	public void init(FilterConfig filterConfig) throws ServletException {
		this.pat = filterConfig.getInitParameter("pat");
	}

	public void destroy() {
	}

}
