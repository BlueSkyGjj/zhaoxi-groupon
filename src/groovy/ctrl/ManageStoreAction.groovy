package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

import biz.db.*
import jxl.*

class ManageStoreAction extends BaseAction {
	// 默认密码
	final String defaultPwd = '111111'

	def Map index(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		int npp = 10
		int cp = params.cp ? Integer.parseInt(params.cp) : 1
		String cate = params.cate ?: 'all'
		String addr = params.addr ?: 'all'

		String sql = '''
		select * from t_store where 1 = 1
		'''
		List argv = []

		if(cate != 'all'){
			sql += ' and cate = ?'
			argv << cate
		}
		if(addr != 'all'){
			sql += ' and addr = ?'
			argv << addr
		}

		String q = params.q
		if(q && !q.contains(' ')){
			sql += " and (name like '%${q}%' or email like '%${q}%' or mobile like '%${q}%')"
		}

		sql += ' order by id'
		
		log.info(sql)
		log.info(argv)

		def dao = XDAO.gen()
		def pager = dao.pagi(sql, argv, cp, npp)

		if(pager.ll){
			for(one in pager.ll){
				Service.filterItemExt(one)
			}
		}

		def r = [v: 'manage/store/index']
		r.ll = pager.ll
		r.pagi = pager.genHtml('digg')
		r.r_cate = cate
		r.r_addr = addr
		return addBase(r)
	}

	// ajax
	def Map resetpwd(Map params){
		// login first
		if(!params.s_admin)
			return error('会话失效，请重新登录！')

		if(!params.id || !params.pwd)
			return error('请输入新的密码！')

		def item = [id: params.id, pwd: MD5.encode(params.pwd)]

		def dao = XDAO.gen()
		dao.update(item, 't_store', '')

		return [jsonObj: [flag: true]]
	}

	// ajax
	def Map get(Map params){
		// login first
		if(!params.s_admin)
			return error('会话失效，请重新登录！')

		if(!params.id)
			return error('参数缺失！')

		def dao = XDAO.gen()
		String sql = 'select * from t_store where id = ?'
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
		dao.update(item, 't_store', '')

		// 如果是专场
		if('1' == item.isSpecial)
			Service.refreshBrandSpecialList()

		return [jsonObj: [time: new Date().format('yyyy-MM-dd HH:mm:ss')]]
	}

	// ajax
	def Map add(Map params){
		// login first
		if(!params.s_admin)
			return error('会话失效，请重新登录！')

		if(!params.f_name)
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
		def ll = dao.add(item, 't_store', true)

		// 如果是专场
		if('1' == item.isSpecial)
			Service.refreshBrandSpecialList()

		return [jsonObj: [id: ll[0], time: new Date().format('yyyy-MM-dd HH:mm:ss')]]
	}

	def Map del(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		if(!params.id)
			return null

		def dao = XDAO.gen()
		dao.del(params.id, 't_store', '')

		return index([s_admin: params.s_admin])
	}

	// 商家信息批量上传
	def Map uploadbatch(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		return [v: 'manage/store/uploadbatch']
	}

	def Map uploadbatchpost(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		if(!params._files)
			return [v: 'manage/store/uploadbatch', error: '请选择上传文件！']

		def item = params._files.getOne(0)
		if(!item)
			return [v: 'manage/store/uploadbatch', error: '请选择上传文件！']

		// batch add
		List ll = []
		List cols = ['code', 'name', 'email', 'qq', 'mobile', 'des']
		def ww = Workbook.getWorkbook(new ByteArrayInputStream(item.binary))
		def sheet = ww.getSheet(0)

		int beginRow = 1
		for(i in beginRow..<sheet.getRows()){
			def one = [:]
			for(cc in 0..<cols.size()){
				String content = sheet.getCell(cc, i).getContents()
				content = content ? content.trim() : ''
				one[cols[cc]] = content
			}
			ll << one
		}

		String pwd = MD5.encode(defaultPwd)

		def dao = XDAO.gen()
		for(one in ll){
			one.pwd = pwd
			dao.add(one, 't_store', false)
		}

		return index([s_admin: params.s_admin])
	}

	// 商家的订单消费统计
	def Map stat(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		def dao = XDAO.gen()

		// 商家
		def storeList = dao.query('select id, name from t_store')

		def r = [v: 'manage/store/stat']
		r.storeList = storeList

		if(params.storeId){
			def action = new ManageSellerAction()
			def statResult = action.index([s_seller: [id: params.storeId]])
			r.orderStat = statResult.orderStat
		}

		return r
	}

}