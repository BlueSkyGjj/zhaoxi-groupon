package com.paic.webx;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.paic.webx.core.AppContext;
import com.paic.webx.core.AppPath;
import com.paic.webx.core.XActionException;
import com.paic.webx.core.executer.GroovyBizLocal;
import com.paic.webx.handler.IActionResultHandler;
import com.paic.webx.handler.IRequestFilter;

public class GroovyExeDispatcher extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private Logger log = Logger.getLogger(GroovyExeDispatcher.class);

	private IRequestFilter reqFilter;
	private IActionResultHandler actionResultHandler;

	private String ftlViewSuffix = ".tpl";

	public GroovyExeDispatcher() {
		super();
	}

	protected String[] getModuleAndAction(String path) {
		log.info("Module / Action path : " + path);
		path = path.substring(AppPath.WAR_NAME.length() + 1,
				path.lastIndexOf("."));
		String[] arr = path.split("/");
		return arr;
	}

	protected Map<String, Object> getActionOutputData(String module,
			String action, Map<String, Object> params) {
		GroovyBizLocal executer = AppContext.getGroovyExecutor();
		return executer.exe(module, action, params, true);
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest
	 * , javax.servlet.http.HttpServletResponse)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// get action
		String moduleStr = request.getParameter("m");
		String actionStr = request.getParameter("a");
		String dirPre = "";

		if (moduleStr == null || actionStr == null) {
			String[] arr = getModuleAndAction(request.getRequestURI());
			if (arr.length == 0) {
				this.actionResultHandler
						.warn("Param Exception: m(odule) & a(ction) are required! eg. ?m=test&a=first",
								request, response);
				return;
			}

			if (arr.length > 1) {
				actionStr = arr[arr.length - 1];
				moduleStr = arr[arr.length - 2];

				if (arr.length > 2) {
					for (int i = 0; i < arr.length - 2; i++)
						dirPre += arr[i] + "/";
				}
			} else {
				actionStr = "index";
				moduleStr = arr[arr.length - 1];
			}
		}

		if (moduleStr == null || actionStr == null) {
			this.actionResultHandler
					.warn("Param Exception: m(odule) & a(ction) are required! eg. ?m=test&a=first",
							request, response);
			return;
		}
		Map<String, Object> r = null;
		// if only show page
		String ftlPath = dirPre + moduleStr + "/" + actionStr;
		String ftlPathRoot = ftlPath + this.ftlViewSuffix;

		File targetFile = new File(request.getSession().getServletContext()
				.getRealPath(ftlPathRoot));
		boolean isFtlExists = targetFile.exists();
		if (isFtlExists) {
			r = new HashMap<String, Object>();
			r.put("v", ftlPath);
		} else {
			try {
				String moduleClass = (dirPre + moduleStr)
						.replaceAll("\\/", ".");
				if (moduleClass.startsWith("."))
					moduleClass = moduleClass.substring(1);
				Map<String, Object> requestParams = reqFilter.preHandle(null,
						request, response);

				GroovyBizLocal executer = AppContext.getGroovyExecutor();
				r = executer.exe(moduleClass, actionStr, requestParams, true);
			} catch (XActionException e) {
				log.error(e.getMessage(), e);

				this.actionResultHandler
						.warn("Method Execute Exception: " + moduleStr + " - "
								+ e.getMessage(), request, response);
				return;
			}
		}

		// handle action result
		if (r != null) {
			try {
				reqFilter.afterHandle(r, request, response);
				actionResultHandler.process(r, request, response);
			} catch (Exception e) {
				log.error(e.getMessage(), e);

				this.actionResultHandler
						.warn("Method Execute Exception: " + moduleStr + " - "
								+ e.getMessage(), request, response);
			}
		}
	}

	public void init(ServletConfig config) throws ServletException {
		super.init(config);

		String s = config.getInitParameter("ftlViewSuffix");
		if (s != null) {
			this.ftlViewSuffix = s;
		}

		initHandlers();
	}

	private void initHandlers() throws ServletException {
		ClassPathXmlApplicationContext context = AppContext.getContext();
		this.reqFilter = (IRequestFilter) context.getBean("reqFilter");
		this.actionResultHandler = (IActionResultHandler) context
				.getBean("actionResultHandler");

		if (this.actionResultHandler == null || this.reqFilter == null)
			throw new ServletException(
					"No bean define named : actionResultHandler / reqFilter");

		this.actionResultHandler.init(super.getServletContext());
	}

	public void destroy() {
		super.destroy();
	}
}
