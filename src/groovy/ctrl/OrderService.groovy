package ctrl

import org.apache.log4j.Logger

import java.text.SimpleDateFormat

import biz.db.*

class OrderService {
	static Logger log = Logger.getLogger(OrderService.class)

	// 用时间年月日、用户id、随即数生成订单号
	private static String genOrderNo(Map user){
		def sf = new SimpleDateFormat('MMddHH')
		String dat = sf.format(new Date())
		String num = '' + new Random().nextInt(1000)
		String suf = num

		// 补齐3位数字
		int len = num.size()
		if(len == 1){
			suf = '00' + suf
		}else if(len == 2){
			suf = '0' + suf
		}

		return dat + '_' + user.id + '_' + suf
	}

	// 新增的订单产品，额外的产品信息需要更新进去，比如进货价，方便结算
	private static void filterOrderProduct(int orderId){
		def dao = XDAO.gen()

		String sql = '''
			update t_order_product a, t_product b set a.price_import = b.price_import 
				where a.pid = b.id and a.order_id = ?
		'''
		dao.db.executeUpdate(sql, [orderId])
	}

	// order
	static Map addOrder(Map params, boolean noDelivery){
		def user = params.s_user
		def cartLl = params.s_cartLl

		String orderNo = genOrderNo(user)

		def item = [:]
		item.uid = user.id
		item.orderNo = orderNo

		if(noDelivery){
			item.addrMobile = params.addr_mobile
			item.addrMsg = params.addr_msg
		}else{
			item.deliveryType = params.delivery_type
			item.deliveryMsg = params.delivery_msg
			item.addrId = params.addr_id
		}

		// cal amount
		item.amount = cartLl.sum{
			return it.price * it.num
		}

		try {
			def dao = XDAO.gen()
			def orderAddedLl = dao.add(item, 't_order', true)
			int orderId = orderAddedLl[0]

			// product list
			def itemLl = cartLl.collect{
				def one = [:]
				one.orderId = orderId
				one.pid = it.id
				one.price = it.price
				one.priceMarket = it.priceMarket
				one.num = it.num
				return one
			}

			for(one in itemLl){
				dao.add(one, 't_order_product', false)
			}

			// update priceImport 
			filterOrderProduct(orderId)

			return [orderNo: orderNo, orderId: orderId]
		}catch (ex) {
			log.error('Add order failed : ' + item, ex)
			return null
		}
	}

}
