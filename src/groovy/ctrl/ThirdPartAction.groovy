package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

import biz.db.*

class ThirdPartAction extends BaseAction {
	private int addUser(Map item){
		def dao = XDAO.gen()
		def ll = dao.add(item, 't_user', true)
		return ll[0]
	}

	// qq login
	def Map qqlogin(Map params){
		def r = [:]
		def userInfo = params.s_qqconnect_userinfo

		if(userInfo){
			log.info(userInfo)

			def dao = XDAO.gen()
			// check if exists
			def item = dao.queryMap('''
				select id, mobile, email from t_user where third_part = ? and nickname = ?
			'''
			, ['qq', userInfo.nickname])


			def s_user = [:]
			s_user.nickname = userInfo.nickname
			s_user.thirdPart = 'qq'

			if(item){
				s_user.id = item.id
				s_user.email = item.email
				s_user.mobile = item.mobile
			}else{
				s_user.id = addUser([thirdPart: 'qq', nickname: userInfo.nickname])
			}

			// 新增登录日志
			AuthService.addUserLoginLog(s_user.id)

			r.s_user = s_user
		}

		// 默认返回首页
		def indexR = new ProductAction().list(params)
		r << indexR

		return r
	}

	// 支付
	def Map alipay(Map params){
		def r = [:]
		r.jsonObj = [flag: true]
		return r
	}
}