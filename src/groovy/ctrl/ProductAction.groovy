package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

import biz.db.*

class ProductAction extends BaseAction {
	private void filterItem(Map one, Properties conf){
		// 如果是今天发布的
		if(Utils.isToday(one.pubDate)){
			one.mark = 'new'
		}

		// 特殊标示
		if(one.mark){
			one.markStyle = conf['mark_' + one.mark + '_style']
			one.markTitle = conf['mark_' + one.mark + '_title']
		}

		// 折扣计算
		if(one.price && one.priceMarket && !one.discount){
			one.discount = Utils.round('' + one.price / one.priceMarket * 10, 1)
		}
		if(one.price && one.priceMarket && !one.priceSave){
			one.priceSave = Utils.round('' + (one.priceMarket - one.price), 1)
		}
	}

	// 评价
	private void filterItemRate(Map one){
		if(one.rateLl){
			final int totalRateNum = 5
			for(rateItem in one.rateLl){
				rateItem.rateWidth = rateItem.rate / totalRateNum * 100
			}

			// 计算平均分
			def ll = one.rateLl.collect{it.rate}.grep{it}
			one.rate = Utils.round('' + ll.sum() / ll.size(), 1)
			one.rateWidth = Utils.round('' + one.rate / totalRateNum * 100, 1)

			// 计算各个评分分的人数
			(1..5).each{
				one['rate' + it] = ll.count{rateOne -> 
					rateOne == it
				}
				one['rate' + it + 'Width'] = Utils.round('' + one['rate' + it] / ll.size() * 100, 1)
			}
		}else{
			one.rate = 0
			one.rateWidth = 0

			(1..5).each{
				one['rate' + it] = 0
				one['rate' + it + 'Width'] = 0
			}
		}
	}

	def Map search(Map params){
//		if(!params.q)
//			return list(params)

		// 选择上架的产品
		String sql = '''
		select * from t_product where status = ?
		'''
		List argv = [Conf.STATUS_PROD_ON]

		String q = params.q
		if(q && !q.contains(' ')){
			sql += " and (name like '%${q}%' or des like '%${q}%')"
		}else{
			// query nothing
			sql += ' and 1 != 1'
		}

		sql += ' order by pub_date desc'

		log.info(sql)

		def dao = XDAO.gen()
		def ll = dao.query(sql, argv)

		def conf = AppConf.loadConf()
		for(one in ll){
			filterItem(one, conf)
		}

		def r = [ll: ll, 
			r_addr: 'all', 
			r_cate: 'all', 
			r_pricerange: 'all', 
			r_seatnum: 'all', 
			r_sortBy: 'all']
		r << StyleService.index()
		return addBase(r)
	}


	def Map list(Map params){
		String cate = params.cate ?: 'all'
		String addr = params.addr ?: 'all'
		String pricerange = params.pricerange ?: 'all'
		String seatnum = params.seatnum ?: 'all'
		String sortBy = params.sortBy ?: 'all'

		// 选择上架的产品
		String sql = '''
		select * from t_product where status = ?
		'''
		List argv = [Conf.STATUS_PROD_ON]

		if(cate != 'all'){
			sql += ' and cate = ?'
			argv << cate
		}
		if(addr != 'all'){
			sql += ' and addr = ?'
			argv << addr
		}
		if(pricerange != 'all'){
			sql += ' and pricerange = ?'
			argv << pricerange
		}
		if(seatnum != 'all'){
			sql += ' and seatnum = ?'
			argv << seatnum
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
			sql += ' order by ' + field
		}
		log.info(sql)
		log.info(argv)

		def dao = XDAO.gen()
		def llAll = dao.query(sql, argv)

		// for test begin TODO
//		20.times{
//			ll << ll[2].clone()
//		}
//
//		ll[10].pubDate = new Date()
//		ll[10].des = '一个特殊的产品。。。'
//
//		ll[1].saleStatus = 'status-soldout'
//		ll[2].saleStatus = 'status-open'
//		ll[3].saleStatus = 'status-over'
//		// for test end TODO

		def conf = AppConf.loadConf()
		for(one in llAll){
			filterItem(one, conf)
		}

		// 放大显示的做区分
		def llBig = llAll.grep{'big' == it.mark}
		def ll = llAll.grep{'big' != it.mark}

//		log.debug(ll)

		def r = [ll: ll, 
			llBig: llBig, 
			r_addr: addr, 
			r_cate: cate, 
			r_pricerange: pricerange, 
			r_seatnum: seatnum, 
			r_sortBy: sortBy]
		r << StyleService.index()
		return addBase(r)
	}

	// 赠品列表
	def Map brandlist(Map params){
		String type = params.type ?: 'forgift'
		String sql = '''
		select * from t_product where type = ?
		'''

		String sortBy = params.sortBy ?: 'hot'
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
			sql += ' order by ' + field
		}
		log.info(sql)

		def dao = XDAO.gen()
		def llAll = dao.query(sql, [type])

		def conf = AppConf.loadConf()
		for(one in llAll){
			filterItem(one, conf)
		}

		// 放大显示的做区分
		def llBig = llAll.grep{'big' == it.mark}
		def ll = llAll.grep{'big' != it.mark}

//		log.debug(ll)

		def r = [ll: ll, 
			llBig: llBig, 
			r_addr: 'all', 
			r_cate: 'all', 
			r_pricerange: 'all', 
			r_seatnum: 'all', 
			r_sortBy: 'all']
		r << StyleService.index()
		return addBase(r)
	}

	def Map one(Map params){
		if(!params.id)
			return

		def argv = [params.id]

		def dao = XDAO.gen()
		def item = dao.queryMap('select * from t_product where id = ?', argv)
		if(!item)
			return

		filterItem(item, AppConf.loadConf())
		Service.filterItemExt(item)

		item.imgLl = dao.query('''
			select * from t_product_img where pid = ? order by type, seq
		'''
		, argv)

		if(item.imgLl){
			item.imgScrollLl = item.imgLl.grep{'scroll' == it.type}
			item.imgListLl = item.imgLl.grep{'list' == it.type}
		}

		item.priceDetailLl = dao.query('''
			select * from t_product_price_detail where pid = ? order by type, seq
		'''
		, argv)

		item.rateLl = dao.query('''
			select * from t_product_rate where pid = ? order by dd desc
		'''
		, argv)
		filterItemRate(item)

		def r = [item: item, 
			r_cate: item.cate, 
			r_addr: 'all', 
			r_pricerange: 'all', 
			r_seatnum: 'all'
			]
		r << StyleService.deal()
		r = addBase(r)

		// is gift show gift page
		if('forgift' == item.type)
			r.v = 'gift'

		return r
	}
}