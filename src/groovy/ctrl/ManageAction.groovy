package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

import biz.db.*

class ManageAction extends BaseAction {
	final String loginName = 'admin'

	def Map login(Map params){
		if(!params.login || !params.pwd)
			return [v: 'manage/login', error: '请输入用户名和密码！']

		// 密码在配置文件中
		String loginPwd = AppConf.c('admin-pwd')
		if(loginName != params.login || loginPwd != MD5.encode(params.pwd))
			return [v: 'manage/login', error: '用户名或密码不正确！']

		params.s_admin = 'Administrator'

		def r = [:]
		r << index(params)
		r.s_admin = params.s_admin
		return r
	}

	def Map logout(Map params){
		return [v: 'manage/login', s_del_admin: true]
	}

	// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	def Map index(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		int npp = 10
		int cp = params.cp ? Integer.parseInt(params.cp) : 1

		String cate = params.cate ?: 'all'
		String addr = params.addr ?: 'all'
		String sortBy = params.sortBy ?: 'all'

		String sql = '''
		select * from t_product where 1 = 1
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

		if(sortBy in ['latest', 'hot', 'asc', 'desc']){
			String field = 'pub_date desc'
			switch (sortBy) {
			    case 'hot':
			        field = 'sale_num desc'
			        break
			    case 'asc':
			        field = 'price asc'
			        break
			    case 'desc':
			        field = 'price desc'
			        break
			    default:
			        break
			}
			sql += ' order by status desc, ' + field
		}else{
			sql += ' order by status desc'
		}

		log.info(sql)
		log.info(argv)

		def dao = XDAO.gen()
		def pager = dao.pagi(sql, argv, cp, npp)

		if(pager.ll){
			for(one in pager.ll){
				Service.filterItemExt(one)
			}
		}

		// 商家
		def storeList = dao.query('select id, name from t_store')

		def r = [v: 'manage/index']
		r.ll = pager.ll
		r.pagi = pager.genHtml('digg')
		r.storeList = storeList
		return addBase(r)
	}

	// ajax
	def Map refreshprodnum(Map params){
		// login first
		if(!params.s_admin)
			return error('会话失效，请重新登录！')

		Service.refreshCateAndAddrCc()
		return [jsonObj: [time: new Date().format('yyyy-MM-dd HH:mm:ss')]]
	}

	// ajax
	def Map getprod(Map params){
		// login first
		if(!params.s_admin)
			return error('会话失效，请重新登录！')

		if(!params.id)
			return error('参数缺失！')

		def dao = XDAO.gen()
		String sql = 'select * from t_product where id = ?'
		return [jsonObj: dao.queryMap(sql, [params.id])]
	}

	// ajax
	def Map updateprod(Map params){
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
		dao.update(item, 't_product', '')
		return [jsonObj: [time: new Date().format('yyyy-MM-dd HH:mm:ss')]]
	}

	// ajax
	def Map addprod(Map params){
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

		def dao = XDAO.gen()
		def ll = dao.add(item, 't_product', true)
		return [jsonObj: [id: ll[0], time: new Date().format('yyyy-MM-dd HH:mm:ss')]]
	}

	// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// product image operation
	def Map listprodimg(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		if(!params.id)
			return error('参数缺失！')

		def ll = []

		def dao = XDAO.gen()
		List argv = [params.id]
		def srcItem = dao.queryMap('select image_index, dd from t_product where id = ?', argv)
		ll << [dd: srcItem.dd, path: srcItem.imageIndex, seq: 1, type: 'index', title: '主页展示图', des: '']
		
		def imgLl = dao.query('select * from t_product_img where pid = ? order by type, seq', argv)
		ll.addAll(imgLl)

		return [v: 'manage/prodimg', ll: ll, r_pid: params.id]
	}

	def Map addprodimg(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		if(!params._files || !params.pid)
			return error('参数缺失！')

		String keys = 'pid type seq title des'
		def item = Utils.getByKeys(params, keys)
		if(!item)
			return error('参数缺失！')

		def fileItem = params._files.getOne(0)
		if(!fileItem){
			def r = listprodimg([id: params.pid, s_admin: params.s_admin])
			r.error = '请选择图片！'
			return r
		}
			
		item.path = Service.writeImg(item.pid, fileItem)
		def dao = XDAO.gen()
		def ll = dao.add(item, 't_product_img', true)

		return listprodimg([id: params.pid, s_admin: params.s_admin])
	}

	def Map updateprodimg(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		if(!params._files || !params.id || !params.pid)
			return error('参数缺失！')

		String keys = 'id pid type seq title des'
		def item = Utils.getByKeys(params, keys)
		if(!item)
			return error('参数缺失！')

		// delete first
		def dao = XDAO.gen()
		def srcItem = dao.queryMap('select path from t_product_img where id = ? and pid = ?', [params.id, params.pid])
		if(!srcItem)
			return error('参数缺失！')

		if(!Service.delImg(params.pid, srcItem.path))
			log.warn('Delete image file failed : ' + params.id)

		def fileItem = params._files.getOne(0)
		if(!fileItem){
			def r = listprodimg([id: params.pid, s_admin: params.s_admin])
			r.error = '请选择图片！'
			return r
		}
		
		item.path = Service.writeImg(item.pid, fileItem)
		dao.update(item, 't_product_img', '')

		return listprodimg([id: params.pid, s_admin: params.s_admin])
	}

	def Map setprodimg(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		if(!params._files || !params.pid)
			return error('参数缺失！')

		// delete first
		def dao = XDAO.gen()
		def srcItem = dao.queryMap('select image_index from t_product where id = ?', [params.pid])
		if(!Service.delImg(params.pid, srcItem.imageIndex))
			log.warn('Delete image file failed : ' + params.pid)

		def fileItem = params._files.getOne(0)
		if(!fileItem){
			def r = listprodimg([id: params.pid, s_admin: params.s_admin])
			r.error = '请选择图片！'
			return r
		}
		
		String path = Service.writeImg(params.pid, fileItem)
		dao.db.executeUpdate('update t_product set image_index = ? where id = ?', [path, params.pid])

		return listprodimg([id: params.pid, s_admin: params.s_admin])
	}

	// delete ajax
	def Map delprodimg(Map params){
		// login first
		if(!params.s_admin)
			return error('会话失效，请重新登录！')

		if(!params.id || !params.pid)
			return error('参数缺失！')

		// delete first
		def dao = XDAO.gen()
		def srcItem = dao.queryMap('select path from t_product_img where id = ? and pid = ?', [params.id, params.pid])
		if(!srcItem)
			return error('参数缺失！')

		if(!Service.delImg(params.id, srcItem.path))
			log.warn('Delete image file failed : ' + params.id)

		dao.db.executeUpdate('delete from t_product_img where id = ?', [params.id])
		return [jsonObj: [flag: true]]
	}

	// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// *** *** ***
	// product price
	def Map setprodprice(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		if(!params.id)
			return error('参数缺失！')

		def dao = XDAO.gen()
		List argv = [params.id]
		
		def ll = dao.query('''
			select * from t_product_price_detail where pid = ? order by seq
			'''
			, argv)

		return [v: 'manage/prodprice', ll: ll, r_pid: params.id]
	}

	def Map setprodpricepost(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		if(!params.pid)
			return error('参数缺失！')

		def dao = XDAO.gen()
		// delete first
		dao.db.executeUpdate('delete from t_product_price_detail where pid = ?', [params.pid])

		// insert batch
		int len = params.l_seq ? params.l_seq.size() : 0
		if(len){
			def keys = 'seq content price num priceTotal'.split(' ')
			for(i in 0..<len){
				def item = [:]
				for(key in keys){
					item[key] = params['l_' + key][i]
				}
				item.pid = params.pid

				dao.add(item, 't_product_price_detail', false)
			}
		}

		def r = setprodprice([id: params.pid, s_admin: params.s_admin])
		r.time = new Date().format('yyyy-MM-dd HH:mm:ss')
		return r
	}

	// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// 友情链接
	def Map refreshlink(Map params){
		Service.refreshConfLink()
		return [jsonObj: [time: new Date().format('yyyy-MM-dd HH:mm:ss')]]
	}

	def Map listlink(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		def dao = XDAO.gen()
		def ll = dao.query('select * from t_conf_link order by type, seq')

		return [v: 'manage/listlink', ll: ll]
	}

	def Map addlink(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		String keys = 'type seq label link target pic'
		def item = Utils.getByKeys(params, keys)
		if(!item)
			return error('参数缺失！')

		def dao = XDAO.gen()
		def ll = dao.add(item, 't_conf_link', true)

		return listlink([s_admin: params.s_admin])
	}

	def Map setlink(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		if(!params.id)
			return error('参数缺失！')

		String keys = 'id type seq label link target pic'
		def item = Utils.getByKeys(params, keys)
		if(!item)
			return error('参数缺失！')
		item.dd = new Date()

		def dao = XDAO.gen()
		dao.update(item, 't_conf_link', '')

		return listlink([s_admin: params.s_admin])
	}

	// delete ajax
	def Map dellink(Map params){
		// login first
		if(!params.s_admin)
			return error('会话失效，请重新登录！')

		if(!params.id)
			return error('参数缺失！')

		def dao = XDAO.gen()
		dao.db.executeUpdate('delete from t_conf_link where id = ?', [params.id])
		return [jsonObj: [flag: true]]
	}

	// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// 系统设置
	def Map refreshsys(Map params){
		Service.refreshConfSys()
		return [jsonObj: [time: new Date().format('yyyy-MM-dd HH:mm:ss')]]
	}

	def Map listsys(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		def dao = XDAO.gen()
		def ll = dao.query('select * from t_conf_sys order by type, seq')

		return [v: 'manage/listsys', ll: ll]
	}

	def Map addsys(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		String keys = 'type seq name value'
		def item = Utils.getByKeys(params, keys)
		if(!item)
			return error('参数缺失！')

		def dao = XDAO.gen()
		def ll = dao.add(item, 't_conf_sys', true)

		return listsys([s_admin: params.s_admin])
	}

	def Map setsys(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		if(!params.id)
			return error('参数缺失！')

		String keys = 'id type seq name value'
		def item = Utils.getByKeys(params, keys)
		if(!item)
			return error('参数缺失！')

		def dao = XDAO.gen()
		dao.update(item, 't_conf_sys', '')

		return listsys([s_admin: params.s_admin])
	}

	// delete ajax
	def Map delsys(Map params){
		// login first
		if(!params.s_admin)
			return error('会话失效，请重新登录！')

		if(!params.id)
			return error('参数缺失！')

		def dao = XDAO.gen()
		dao.db.executeUpdate('delete from t_conf_sys where id = ?', [params.id])
		return [jsonObj: [flag: true]]
	}

	// 基础信息
	// cate/addr/seatnum/pricerange
	// ajax
	def Map refreshBaseCateAddr(Map params){
		// login first
		if(!params.s_admin)
			return error('会话失效，请重新登录！')

		Service.refreshBaseCateAddr()
		return [jsonObj: [time: new Date().format('yyyy-MM-dd HH:mm:ss')]]
	}

	def Map listbase(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']
		
		String type = params.type ?: 'cate'
		String table = 't_' + type

		def dao = XDAO.gen()
		def ll = dao.query('select * from ' + table + ' order by pcode, seq')
		return [v: 'manage/listbase', ll: ll, r_type: type]
	}

	def Map updatebase(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		String type = params.type ?: 'cate'
		if(!['cate', 'addr', 'seatnum', 'pricerange'].contains(type))
			return null

		String table = 't_' + type

		def dao = XDAO.gen()
		// delete first
		dao.db.executeUpdate('delete from ' + table)

		// insert batch
		int len = params.l_seq ? params.l_seq.size() : 0
		if(len){
			def keys = 'seq code name'.split(' ')
			for(i in 0..<len){
				def item = [:]
				for(key in keys){
					item[key] = params['l_' + key][i]
				}
				dao.add(item, table, false)
			}
		}

		def r = listbase([type: type, s_admin: params.s_admin])
		r.time = new Date().format('yyyy-MM-dd HH:mm:ss')
		return r
	}
}