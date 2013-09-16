package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

class IndexAction extends BaseAction {
	// *** *** *** *** *** *** *** *** *** *** *** ***
	// *** *** *** *** *** *** *** *** *** *** *** ***
	// logout by ajax
	def Map logout(Map params){
		return [s_clear: true, jsonObj: [flag: true]]
	}

	// get login user
	def Map loginuser(Map params){
		return [jsonObj: params.s_user]
	}

	// 自动登录
	def Map autologin(Map params){
		def user = AuthService.getUserByPwdEncoded(params)
		if(!user || user.error){
			return [jsonObj: [flag: false]]
		}else{
			user.remove('pwd')
			return [s_user: user, jsonObj: [flag: true, user: user]]
		}
	}

	def Map login(Map params){
		def r = [:]
		return end(r, params._action)
	}

	def Map loginpostajax(Map params){
		def user = AuthService.getUser(params)
		if(!user){
			log.info('login failed ' + params)
			return [jsonObj: [error: '账号或密码不正确！']]
		}else{
			AuthService.addUserLoginLog(user.id)

			user.remove('pwd')
			def r = [flag: true, user: user]
			if(params.referAddrList){
				r.addrList = AuthService.getAddrList(user.id)
			}

			return [s_user: user, jsonObj: r]
		}
	}

	def Map loginpost(Map params){
		def user = AuthService.getUser(params)
		if(!user){
			log.info('login failed ' + params)
			def r = [error: '账号或密码不正确！']
			r << StyleService.login()
			r.v = 'auth/login'
			return r
		}else{
			AuthService.addUserLoginLog(user.id)

			// 登录成功后返回上次访问页面
			user.remove('pwd')
			String referUrl = params.referUrl ?: AppPath.WAR_NAME + '/index.htm'
			log.info(referUrl)
			return [s_user: user, v: 'redirect:' + referUrl]
		}
	}

	def Map signup(Map params){
		def r = [:]
		return end(r, params._action)
	}

	def Map signuppost(Map params){
		def user = AuthService.addUser(params)
		if(user.error){
			log.info('sign up failed ' + params)
			def r = [error: user.error]
			r << StyleService.signup()
			r.v = 'auth/signup'
			return r
		}else{
			// 成功就默认登录
			def r = index(params)
			r.s_user = user
			return r
		}
	}

	// 获取密码
	def Map getpwd(Map params){
		def r = [:]
		return end(r, params._action)
	}

	def Map getpwdpost(Map params){
		String loginType = params.logintype ?: 'email'
		String login = params.email

		// 验证是否存在
		def user = AuthService.getUserByLogin(login, loginType)
		if(!user){
			def r = StyleService.getpwd()
			r.error = '该用户不存在！'
			return r
		}

		String verifycode = Utils.genVerifyCode()
		AuthService.updateVerifycode4getpwd(user.id, verifycode)

		if(loginType == 'email'){
			// send email
			Utils.sendEmailSingle('朝夕购用户密码找回', Utils.getTpl4getpwd('email', user.id, verifycode), login)
			def r = [:]
			r.sendemail = true
			return end(r, params._action)
		}else{
			// send sms
			Utils.sendSmsSingle('朝夕购用户密码找回', Utils.getTpl4getpwd('sms', user.id, verifycode), login)
			def r = [:]
			r.r_uid = user.id
			r.sendsms = true
			return end(r, params._action)
		}
	}

	// 发送验证码后录入验证
	def Map getpwdrepost(Map params){
		String verifycode = params.verifycode
		String uid = params.uid

		if(!uid || !verifycode)
			return null

		if(!AuthService.checkVerifycode4getpwd(uid, verifycode)){
			def r = StyleService.getpwd()
			r.error = '验证码输入错误，请重新输入！'
			return r
		}

		String newPwd = Utils.genVerifyCode()
		AuthService.resetPwd(uid, newPwd)

		def r = StyleService.login()
		r.ok = '密码已经修改为 - ' + newPwd
		return r
	}

	// *** *** *** *** *** *** *** *** *** *** *** ***
	// *** *** *** *** *** *** *** *** *** *** *** ***
	def Map index(Map params){
		return new ProductAction().list(params)
	}

	def Map giftlist(Map params){
		return new ProductAction().brandlist(params)
	}

	def Map brandlist(Map params){
		params.type = params.type ?: 'sheraton'
		return new ProductAction().brandlist(params)
	}

	def Map search(Map params){
		return new ProductAction().search(params)
	}

	// 购物车
	def Map cart(Map params){
		return new CartAction().cart(params)
	}

	// 提交订单，显示支付
	def Map cartcheck(Map params){
		return new CartAction().cartcheck(params)
	}

	// 留言
	def Map leavemsg(Map params){
		def r = [:]
		return end(r, params._action)
	}

	def Map leavemsgpost(Map params){
		Service.addLeavemsg(params)

		def r = [:]
		return end(r, params._action)
	}

	// 商务合作
	def Map feedback(Map params){
		def r = [:]
		return end(r, params._action)
	}

	def Map feedbackpost(Map params){
		Service.addFeedback(params)

		def r = [:]
		return end(r, params._action)
	}

	// 每日签到
	def Map daysign(Map params){
		if(!params.s_user){
			return [jsonObj: [flag: false, needlogin: true]]
		}

		def r = AuthService.addUserDaysign(params.s_user.id)
		return [jsonObj: r]
	}

	// 公共数据获取
	// 省市关联查询
	def Map getDistLl(Map params){
		if(!params.pid){
			def r = [ll: []]
			return [jsonObj: r]
		}

		def r = [ll: Service.getDistLl(params.pid)]
		return [jsonObj: r]
	}
}