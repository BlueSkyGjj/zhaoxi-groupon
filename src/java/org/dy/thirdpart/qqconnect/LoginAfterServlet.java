package org.dy.thirdpart.qqconnect;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.paic.webx.core.AppPath;
import com.qq.connect.QQConnectException;
import com.qq.connect.api.OpenID;
import com.qq.connect.api.qzone.UserInfo;
import com.qq.connect.javabeans.AccessToken;
import com.qq.connect.javabeans.qzone.UserInfoBean;
import com.qq.connect.oauth.Oauth;

public class LoginAfterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(LoginAfterServlet.class);

	private String targetRedirectUrl = "";
	private boolean addWeibo = false;

	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);

		String param = config.getInitParameter("targetRedirectUrl");
		if (param != null)
			targetRedirectUrl = AppPath.WAR_NAME + param;

		addWeibo = "true".equals(config.getInitParameter("addWeibo"));
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setContentType("text/html; charset=utf-8");

		try {
			AccessToken accessTokenObj = (new Oauth())
					.getAccessTokenByRequest(request);

			if ("".equals(accessTokenObj.getAccessToken())) {
				// 我们的网站被CSRF攻击了或者用户取消了授权
				// 做一些数据统计工作
				log.warn("No response when use qqconnect token!");
				return;
			} else {
				// put token to session
				String accessToken = accessTokenObj.getAccessToken();
				long tokenExpireIn = accessTokenObj.getExpireIn();

				request.getSession().setAttribute("qqconnect_access_token",
						accessToken);
				request.getSession().setAttribute("qqconnect_token_expirein",
						String.valueOf(tokenExpireIn));

				// 利用获取到的accessToken 去获取当前用的openid -------- start
				OpenID openIDObj = new OpenID(accessToken);
				String openID = openIDObj.getUserOpenID();

				log.info("Get qq openid " + openID);
				request.getSession().setAttribute("s_qqconnect_openid", openID);

				UserInfo qzoneUserInfo = new UserInfo(accessToken, openID);
				UserInfoBean userInfoBean = qzoneUserInfo.getUserInfo();

				if (userInfoBean.getRet() == 0) {
					request.getSession().setAttribute("s_qqconnect_userinfo",
							userInfoBean);
				} else {
					log.info("Fail to get user info : " + openID);
				}

				if (addWeibo) {
					com.qq.connect.api.weibo.UserInfo weiboUserInfo = new com.qq.connect.api.weibo.UserInfo(
							accessToken, openID);
					com.qq.connect.javabeans.weibo.UserInfoBean weiboUserInfoBean = weiboUserInfo
							.getUserInfo();
					if (weiboUserInfoBean.getRet() == 0) {
						request.getSession()
								.setAttribute("s_qqconnect_weibo_userinfo",
										weiboUserInfoBean);
					} else {
						log.info("Fail to get weibo user info : " + openID);
					}
				}

				if (targetRedirectUrl != null && !"".equals(targetRedirectUrl))
					response.sendRedirect(targetRedirectUrl);
			}
		} catch (QQConnectException e) {
			log.error("Use qqconnect caught exception!", e);
		}
	}
}
