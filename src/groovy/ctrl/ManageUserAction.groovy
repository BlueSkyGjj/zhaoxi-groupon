package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

import biz.db.*

class ManageUserAction extends BaseAction {
	// 默认密码
	final String defaultPwd = '111111'

	def Map index(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		int npp = 10
		int cp = params.cp ? Integer.parseInt(params.cp) : 1

		String sql = '''
		select * from t_user where 1 = 1
		'''

		String q = params.q
		if(q && !q.contains(' ')){
			sql += " and (email like '%${q}%' or mobile like '%${q}%' or nickname like '%${q}%')"
		}

		sql += ' order by id'
		
		log.info(sql)

		def dao = XDAO.gen()
		def pager = dao.pagi(sql, null, cp, npp)

		def r = [v: 'manage/user/index']
		r.ll = pager.ll
		r.pagi = pager.genHtml('digg')
		return r
	}

	def Map loginlog(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		int npp = 10
		int cp = params.cp ? Integer.parseInt(params.cp) : 1

		String sql = '''
		select a.*,b.email,b.mobile,b.nickname from t_user_login_log a, t_user b where a.uid = b.id
		'''

		List av = []
		if(params.id){
			sql += ' and b.id = ?'
			av << params.id
		}

		sql += ' order by id desc'

		log.info(sql)
		log.info(av)

		def dao = XDAO.gen()
		def pager = dao.pagi(sql, av, cp, npp)

		def ll = pager.ll
		for(one in ll){
			if(!one.nickname){
				if(one.email)
					one.nickname = one.email
				else if(one.mobile)
					one.nickname = one.mobile
			}
		}

		def r = [v: 'manage/user/loginlog']
		r.ll = ll
		r.pagi = pager.genHtml('digg')
		return r
	}

	// ajax
	def Map get(Map params){
		// login first
		if(!params.s_admin)
			return error('会话失效，请重新登录！')

		if(!params.id)
			return error('参数缺失！')

		def dao = XDAO.gen()
		String sql = 'select * from t_user where id = ?'
		return [jsonObj: dao.queryMap(sql, [params.id])]
	}

	// ajax
	def Map update(Map params){
		// login first
		if(!params.s_admin)
			return error('会话失效，请重新登录！')

		if(!params.id)
			return error('参数缺失！')

		final String pre = 'f_'

		def item = [:]
		params.each{k, v ->
			if(k.startsWith(pre))
				item[k.substring(pre.size())] = v
		}
		log.info(item)

		item.id = params.id

		def dao = XDAO.gen()
		dao.update(item, 't_user', '')

		return [jsonObj: [time: new Date().format('yyyy-MM-dd HH:mm:ss')]]
	}

	// ajax
	def Map add(Map params){
		// login first
		if(!params.s_admin)
			return error('会话失效，请重新登录！')

		if(!params.f_nickname)
			return error('参数缺失！')

		final String pre = 'f_'

		def item = [:]
		params.each{k, v ->
			if(k.startsWith(pre))
				item[k.substring(pre.size())] = v
		}
		log.info(item)

		item.pwd = MD5.encode(defaultPwd)

		def dao = XDAO.gen()
		def ll = dao.add(item, 't_user', true)

		return [jsonObj: [id: ll[0], time: new Date().format('yyyy-MM-dd HH:mm:ss')]]
	}
}