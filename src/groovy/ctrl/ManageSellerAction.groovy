package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

import biz.db.*

class ManageSellerAction extends BaseAction {
	def Map login(Map params){
		if(!params.login || !params.pwd)
			return [v: 'manage/seller/login', error: '请输入用户名和密码！']

		def dao = XDAO.gen()

		String sql = 'select * from t_store where code = ? and pwd = ?'
		def store = dao.queryMap(sql, [params.login, MD5.encode(params.pwd)])

		if(!store)
			return [v: 'manage/seller/login', error: '用户名或密码不正确！']
	
		params.s_seller = store

		def r = [:]
		r << index(params)
		r.s_seller = params.s_seller
		return r
	}

	def Map logout(Map params){
		return [v: 'manage/seller/login', s_del_seller: true]
	}

	// 获取订单销售统计数据
	private Map getOrderStat(List prodList){
		def orderStat = [:]
		if(!prodList)
			return orderStat

		// 按月结算
		def datBegin = prodList[0].payDd
		def datEnd = prodList[-1].payDd

		int monthNum = datEnd.month - datBegin.month
		if(!monthNum)
			monthNum = 1

		// 合计
		double allAmount = 0
		double allAmountImport = 0
		int allNum = 0

		def monthSale = []
		for(i in 0..<monthNum){
			def dat1 = datBegin.clone()
			dat1.month = datBegin.month + i
			dat1.date = 1

			def dat2 = dat1.clone()
			dat2.month = datBegin.month + i + 1

			def subLl = prodList.grep{it.payDd >= dat1 && it.payDd < dat2}

			def monthStat = [month: datBegin.format('yyyy-MM'), ll: []]
			monthStat.num = subLl.sum{it.num}
			monthStat.amount = Utils.round('' + subLl.sum{it.price * it.num}, 2)
			monthStat.amountImport = Utils.round('' + subLl.sum{(it.priceImport ?: 0) * it.num}, 2)

			allNum += monthStat.num
			allAmount += monthStat.amount
			allAmountImport += monthStat.amountImport

			def pidSet = subLl.collect{it.pid}.unique()
			for(pid in pidSet){
				def groupProdList = subLl.grep{it.pid == pid}
				monthStat.ll << [id: pid, num: groupProdList.sum{it.num}, 
					name: groupProdList[0]['name'], 
					amount: Utils.round('' + groupProdList.sum{it.price * it.num}, 2),
					amountImport: Utils.round('' + groupProdList.sum{(it.priceImport ?: 0)* it.num}, 2)
					]
			}

			monthSale << monthStat
		}

		orderStat.monthSale = monthSale
		orderStat.allAmountImport = allAmountImport
		orderStat.allAmount = allAmount
		orderStat.allNum = allNum
		return orderStat
	}

	// 销售统计
	def Map index(Map params){
		// login first
		if(!params.s_seller)
			return [v: 'manage/seller/login']

		// 所有的产品订单
		String queryAllOrderList = '''
		select a.pay_dd, b.*, c.name from t_order a, t_order_product b, t_product c 
			where a.status = 3 and a.id = b.order_id and b.pid = c.id and c.store_id = ? 
			order by a.pay_dd
		'''
		List argv = [params.s_seller.id]

		def dao = XDAO.gen()
		def prodList = dao.query(queryAllOrderList, argv)

		def r = [v: 'manage/seller/index']
		r.orderStat = getOrderStat(prodList)
		r.monthRange = 1..12
		return r
	}

	// 产品列表
	def Map prodlist(Map params){
		// login first
		if(!params.s_seller)
			return [v: 'manage/seller/login']

		int npp = 10
		int cp = params.cp ? Integer.parseInt(params.cp) : 1

		String sql = '''
		select * from t_product where status = ? and store_id = ? 
			order by id desc
		'''
		List argv = [Conf.STATUS_PROD_ON, params.s_seller.id]

		def dao = XDAO.gen()
		def pager = dao.pagi(sql, argv, cp, npp)
		if(pager.ll){
			for(one in pager.ll){
				Service.filterItemExt(one)
			}
		}

		def r = [v: 'manage/seller/prodlist']
		r.ll = pager.ll
		r.pagi = pager.genHtml('digg')
		return r
	}

	// 用户信息
	def Map setting(Map params){
		// login first
		if(!params.s_seller)
			return [v: 'manage/seller/login']

		def r = [v: 'manage/seller/setting']
		return r
	}

	def Map settingpost(Map params){
		// login first
		if(!params.s_seller)
			return [v: 'manage/seller/login']

		String keys = 'contact mobile email qq des'
		def item = Utils.getByKeys(params, keys)
		if(!item){
			def r = [v: 'manage/seller/setting']
			r.error = '参数缺失！'
			return r
		}

		item.id = params.s_seller.id

		def dao = XDAO.gen()
		dao.update(item, 't_store', '')

		item.each{k, v ->
			params.s_seller[k] = v
		}

		def r = [v: 'manage/seller/setting']
		r.s_seller = params.s_seller
		r.success = '信息更新成功！' + new Date().format('yyyy-MM-dd HH:mm:ss')
		return r	
	}
}