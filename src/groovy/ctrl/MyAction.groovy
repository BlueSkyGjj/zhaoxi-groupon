package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

import biz.db.*

class MyAction extends BaseAction {
	def Map index(Map params){
		return [v: 'my/index']
	}
	
	// ajax
	def Map getaddr(Map params){
		if(!params.s_user)
			return error('relogin')

		if(!params.id)
			return error('no parameters')

		int uid = params.s_user.id
		String id = params.id

		String sql = '''
			select * from t_user_addr where uid = ? and id = ?
		'''

		def dao = XDAO.gen()
		def item = dao.queryMap(sql, [uid, id])

		return [jsonObj: [flag: true, item: item]]
	}

	// ajax
	def Map deladdr(Map params){
		if(!params.s_user)
			return error('relogin')

		if(!params.id)
			return error('no parameters')

		int uid = params.s_user.id
		String id = params.id

		String sql = '''
			update t_user_addr set status = ? where uid = ? and id = ?
		'''

		def dao = XDAO.gen()
		dao.db.executeUpdate(sql, ['0', uid, id])

		return [jsonObj: [flag: true]]
	}

	// ajax
	// 新增收货地址
	def Map addaddr(Map params){
		if(!params.s_user)
			return error('relogin')

		String keys = 'prov prov_id city city_id dist dist_id addr addr_code mobile addr_name'
		def item = Utils.getByKeys(params, keys)
		log.info(item)

		if(!item)
			return error('no parameters')

		item.uid = params.s_user.id

		def dao = XDAO.gen()
		def ll = dao.add(item, 't_user_addr', true)
		int id = ll[0]

		AuthService.mergeAddrUnderline(item)
		return [jsonObj: [flag: true, id: id, des: item.des]]
	}

	// form post
	// 修改收货地址
	def Map updateaddr(Map params){
		if(!params.s_user)
			return needlogin('/my/settingaddr.htm')

		String keys = 'id prov prov_id city city_id dist dist_id addr addr_code mobile addr_name'
		def item = Utils.getByKeys(params, keys)
		log.info(item)

		if(!item)
			return errorpage()

		// add
		if(!item.id){
			addaddr(params)
		}else{
			// update
			def dao = XDAO.gen()
			String sql = '''
				select id from t_user_addr where uid = ? and id = ?
			'''
			def one = dao.queryMap(sql, [params.s_user.id, item.id])
			// 先点击修改，然后删除，但因为记录是逻辑删除，所以记录还存在
			if(!one)
				return errorpage()

			dao.update(item, 't_user_addr', '')
		}

		return settingaddr(params)
	}

	def Map settingaddr(Map params){
		if(!params.s_user)
			return needlogin('/my/settingaddr.htm')

		def r = [:]
		r.provLl = Service.getProvLl()
		r.addrList = AuthService.getAddrList(params.s_user.id)
		r << StyleService.settingaddr()
		return r
	}

	// 基本信息
	def Map setting(Map params){
		if(!params.s_user)
			return needlogin('/my/setting.htm')

		def r = [:]
		r << StyleService.setting()
		return r
	}

	// 获取验证码
	def Map getverifycode(Map params){
		if(!params.s_user)
			return error('请先登录！')

		String mobile = params.mobile
		if(!mobile)
			return [jsonObj: [flag: false]]

		String code = Utils.genVerifyCode()
		// TODO
		String msg = """
		您正在朝夕购网站进行用户设置，请在验证码输入框中输入：
		${code}。如非本人操作，请忽略该信息。【朝夕购】
		"""
		Utils.sendSms(mobile, msg)

		return [jsonObj: [flag: true], s_code: code]
	}

	// 重置手机
	def Map mobilerebind(Map params){
		if(!params.s_user)
			return needlogin('/my/setting.htm')

		if(!params.mobile || !params.verifycode){
			def r = setting(params)
			r.error = '手机号码或验证码缺少！'
			return r
		}

		log.info(params.verifycode)
		log.info(params.s_code)
		if(params.verifycode != params.s_code){
			def r = setting(params)
			r.error = '验证码不正确！'
			return r
		}

		def dao = XDAO.gen()
		def item = [:]
		item.id = params.s_user.id
		item.mobile = params.mobile
		dao.update(item, 't_user', '')

		def r = setting(params)

		// 更新session user
		def user_new = params.s_user
		user_new.mobile = params.mobile
		r.s_user = user_new
		return r
	}

	// 重置email
	def Map emailrebind(Map params){
		if(!params.s_user)
			return needlogin('/my/setting.htm')

		if(!params.email){
			def r = setting(params)
			r.error = '邮箱地址缺少！'
			return r
		}

		log.info(params.email)

		def dao = XDAO.gen()
		def item = [:]
		item.id = params.s_user.id
		item.email = params.email
		dao.update(item, 't_user', '')

		def r = setting(params)

		// 更新session user
		def user_new = params.s_user
		user_new.email = params.email
		r.s_user = user_new
		return r
	}

	// 重置密码
	def Map passwordreset(Map params){
		if(!params.s_user)
			return needlogin('/my/setting.htm')

		if(!params.pwdOld || !params.pwd || !params.pwd2){
			def r = setting(params)
			r.error = '新旧密码缺少！'
			return r
		}

		if(params.pwd != params.pwd2){
			def r = setting(params)
			r.error = '新密码和确认密码不一致！'
			return r
		}

		def dao = XDAO.gen()

		// 旧密码是否一样
		def one = dao.queryMap('select pwd from t_user where id = ?', [params.s_user.id])
		if(!one){
			// ...怎么可能！！！
			return null
		}

		if(one.pwd !=  MD5.encode(params.pwdOld)){
			def r = setting(params)
			r.error = '当前密码不正确！'
			return r
		}

		def item = [:]
		item.id = params.s_user.id
		item.pwd = MD5.encode(params.pwd)
		dao.update(item, 't_user', '')

		def r = setting(params)
		r.msg = '密码已经修改！'
		return r
	}

	def Map nicknamereset(Map params){
		if(!params.s_user)
			return needlogin('/my/setting.htm')

		if(!params.nickname){
			def r = setting(params)
			r.error = '昵称缺少！'
			return r
		}

		def dao = XDAO.gen()

		// 判断昵称是否存在
		def one = dao.queryMap('select id from t_user where nickname = ?', [params.nickname])
		if(one && one.id != params.s_user.id){
			def r = setting(params)
			r.error = '昵称已经存在！'
			return r
		}

		def item = [:]
		item.id = params.s_user.id
		item.nickname = params.nickname
		dao.update(item, 't_user', '')

		def r = setting(params)

		// 更新session user
		def user_new = params.s_user
		user_new.nickname = params.nickname
		r.s_user = user_new
		return r
	}
}