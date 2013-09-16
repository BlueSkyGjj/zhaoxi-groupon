package org.dy.thirdpart.qqconnect;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.qq.connect.QQConnectException;
import com.qq.connect.oauth.Oauth;

public class LoginServlet extends HttpServlet {
	Logger log = Logger.getLogger(LoginServlet.class);

	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setContentType("text/html;charset=utf-8");
		try {
			response.sendRedirect(new Oauth().getAuthorizeURL(request));
		} catch (QQConnectException e) {
			log.error("Fail when use qqconnect!", e);
		}
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		doGet(request, response);
	}
}
