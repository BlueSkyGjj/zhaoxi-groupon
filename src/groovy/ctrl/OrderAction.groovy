package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

import biz.db.*

class OrderAction extends BaseAction {
	private void filter(Map one, Properties conf){
		// 合计金额
		if(!one.amount && one.productLl){
			for(prod in one.productLl){
				prod.amount = prod.price * prod.num
			}
			one.amount = one.productLl.sum{
				return it.amount
			}
		}

		one.noDelivery = Conf.DELI_NO_NEED == one.deliveryType
		one.deliveryTimeDes = conf['delivery_time_des_' + one.deliveryType]

		// 12345 -> 暂未付款 付款失败 交易成功 取消订单 已过期
		one.canDelete = one.status in ['1', '2', '4']
		one.canPay = one.status in ['1', '2']

		// 状态
		one.statusLabel = conf['order_status_label_for_' + one.status]
	}

	def Map nopay(Map params){
		params.nopay = true
		return all(params)
	}

	def Map nofeedback(Map params){
		params.nofeedback = true
		return all(params)
	}

	def Map all(Map params){
		if(!params.s_user)
			return needlogin('/orderlist/all.htm')

		int uid = params.s_user.id

		String sql = '''
			select * from t_order where uid = ? and status != ?
		'''
		List argv = [uid, Conf.STATUS_ORDER_DELETED]
		if(params.nopay){
			sql += ' and (status = ? or status = ?)'
			argv << Conf.STATUS_ORDER_NEW
			argv << Conf.STATUS_ORDER_PAY_FAIL
		}
		if(params.nofeedback){
			sql += ' and feedback = 0'
		}
		sql += ' order by dd desc'

		def dao = XDAO.gen()
		def orderLl = dao.query(sql, argv)
		
		List productLl = null
		if(orderLl){
			String clause = orderLl*.id.join(',')
			String sqlProd = """
			select a.*, b.order_id, b.num 
				from t_product a, t_order_product b
				where b.order_id in (${clause}) 
				and a.id = b.pid
			"""
			productLl = dao.query(sqlProd)
		}

		if(orderLl && productLl){
			def conf = AppConf.loadConf()
			for(one in orderLl){
				one.productLl = productLl.grep{it.orderId == one.id}
				filter(one, conf)
			}
		}

		def r = [:]
		r.orderLl = orderLl
		r.r_type = params._action
		r << StyleService.orderlist()
		return r
	}

	def Map one(Map params){
		if(!params.s_user)
			return needlogin('/orderlist/all.htm')

		if(!params.id)
			return null
		int uid = params.s_user.id

		String sql = 'select * from t_order where id = ? and uid = ?'

		def dao = XDAO.gen()
		def order = dao.queryMap(sql, [params.id, uid])
		if(!order)
			return null

		String sqlProd = """
		select a.*, b.num 
			from t_product a, t_order_product b
			where a.id = b.pid and b.order_id = ?
		"""
		def productLl = dao.query(sqlProd, [params.id])
		order.productLl = productLl

		def conf = AppConf.loadConf()
		filter(order, conf)

		def r = [:]

		// delivery
		if(!order.noDelivery){
			r.addr = dao.queryMap('select * from t_user_addr where id = ?', [order.addrId])
		}

		r.order = order
		r.productLl = productLl
		r << StyleService.order()

		return r
	}

	def Map del(Map params){
		if(!params.s_user)
			return needlogin('/orderlist/all.htm')

		if(!params.id)
			return null
		int uid = params.s_user.id

		String sql = 'select id from t_order where id = ? and uid = ?'

		def dao = XDAO.gen()
		def order = dao.queryMap(sql, [params.id, uid])
		if(!order)
			return null

		// 9 -> deleted
		dao.db.executeUpdate('update t_order set status = 9 where id = ?', [params.id])

		params._action = 'all'
		return all(params)
	}

	// TODO
	def Map pay(Map params){
		if(!params.s_user)
			return needlogin('/orderlist/all.htm')

		def r = one(params)
		r << StyleService.pay()
		return r
	}

	def Map paypost(Map params){
		if(!params.s_user)
			return needlogin('/orderlist/all.htm')
	}

	def Map feedbacklist(Map params){
		if(!params.s_user)
			return needlogin('/orderlist/all.htm')
	}
}